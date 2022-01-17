@echo off
set branch=test
set origin=https://gitee.com/EnderAvaritia/Thaumcraft_Revival_Rename_The_Galaxy.git
set packname=���ظ��ˡ��������

REM ���ֻ�õ���git��xcopy����ֻ����������������������
set PATH=%WINDIR%\system32;%~dp0%git-mini

title %packname% ������ ���ڸ���

REM չʾ����ʱ�䣬��ȷ�������־������һ��������ʱ�����ɵġ�����ı����ں��汸�ݵ�ʱ��Ҳ���õ�
FOR /F "tokens=1-4 delims=/ " %%i in ('date/t') do set localdate=%%i-%%j-%%k
FOR /F "tokens=*" %%t in ('time/t') do set localtime=%%t
echo %localdate% %localtime%

REM ���Ӿ���λ�ã�ʼ����ת����ȷ��.minecraftĿ¼
cd /d %~dp0
if not exist server (
	mkdir server
)
if not exist localstorage (
	mkdir localstorage
)
cd .\server

REM ��.minecraft��Ϊ����.gitĿ¼�����ˣ��ͱ�����û�г�ʼ��flag���������ͨ����
REM ���棺���������flag�ļ��Ž�serverĿ¼������Ը���
if not exist .git (
	echo ����������Ŀ¼����git����Ŀ¼
	exit 1)
if exist I_WANT_TO_RESET_WORLD (goto firstupdate) else (goto normalupdate)

:firstupdate
echo ���ڽ����״����ã�Intializing local server copy

REM �ڸ�Ŀ¼��������ָʾ�ļ�
type nul > ..\%packname%���ڸ��£������ĵȴ�.txt

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

if not exist world (
	echo ����Ӳ���ñ���Ŀ¼��Hard resetting local world
	git.exe reset --hard origin/%branch%

	echo һ���������������A little cleanup...
	git.exe clean -d -x -f

	xcopy /s /q ..\localstorage\* .
	echo �Ѹ��Ʊ�����Դ�ļ������ϰ�����������Copied local storage data for a full modpack
)

del ..\%packname%���ڸ��£������ĵȴ�.txt

cd ..
exit /b

:normalupdate
echo ���ڼ����£�Checking for updates
set POLICY=ours

REM ��⻥��������
ping gitee.com -n 1 > nul
if errorlevel 1 (
	echo Giteeûpingͨ����Ļ��������Ӵ�������⣬��������
	exit 1
)

echo �����ύ���ظ��ģ�Commiting local changes
git.exe commit --quiet --all -m local_autocommit

echo ������ȡԶ�˸��£�Fetching remote changes
git.exe fetch origin %branch%

git.exe merge -s recursive -X %POLICY% origin/%branch%
echo ��Ӧ��Զ�˸��£�Applied remote changes

cd ..
exit /b
