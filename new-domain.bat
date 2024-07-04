@echo off
setlocal enabledelayedexpansion

:: File yang digunakan sebagai template
set "template_file=C:\laragon\etc\ssl\auto.openssl.conf"
set "templateVhost=C:\laragon\etc\ssl\template-vhost.conf"
set "output_file=new_domain.conf"
set SEARCHTEXT={{DOMAIN}}
set OUTTEXTFILE=cert.conf
:: Ganti Dengan auto.openssl.conf untuk otomatis mengganti config,lalu jalankan make-cart.bat pada folder create
:: Pindahkan Ke Laragon/ssl lalu install ulang certificate nya

:: Memeriksa apakah file template ada
if not exist "%template_file%" (
    echo Template file not found: %template_file%
    exit /b 1
)
:: Menemukan nomor DNS tertinggi dalam template
set "highestDNS=0"
for /f "tokens=2 delims=.=" %%A in ('findstr /r "DNS\.[0-9+]*=" "%template_file%"') do (
    if %%A gtr !highestDNS! set highestDNS=%%A
)
:: Menambahkan domain baru ke nomor DNS berikutnya

set /a nextDNS=highestDNS + 1

:: Meminta input domain dari pengguna
set /p domain="Enter the domain to add: "

if exist %OUTTEXTFILE% del /F %OUTTEXTFILE%
set REPLACETEXT=%domain%
for /f "tokens=1,* delims=ΒΆ" %%A in ( '"findstr /n ^^ %templateVhost%"') do (
   SET string=%%A
   for /f "delims=: tokens=1,*" %%a in ("!string!") do set "string=%%b"
   if  "!string!" == "" (
       echo.>>%OUTTEXTFILE%
   ) else (
      SET modified=!string:%SEARCHTEXT%=%REPLACETEXT%!
      echo !modified! >> %OUTTEXTFILE%
  )
)

set "newDNS=DNS.!nextDNS!=%domain%"\
echo %newDNS%

:: Menulis konten template ke file baru dan menambahkan DNS baru

(
    for /f "delims=" %%i in (%template_file%) do (
        echo %%i
    )
    echo !newDNS!
) > "%output_file%"
copy /y "%output_file%" "%template_file%"
del "%output_file%"
copy /y "%OUTTEXTFILE%" "C:\laragon\etc\apache2\sites-enabled\z.%nextDNS%-%domain%.conf"
echo New configuration has been written to %output_file%
echo "Tambahkan Manual Pada C:\laragon\bin\apache\httpd-(Versi Apache)\conf\httpd.conf" 
echo "C:\laragon\etc\apache2\sites-enabled\z.%nextDNS%-%domain%.conf Berhasil ditambahkan"
del /F %OUTTEXTFILE%
pause;