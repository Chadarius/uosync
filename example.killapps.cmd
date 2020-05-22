@echo off
:: Kill apps with the :killapp function
:: call :killapp "app.exe"
:: Where app.exe is the name of the exe running listed in Task Manager

::Kill Hexchat
call :killapp "hexchat.exe"

::Kill easyuo
call :killapp "easyuo.exe"

::Kill openeuo
call :killapp "openeuo.exe"

::Kill obs64
call :killapp "obs64.exe"

exit /b 0

::Function killapp
:killapp
::check if app is running and kill it
tasklist | c:\windows\system32\find "%~1" >nul 2>&1
IF ERRORLEVEL 1 (
  echo.
) ELSE (
  ECHO Killing %~1
  IF ERRORLEVEL 0 taskkill /IM "%~1" /F
)
exit /b 0