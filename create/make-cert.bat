@echo off

REM Set path to your OpenSSL configuration file
set "CONFIG=C:\laragon\etc\ssl\auto.openssl.conf"
set "PATH_SSL=C:\laragon\etc\ssl"
REM Generate the private key
C:\laragon\bin\apache\httpd-2.4.54-win64-VS16\bin\openssl genrsa -out laragon.key 2048

REM Generate the Certificate Signing Request (CSR)
C:\laragon\bin\apache\httpd-2.4.54-win64-VS16\bin\openssl req -new -key laragon.key -out laragon.csr -config "%CONFIG%"

REM Generate the certificate using the CSR and configuration
C:\laragon\bin\apache\httpd-2.4.54-win64-VS16\bin\openssl x509 -req -sha256 -days 365 -in laragon.csr -signkey laragon.key -out laragon.crt -extensions v3_req -extfile "%CONFIG%"

copy /y laragon.key "%PATH_SSL%\laragon.key"
copy /y laragon.csr "%PATH_SSL%\laragon.csr"
copy /y laragon.crt "%PATH_SSL%\laragon.crt"
del "laragon.key"
del "laragon.csr"
del "laragon.crt"
echo.
echo Certificate (laragon.crt) has been generated.
echo.
pause
