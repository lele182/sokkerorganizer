@echo off
setlocal
if exist "%~dp0so.jar" (
    cd /d "%~dp0"
    java -jar "so.jar" %*
    exit /b
)
if exist "%~dp0dist\so.jar" (
    cd /d "%~dp0dist"
    java -jar "so.jar" %*
    exit /b
)
echo so.jar not found. Run build-windows.bat first.
pause
exit /b 1
