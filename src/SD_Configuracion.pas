unit SD_Configuracion;

interface
uses
  IniFiles, classes;

const
  ERROR_APERTURA_CFG= 'ErrorAperturaCFG';
  ERROR_CFG= 'ErrorLecturaCFG';

  SECCION_APP = 'APLICATION';
  CMPR_NAME = 'COMPRESSED_NAME';

  SECCION_FLS = 'PROC_FILES';
  FTP_HOST = 'HOST';
  FTP_PORT = 'PORT';
  FTP_USR =  'USR';
  FTP_PASS = 'PASS';

  function AbrirArchivo (archivo: string): TIniFile;
  function LeerDato (archivo,Clave, Etiqueta: string): string;
  procedure LeerSeccion(archivo, Clave: string; var lista: TStringList);
  procedure EscribirDato (archivo, Clave, Etiqueta, Dato: string);



implementation

uses
  SysUtils
  ,forms, Dialogs
  ;

function AbrirArchivo (archivo: string): TIniFile;
begin
  Result:= TiniFile.Create(archivo);
end;

function LeerDato (archivo, Clave, Etiqueta: string): string;
var
 elArchivo: TIniFile;
begin
   elArchivo:=  AbrirArchivo (archivo);
   try
    if (elArchivo <> nil) and (FileExists(elArchivo.FileName))  then
      Result:= elArchivo.ReadString(Clave,Etiqueta, ERROR_CFG)
    else
    begin
     Result:= ERROR_APERTURA_CFG;
    end;
  finally
    elArchivo.Free;
  end;
end;

procedure LeerSeccion(archivo, Clave: string; var lista: TStringList);
var
 elArchivo: TIniFile;
begin
   elArchivo:=  AbrirArchivo (archivo);
   try
    if (elArchivo <> nil)
//       and (elArchivo.SectionExists(clave))
    then
    begin
      elArchivo.ReadSectionValues(Clave, lista);
    end;
  finally
    elArchivo.Free;
  end;
end;

procedure EscribirDato(archivo, Clave, Etiqueta, Dato: string);
var
 elArchivo: TIniFile;
begin
   elArchivo:=  AbrirArchivo (archivo);
   try
    if (elArchivo <> nil) and (FileExists(elArchivo.FileName))  then
      elArchivo.WriteString(Clave,Etiqueta, Dato)
  finally
    elArchivo.Free;
  end;
end;


end.
