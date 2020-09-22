@echo off
::#######################################################################
:: customapps.cmd
:: Version v0.1.5
::Custom apps for uosync
::Add whatever apps or utilities you want to run here
::Examples:
::	OBS
::	call :startapp "C:\Program Files (x86)\obs-studio\bin\64bit\obs64.exe"
::  HexChat Portable
::  call :startapp "%uostorage%HexChatPortable\HexChatPortable.exe"
::#######################################################################

:: Start HexChat Portable
rem call :startapp "%uostorage%HexChatPortable\HexChatPortable.exe"
:: Start OBS
rem call :startapp "C:\Program Files (x86)\obs-studio\bin\64bit\obs64.exe"
exit /b 0

:startapp
echo Starting %~nx1
if exist "%~1" start "%~nx1" /D "%~dp1" "%~1"
exit /b 0
