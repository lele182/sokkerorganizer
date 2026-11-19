@echo off
setlocal
set "ROOT=%~dp0"
set "BUILD=%ROOT%build"
set "CLASSES=%BUILD%\classes"
set "DIST=%ROOT%dist"

where javac >nul 2>nul
if errorlevel 1 (
    echo A JDK is required. Install a JDK and add its bin folder to PATH.
    pause
    exit /b 1
)
where jar >nul 2>nul
if errorlevel 1 (
    echo The JAR tool was not found. Check your JDK installation and PATH.
    pause
    exit /b 1
)

if not exist "%CLASSES%" mkdir "%CLASSES%"
if not exist "%DIST%" mkdir "%DIST%"

(
    for /r "%ROOT%so" %%F in (*.java) do @echo "%%F"
    for /r "%ROOT%com" %%F in (*.java) do @echo "%%F"
) > "%BUILD%\sources.txt"

javac -encoding windows-1252 --release 8 -d "%CLASSES%" @"%BUILD%\sources.txt"
if errorlevel 1 goto failed

xcopy /E /I /Y "%ROOT%languages" "%DIST%\languages" >nul
if errorlevel 1 goto failed
xcopy /E /I /Y "%ROOT%resources" "%DIST%\resources" >nul
if errorlevel 1 goto failed
xcopy /E /I /Y "%ROOT%data" "%DIST%\data" >nul
if errorlevel 1 goto failed
copy /y "%ROOT%run.bat" "%DIST%\run.bat" >nul
if errorlevel 1 goto failed
copy /y "%ROOT%languages\#default#.txt" "%DIST%\resources\default.res" >nul
if errorlevel 1 goto failed
copy /y "%ROOT%resources\countrydata.txt" "%DIST%\resources\countrydata.res" >nul
if errorlevel 1 goto failed
copy /y "%ROOT%resources\ntdb_urls.txt" "%DIST%\resources\ntdb_urls.res" >nul
if errorlevel 1 goto failed

if exist "%DIST%\so.jar" del "%DIST%\so.jar"
jar cfe "%DIST%\so.jar" so.So -C "%CLASSES%" . -C "%DIST%" languages -C "%DIST%" resources -C "%DIST%" data
if errorlevel 1 goto failed
if exist "%ROOT%SokkerOrganizer-windows.zip" del "%ROOT%SokkerOrganizer-windows.zip"
jar cf "%ROOT%SokkerOrganizer-windows.zip" -C "%DIST%" .
if errorlevel 1 goto failed

echo.
echo Build successful: "%ROOT%SokkerOrganizer-windows.zip"
echo Start it with run.bat or extract the ZIP and use its run.bat.
pause
exit /b 0

:failed
echo.
echo Build failed. See the compiler output above.
pause
exit /b 1
