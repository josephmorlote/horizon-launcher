@echo off
rem Double-click to tune up a Fire TV from this PC (see tune-up-firetv.ps1, which has to sit beside this file).
powershell -ExecutionPolicy Bypass -File "%~dp0tune-up-firetv.ps1"
pause
