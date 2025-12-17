@echo off
setlocal

set SSH_DIR=C:\Users\%USERNAME%\.ssh

if not exist "%SSH_DIR%" (
    mkdir "%SSH_DIR%" || exit /b 1
)

copy /Y git_config "%SSH_DIR%\config" || exit /b 1

endlocal
