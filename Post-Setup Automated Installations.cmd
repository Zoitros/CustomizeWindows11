@ECHO OFF
SETLOCAL EnableExtensions EnableDelayedExpansion

TITLE Post-Setup Tasks
CD /D "%TEMP%" & CLS

REM ------------------------------------------------------------
REM  Initialize
REM ------------------------------------------------------------
PushD "%~dp0"

ECHO Post-setup Automated Installations by ZOITROS
ECHO Please follow me on GitHub:
ECHO - https://github.com/zoitros
ECHO.
ECHO ---------------------------------oOOo--ZOITROS--oOOo---------------------------------
ECHO This script runs post-setup automated installations safely.
ECHO ====================================================================================
ping -n 3 localhost >NUL

REM Load Default User hive
Reg Load "HKU\LoadedDefaultUser" "%SystemDrive%\Users\Default\NTUSER.DAT" >NUL 2>&1

REM ------------------------------------------------------------
REM  MSRT (KB890830) — DO NOT RUN DURING SETUP
REM ------------------------------------------------------------
ECHO.
ECHO Checking Windows Malicious Software Removal Tool (MSRT)...
tasklist | findstr /i "mrt.exe" >NUL
IF NOT ERRORLEVEL 1 (
    ECHO MSRT already running (Windows-managed). Skipping.
) ELSE (
    IF EXIST "%SystemRoot%\System32\MRT.exe" (
        ECHO MSRT already installed by Windows. Skipping.
    ) ELSE (
        ECHO MSRT not present yet. Windows Update will handle it.
    )
)

REM ------------------------------------------------------------
REM  DirectX End-User Runtime
REM ------------------------------------------------------------
CALL :InstallEXE "DirectX End-User Runtime x86-x64.exe" "/ai /gm2"

REM ------------------------------------------------------------
REM  Visual C++ Redist AIO
REM ------------------------------------------------------------
CALL :InstallEXE "Visual B-C++ Redist AIO x86-x64.exe" "/aiE /aiV /gm2"

REM ------------------------------------------------------------
REM  VC++ Redistributable 14.40.33810
REM ------------------------------------------------------------
CALL :InstallEXE "VC_redist.x64_14.40.33810.exe" "/quiet /norestart"

REM ------------------------------------------------------------
REM  7-Zip
REM ------------------------------------------------------------
CALL :InstallEXE "7-Zip x64.exe" "/S"

IF EXIST "%ProgramFiles%\7-Zip\7zFM.exe" (
    ECHO Setting 7-Zip file associations...
    SET "KN=HKLM\SOFTWARE\Classes"
    FOR %%E IN (7z zip rar tar gz bz2 xz) DO (
        REG ADD "%KN%\.%%E" /VE /T REG_SZ /D "7-Zip.%%E" /F >NUL
        REG ADD "%KN%\7-Zip.%%E\shell\open\command" /VE /T REG_SZ ^
        /D "\"%ProgramFiles%\7-Zip\7zFM.exe\" \"%%1\"" /F >NUL
    )
)

REM ------------------------------------------------------------
REM  VLC Media Player
REM ------------------------------------------------------------
CALL :InstallEXE "vlc-3.0.21-win64.exe" "/L=1033 /S"

REM ------------------------------------------------------------
REM  Google Chrome Enterprise
REM ------------------------------------------------------------
CALL :InstallMSI "GoogleChromeStandaloneEnterprise64.msi" "/qn /norestart"

REM ------------------------------------------------------------
REM  OpenHashTab
REM ------------------------------------------------------------
CALL :InstallEXE "OpenHashTab x86-x64.exe" "/VerySilent /AllUsers"

REM ------------------------------------------------------------
REM  Firefox
REM ------------------------------------------------------------
CALL :InstallEXE "Firefox x64.exe" "/S /PreventRebootRequired=true"

REM ------------------------------------------------------------
REM  Cleanup Preparation
REM ------------------------------------------------------------
ECHO.
ECHO Preparing cleanup...

REM Release working directory lock
PopD
CD /D "%SystemRoot%"

REM Unload Default User hive safely
Reg UnLoad "HKU\LoadedDefaultUser" >NUL 2>&1

REM Give installers time to exit
timeout /t 5 /nobreak >NUL

REM ------------------------------------------------------------
REM  Deferred Cleanup (Guaranteed)
REM ------------------------------------------------------------
IF EXIST "%SystemRoot%\Setup\Programs" (
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" ^
    /V CleanupSetupPrograms ^
    /T REG_SZ ^
    /D "cmd /c rd /s /q %SystemRoot%\Setup\Programs" ^
    /F
)

IF EXIST "%SystemRoot%\Setup\Files" (
    REG ADD "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\RunOnce" ^
    /V CleanupSetupFiles ^
    /T REG_SZ ^
    /D "cmd /c rd /s /q %SystemRoot%\Setup\Files" ^
    /F
)

REM ------------------------------------------------------------
REM  Completion
REM ------------------------------------------------------------
ECHO.
ECHO ---------------------------------[ Completed Successfully ]---------------------------------
ping -n 5 localhost >NUL
EXIT /B 0

REM ============================================================
REM  FUNCTIONS
REM ============================================================

:InstallEXE
SET "APPEXEC=%~1"
SET "APPARGS=%~2"
SET "APPPATH=%SystemRoot%\Setup\Programs"

IF NOT EXIST "%APPPATH%\%APPEXEC%" EXIT /B
ECHO.
ECHO Installing %APPEXEC% ...
START "" /WAIT "%APPPATH%\%APPEXEC%" %APPARGS%
EXIT /B

:InstallMSI
SET "APPEXEC=%~1"
SET "APPARGS=%~2"
SET "APPPATH=%SystemRoot%\Setup\Programs"

IF NOT EXIST "%APPPATH%\%APPEXEC%" EXIT /B
ECHO.
ECHO Installing %APPEXEC% ...
START "" /WAIT msiexec /i "%APPPATH%\%APPEXEC%" %APPARGS%
EXIT /B
