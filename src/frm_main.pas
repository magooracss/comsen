unit frm_main;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, lNetComponents, AbZipper, Forms, Controls,
  Graphics, Dialogs, EditBtn, StdCtrls, Buttons, ComCtrls, AbArcTyp, lNet, lFTP;

type

  { TfrmMain }

  TfrmMain = class(TForm)
    abZip: TAbZipper;
    BitBtn1: TBitBtn;
    btnProcess: TBitBtn;
    edCFGFile: TFileNameEdit;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    fileList: TListBox;
    FTP: TLFTPClientComponent;
    MemoText: TMemo;
    pbProcess: TProgressBar;
    procedure abZipArchiveProgress(Sender: TObject; Progress: Byte;
      var Abort: Boolean);
    procedure BitBtn1Click(Sender: TObject);
    procedure btnProcessClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FTPConnect(aSocket: TLSocket);
    procedure FTPControl(aSocket: TLSocket);
    procedure FTPError(const msg: string; aSocket: TLSocket);
    procedure FTPSent(aSocket: TLSocket; const Bytes: Integer);
    procedure FTPSuccess(aSocket: TLSocket; const aStatus: TLFTPStatus);
  private
    FLastN: Integer;
    FDLSize: Int64;
    FDLDone: Int64;

    function allOK: boolean;
    procedure loadCFG;
    procedure CompressFiles;
    procedure sendFiles;
  public
    procedure processAll;

  end;

var
  frmMain: TfrmMain;

implementation
{$R *.lfm}
uses
  SD_Configuracion
  ;

{ TfrmMain }

procedure TfrmMain.btnProcessClick(Sender: TObject);
begin
  if allOk then
  	 processAll;
end;
procedure TfrmMain.FormShow(Sender: TObject);
begin
  edCFGFile.FileName:= 'C:\Dropbox\bak\Trabajo\Trabajo\Windows\comsen\exe\default.cfg';
  loadCFG;
end;

function TfrmMain.allOK: boolean;
begin
  Result:=( (FileExists(edCFGFile.FileName))
            and (fileList.Items.Count > 0) ) ;
end;

procedure TfrmMain.loadCFG;
var
  flist: TStringList;
begin
  if (TRIM(edCFGFile.FileName) <> EmptyStr) then
  begin
    try
      flist:= TStringList.Create;
      LeerSeccion(edCFGFile.FileName ,SECCION_FLS, flist );
      fileList.Items.Assign(flist);
    finally
      flist.free;
    end;
  end;
end;

procedure TfrmMain.processAll;
begin
  pbProcess.Position:= 0;
  loadCFG;
  CompressFiles;
  Application.ProcessMessages;
  sendFiles;
end;

(*******************************************************************************
*** COMPRESS
*******************************************************************************)

procedure TfrmMain.abZipArchiveProgress(Sender: TObject; Progress: Byte;
  var Abort: Boolean);
begin
   pbProcess.Position:= Progress;
end;


procedure TfrmMain.CompressFiles;
var
  its: integer;
  theFile: string;
begin
  theFile:= ExtractFilePath(Application.ExeName) + LeerDato(edCFGFile.FileName, SECCION_APP, CMPR_NAME);
  if FileExists(theFile) then
   RenameFile(theFile, theFile + '.bak');
  with abZip do
  begin
    FileName:= theFile;
    its:= 0;
    while its < fileList.Items.Count do
    begin
      AddFiles(filelist.Items[its],faArchive);
      inc (its);
    end;
    Save;
    CloseArchive;
  end;
end;

(*******************************************************************************
*** FTP
*******************************************************************************)

procedure TfrmMain.sendFiles;
var
  fileCmp:string;
Begin
  with FTP do
  begin
    Connect(LeerDato(edCFGFile.FileName, SECCION_APP, FTP_HOST)
                , Word(StrToInt(LeerDato(edCFGFile.FileName, SECCION_APP, FTP_PORT)))
                );
  end;

  fileCmp:= ExtractFilePath(Application.ExeName) + LeerDato(edCFGFile.FileName, SECCION_APP, CMPR_NAME);
  if FileExists(fileCmp) then
  begin
    FDLSize:= FileSize(fileCmp);
    FDLDone:= 0;
    FLastN:= 0;
    //FTP.Disconnect();
  end;
end;


procedure TfrmMain.FTPConnect(aSocket: TLSocket);
begin
   FTP.Authenticate(LeerDato(edCFGFile.FileName, SECCION_APP, FTP_USR)
                   ,LeerDato(edCFGFile.FileName, SECCION_APP, FTP_PASS));
   FTP.Binary := True;
end;

procedure TfrmMain.FTPControl(aSocket: TLSocket);
var
  s: string;
begin
  if FTP.GetMessage(s) > 0 then begin
    MemoText.Lines.Append(s);
    MemoText.SelStart := Length(MemoText.Text);
  end;
end;

procedure TfrmMain.FTPError(const msg: string; aSocket: TLSocket);
begin
  MemoText.Append(msg);
end;

procedure TfrmMain.FTPSent(aSocket: TLSocket; const Bytes: Integer);
var
  n: integer;
begin
  if Bytes > 0 then
  begin
    Inc(FDLDone, Bytes);
    n := Integer(Round(FDLDone / FDLSize * 100));
    if n <> FLastN then
    begin
      pbProcess.Position := n;
      FLastN := n;
     end;
  end
  else
  begin
    FTP.List('');
    pbProcess.Position:= 100;
  end;
end;

procedure TfrmMain.FTPSuccess(aSocket: TLSocket; const aStatus: TLFTPStatus);
begin
  if aStatus = fsPass then
  begin
    FTP.Binary := True;
    FTP.Put(ExtractFilePath(Application.ExeName) + LeerDato(edCFGFile.FileName, SECCION_APP, CMPR_NAME));
  end;
end;

procedure TfrmMain.BitBtn1Click(Sender: TObject);
begin
  FTP.Binary := True;
  FTP.Put('C:\Dropbox\bak\Trabajo\Trabajo\Windows\comsen\exe\snd_alcon2.zip');

end;


end.

