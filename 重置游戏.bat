@echo off
cd /d %~dp0
set PATH=%WINDIR%\system32;%~dp0%\localstorage\git-mini


if not exist .minecraft (
mkdir .minecraft
cd .minecraft
git.exe init
cd ..
	)
xcopy /r /y /q I_WANT_TO_RESET_WORLD .minecraft
cd localstorage
update.bat