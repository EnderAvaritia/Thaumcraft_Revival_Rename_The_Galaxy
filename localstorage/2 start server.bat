@ECHO OFF

cmd /c ..\update.bat

:: server core
SET SERVER_CORE=forge-1.12.2-14.23.5.2860.jar

SET JAVA_PARAMETERS=

::java path
set JAVA_PATH="C:\Program Files\Java\jre1.8.0_311\bin\java.exe"

:: RAM
SET MIN_RAM=6144M
SET MAX_RAM=6144M


SET LAUNCHPARAMS=-server -Xms%MIN_RAM% -Xmx%MAX_RAM% %JAVA_PARAMETERS% -javaagent:authlib-injector-1.1.39.jar=http://127.0.0.1:32217 -jar %SERVER_CORE% nogui

::show on the screen
echo Launching the server...
echo.
echo ^> %JAVA_PATH% %LAUNCHPARAMS%
echo.
%JAVA_PATH% %LAUNCHPARAMS%

::end
echo.
echo ^> The server has stopped. If it's a crash, please read the output above.
echo.

::restart
timeout 3
cls
%0