# COMSEN

   Es una peque�a utilidad que hice para simplificar el soporte t�cnico a los usuarios. El funcionamiento es simple, les mando un archivo con los datos que necesito por correo o desde la p�gina de soporte, ellos lo cargan en el programa y esperan que el env�o se realice sin problemas. 
   
   De momento no est� automatizado porque me sirve as� y los usuarios lo usan sin problemas, pero no quita que se mejore o cambie en breve.
   Hay unas cuantas cosas groseras a cambiar, pero esta es una aplicaci�n de unas horas para solucionar un par de cuestiones puntuales.
   
## Formato del archivo enviado

El archivo tiene que ser un texto plano, en el formato tradicional de los viejos archivos INI de windows. En la secci�n [APPLICATION] van los datos de conexi�n y alg�n otro valor necesario para el funcionamiento del programa. En [PROC_FILES] va la lista de archivos a levantar y comprimir. Un archivo con ruta completa por l�nea.

[APPLICATION]
COMPRESSED_NAME= nombreDelArchivoComprimido.zip
HOST=ftp.Direcci�nDelFTP.com 
PORT=21 
USR= usuarioDelFTP
PASS= claveDelFTP

[PROC_FILES]
C:\ruta\archivo01.exe
C:\ruta\programa.cfg
C:\ruta\log\datos.log                 


## Detalles T�cnicos

* Realizado en Lazarus 1.6 
* Componentes adicionales: 
    - Abbrevia para la compresi�n
    - lnet para la conexi�n al FTP

## Contacto

Carlos Enrique Rodriguez
Magoo
magoo@programador.com.ar
www.programador.com.ar