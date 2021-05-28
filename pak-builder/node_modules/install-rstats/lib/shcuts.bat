@echo off
setlocal enableDelayedExpansion

REM ----------------------------------------------------------------
REM Create the directory that we use for the links
REM ----------------------------------------------------------------

SET linkdir=%ProgramFiles%
IF "%linkdir%"=="" (
    SET linkdir=C:\Program Files
)

SET linkdir=%linkdir%\R\bin

IF EXIST "%linkdir%\" (
    REM Exists, good
) ELSE (
    echo Creating symlink directory: '%linkdir%'.
    MKDIR "%linkdir%"
    IF %errorlevel% NEQ 0 EXIT /b %errorlevel%
)

REM ----------------------------------------------------------------
REM Add to path. This is a bit tricky to do in a way that
REM we make sure that it is on the system path, and it is also
REM set in the current process.
REM ----------------------------------------------------------------

REM Get the system path
REM Explanation: https://stackoverflow.com/a/16282366/604364

SET keyname=HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Control\Session Manager\Environment
FOR /F "usebackq skip=2 tokens=1,2*" %%A IN (
    `REG QUERY "%keyname%" /v "Path" 2^>nul`) DO (
        set "pathname=%%A"
        set "pathtype=%%B"
        set "pathvalue=%%C"
)
IF %errorlevel% NEQ 0 EXIT /b %errorlevel%

REM If not in the system path, then add it there
REM This is difficult: https://stackoverflow.com/a/8046515/604364
REM So we'll only do a simplified check instead

for /F "delims=" %%L in (
    'echo ";%pathvalue%;" ^| find /C /I ";%linkdir%;"') do (
        set "cnt=%%L"
)
IF %errorlevel% NEQ 0 EXIT /b %errorlevel%

SET newpath=%linkdir%;%pathvalue%
if "%cnt%"=="0" (
    echo Adding '%linkdir%' to the system path.
    reg add "%keyname%" /v "Path" /t "%pathtype%" /d "%newpath%" /f >nul 2>nul
    IF %errorlevel% NEQ 0 EXIT /b %errorlevel%
)

REM SETX will signal an environment refresh, so no reboot is needed
REM We cannot SETX the path, because that would expand the wildcards

SETX dummy dummy >nul
IF %errorlevel% NEQ 0 EXIT /b %errorlevel%

REM ----------------------------------------------------------------
REM Get the R user's home directory, we'll use this to create
REM user package libraries. This is the same lookup that R does,
REM see the R for Windows FAQ, and also ?Rconsole.
REM ----------------------------------------------------------------

REM If R_USER is set, we use that
REM It could be set in .Renviron as well? Then we'll miss it here :(

SET myhome=%R_USER%

REM Otherwise use HOME, if set.

IF [%myhome%] == [] (
    SET myhome=%HOME%
)

REM Otherwise look up the home in the registry

IF [%myhome%] == [] (
    SET "homekey=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Explorer\Shell Folders"
    FOR /F "tokens=3" %%A IN (
        'REG QUERY "%homekey%" /v "Personal"') DO (
            SET myhome=%%A
    )
)

echo Creating user libraries in %myhome%.

REM ----------------------------------------------------------------
REM Get the installed R versions and locations from the registry
REM ----------------------------------------------------------------

SET rkey=HKEY_LOCAL_MACHINE\SOFTWARE\R-core\R

REM First we get the pre-release versions. These are added first,
REM so they will be overwritten by the proper releases.

SET devrversions=
FOR /F "tokens=1 delims=" %%a in (
    'REG QUERY "%rkey%" /f "*" /k ^|
        findstr /v /c:"End of search:" ^| sort ^| findstr /r "Pre-release$" ') DO (
            for /F "tokens=5 delims=\" %%b in ("%%a") do (
            CALL SET "devrversions=%%devrversions%%;%%b"
        )
    )
)

REM Then we add all the releases, in the right order, so a later release will
REM overwrite an earlier one, and e.g. R-4.0 will use R 4.0.2, not R 4.0.1.

SET rversions=
FOR /F "tokens=1 delims=" %%a in (
    'REG QUERY "%rkey%" /f "*" /k ^|
        findstr /v /c:"End of search:" ^| sort ^| findstr /r "[0123456789]$" ') DO (
            for /F "tokens=5 delims=\" %%b in ("%%a") do (
            CALL SET "rversions=%%rversions%%;%%b"
        )
    )
)

REM ----------------------------------------------------------------
REM Create a shortcut for every version
REM ----------------------------------------------------------------

REM First we remove all shortcuts, so we can re-populate them.
REM It would be better to remove selectively, in case the script does not
REM run to completion...

del /f "%linkdir%\R-*.bat"

REM Need to replace spaces, temporarily, as FOR breaks on them
SET devrversions2=!devrversions: =_!

for %%a in (%devrversions2%) do (
    for /F "tokens=1,2 delims=." %%b in ("%%a") do call :shcut %%a %%b.%%c
)

for %%a in (%rversions%) do (
    for /F "tokens=1,2 delims=." %%b in ("%%a") do call :shcut %%a %%b.%%c
)

goto End

REM ----------------------------------------------------------------
REM Functions
REM ----------------------------------------------------------------

REM Create a shortcut, %1 is the full version number, %2 is the minor
REM version number

:shcut
SET oldver=%1
SET ver=!oldver:_= !
SET minor=%2

FOR /F "usebackq skip=2 tokens=1,2*" %%A IN (
    `REG QUERY "%rkey%\%ver%" /v InstallPath 2^>nul`) DO (
        set "installpath=%%C"
)

echo Adding shortcut: %linkdir%\R-%minor%.bat -^> %installpath%\bin\R
echo @"%installpath%\bin\R" %%* > "%linkdir%\R-%minor%.bat"

echo Adding shortcut: %linkdir%\R-%minor%-i386.bat -^> %installpath%\bin\i386\R
echo @"%installpath%\bin\i386\R" %%* > "%linkdir%\R-%minor%-i386.bat"

REM Create library directory for this version
REM https://stackoverflow.com/a/4165472/604364
SET "mylibdir=%myhome%\R\win-library\%minor%"
IF NOT EXIST %mylibdir%\NUL (
    mkdir %mylibdir%
)

REM Create Renviron.site file, to adjust PATH for Rtools
REM TODO: Rtools directory is hardcoded.
SET "renv=%installpath%\etc\Renviron.site"
IF "%minor:~0,1%" == "3" (
    echo PATH="C:\Rtools\bin;${PATH}" > "%renv%"
) ELSE (
    echo PATH="${RTOOLS40_HOME}\usr\bin;${PATH}" > "%renv%"
)

goto :eof

:End
endlocal
