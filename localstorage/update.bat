@echo off
REM ��μ򵥣����òֿ��ַ�ͷ�֧�����Ҳ�������ֲ�ͬ��Ŀ�ķ�����
set branch=test
set origin=https://gitee.com/EnderAvaritia/Thaumcraft_Revival_Rename_The_Galaxy.git
set packname=���ظ��ˡ��������
REM ���ֻ�õ���git��xcopy����ֻ����������������������
set PATH=%WINDIR%\system32;%~dp0%git-mini

title %packname% ���ڸ���

REM ��⻥��������
ping gitee.com -n 1 > nul
if errorlevel 1 (
	echo Giteeûpingͨ����Ļ��������Ӵ�������⣬��������
	exit 1
)

REM չʾ����ʱ�䣬��ȷ�������־������һ��������ʱ�����ɵġ�����ı����ں��汸�ݵ�ʱ��Ҳ���õ�
FOR /F "tokens=1-4 delims=/ " %%i in ('date/t') do set localdate=%%i-%%j-%%k
FOR /F "tokens=*" %%t in ('time/t') do set localtime=%%t
echo %localdate% %localtime%

REM ���Ӿ���λ�ã�ʼ����ת����ȷ��.minecraftĿ¼
cd /d %~dp0
cd ..\.minecraft

REM ��.minecraft��Ϊ����.gitĿ¼�����ˣ��ͱ�����û�г�ʼ��flag���������ͨ����
REM ���棺���������flag�ļ��Ž�.minecraftĿ¼������Ը���
if not exist .git exit 1

REM �ڲ������firstupdate��ֱ�ӽ���dofirstupdate���֣�����Ϊ�������Ӧvbs�ű�ʹ�ã������״θ��µĽϳ�ʱ������ʾ������صĴ��ڣ������û������ɻ�
if "%~1" equ "firstupdate" (goto dofirstupdate)
REM ����ָ�������������������������Ƿ����flag�ļ���ȷ����������
if exist I_WANT_TO_RESET_WORLD (goto firstupdatehandler) else (goto normalupdate)

:dofirstupdate
echo ���ڽ����״����ã�Intializing local copy

REM �ٴμ��һ�£����������
if not exist I_WANT_TO_RESET_WORLD (exit 1)

REM ��localstorageĿ¼��������ָʾ�ļ�����һ�汾���ڸ�Ŀ¼�����������û��п��ܸ��ֶ�ɾ������ļ����Ǿͺ����Σ�
type nul > ..\localstorage\UPDATE_IN_PROGRESS.txt

echo ���ڴ����ؼ��������ݱ��ݣ�Creating a partial backup for less grief
if not exist saves (
	echo δ����savesĿ¼�����ϰ�Ӧ����ȫ�µģ���������
	goto firstupdatepart2
	)
for %%f in (config, journeymap, saves) do xcopy /s /q /i /r /y %%f ..\localstorage\Backup-LocalReset-%localdate%\%%f
xcopy /r /y /q options.txt ..\localstorage\Backup-LocalReset-%localdate%\
xcopy /r /y /q optionsof.txt ..\localstorage\Backup-LocalReset-%localdate%\

:firstupdatepart2
echo ���ڽ���Դ�ļ����Ƶ����ش洢��Copying first-served files to local storage
for %%g in (assets, libraries, versions) do xcopy /s /q /i /r /y %%g ..\localstorage\rootdir\%%g
xcopy /r /y /q launcher_profiles.json ..\localstorage\rootdir\

echo �������òֿ����Σ�Setting local repo origin
git.exe remote remove origin
git.exe remote add origin %origin%

echo ���������ı����з���Ӧ��Setting local EOL policy
git.exe config core.autocrlf true

echo �������ñ���Git��ݣ�Setting dummy local identity
git.exe config user.name "localuser"
git.exe config user.email "localuser@localhost"

echo ��������SSL��֤��Disabling SSL cert verification
git.exe config http.sslVerify false

echo ���ڴ�Զ����ȡ���ݣ�Fetching branch data from remote
git.exe fetch origin %branch%

echo ����Ӳ���ñ���Ŀ¼��Hard resetting local world
git.exe reset --hard origin/%branch%

echo һ���������������A little cleanup...
git.exe clean -d -x -f

xcopy /s /q ..\localstorage\rootdir\* .
echo �Ѹ��Ʊ�����Դ�ļ������ϰ�����������Copied local storage data for a full modpack

del ..\localstorage\UPDATE_IN_PROGRESS.txt

cd ..
exit 0

:normalupdate
echo ���ڼ����£�Checking for updates
set POLICY=ours

echo �����ύ���ظ��ģ�Commiting local changes
git.exe commit --quiet --all -m local_autocommit

echo ������ȡԶ�˸��£�Fetching remote changes
git.exe fetch origin %branch%

git.exe merge -s recursive -X %POLICY% origin/%branch%
echo ��Ӧ��Զ�˸��£�Applied remote changes

cd ..
exit 0

:firstupdatehandler
REM �����״θ��µ��������ʱ��Ҫ��ʾcmd������չʾ���½��ȡ�
REM �������������vbs��������һ��cmdʵ����Ȼ���ò���ֱ��ָ����firstupdate���̡�û����дһ���ļ������ã���Ϊ�˾��������ļ�����
xcopy /r /y /q .\I_WANT_TO_RESET_WORLD ..\
cmd.exe /C "..\localstorage\update.vbs"

:checkfile
REM hmcl�ж�����ǰִ������ķ������ǿ���ִ�еĵ�һ�������Ƿ��������ˣ���ǰ̨���µ�ʵ������֮ǰ�������ʵ��Ҳ���뱣�����С�
REM �����õȴ�������ѭ�������жϸ��¹����Ƿ��ѽ�����
echo ���ڵȴ��������...
ping localhost -n 4 > nul
if exist "..\localstorage\UPDATE_IN_PROGRESS.txt" (
goto checkfile
)

exit 0