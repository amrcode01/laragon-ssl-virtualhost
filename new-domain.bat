@echo off
setlocal enabledelayedexpansion

:: File yang digunakan sebagai template
set "template_file=C:\laragon\etc\ssl\auto.openssl.conf"
set "output_file=new_config.txt"

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


set "newDNS=DNS.!nextDNS! = %domain%"
:: Menulis konten template ke file baru dan menambahkan DNS baru
(
    for /f "delims=" %%i in (%template_file%) do (
        echo %%i
    )
    echo !newDNS!
) > "%output_file%"

echo New configuration has been written to %output_file%
