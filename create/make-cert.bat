@echo off

REM Set path to your OpenSSL configuration file
set "CONFIG=C:\laragon\etc\ssl\auto.openssl.conf"

REM Generate the private key
C:\laragon\bin\apache\httpd-2.4.54-win64-VS16\bin\openssl genrsa -out laragon.key 2048

REM Generate the Certificate Signing Request (CSR)
C:\laragon\bin\apache\httpd-2.4.54-win64-VS16\bin\openssl req -new -key laragon.key -out laragon.csr -config "%CONFIG%"

REM Generate the certificate using the CSR and configuration
C:\laragon\bin\apache\httpd-2.4.54-win64-VS16\bin\openssl x509 -req -sha256 -days 365 -in laragon.csr -signkey laragon.key -out laragon.crt -extensions v3_req -extfile "%CONFIG%"

echo.
echo Certificate (laragon.crt) has been generated.
echo.
pause
