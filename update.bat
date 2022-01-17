@echo off
set branch=test
set origin=https://gitee.com/EnderAvaritia/Thaumcraft_Revival_Rename_The_Galaxy.git
set packname=神秘复兴·星瀚再临

REM 这次只用到了git和xcopy，故只设置这两个环境变量够了
set PATH=%WINDIR%\system32;%~dp0%git-mini

title %packname% 服务器 正在更新

REM 展示运行时间，以确定这个日志是最新一次启动的时候生成的。这里的变量在后面备份的时候也有用到
FOR /F "tokens=1-4 delims=/ " %%i in ('date/t') do set localdate=%%i-%%j-%%k
FOR /F "tokens=*" %%t in ('time/t') do set localtime=%%t
echo %localdate% %localtime%

REM 无视具体位置，始终跳转到正确的.minecraft目录
cd /d %~dp0
if not exist server (
	mkdir server
)
if not exist localstorage (
	mkdir localstorage
)
cd .\server

REM 若.minecraft因为异变把.git目录消除了，就报错；若没有初始化flag，则进行普通更新
REM 警告：切勿将下面的flag文件放进server目录，后果自负。
if not exist .git (
	echo 服务器运行目录不是git工作目录
	exit 1)
if exist I_WANT_TO_RESET_WORLD (goto firstupdate) else (goto normalupdate)

:firstupdate
echo 正在进行首次配置／Intializing local server copy

REM 在根目录创建更新指示文件
type nul > ..\%packname%正在更新，请耐心等待.txt

echo 正在设置仓库上游／Setting local repo origin
git.exe remote remove origin
git.exe remote add origin %origin%

echo 正在设置文本换行符适应／Setting local EOL policy
git.exe config core.autocrlf true

echo 正在设置本地Git身份／Setting dummy local identity
git.exe config user.name "localuser"
git.exe config user.email "localuser@localhost"

echo 正在配置SSL认证／Disabling SSL cert verification
git.exe config http.sslVerify false

echo 正在从远端拉取数据／Fetching branch data from remote
git.exe fetch origin %branch%

if not exist world (
	echo 正在硬重置本地目录／Hard resetting local world
	git.exe reset --hard origin/%branch%

	echo 一点点清理工作……／A little cleanup...
	git.exe clean -d -x -f

	xcopy /s /q ..\localstorage\* .
	echo 已复制本地资源文件，整合包现已完整／Copied local storage data for a full modpack
)

del ..\%packname%正在更新，请耐心等待.txt

cd ..
exit /b

:normalupdate
echo 正在检查更新／Checking for updates
set POLICY=ours

REM 检测互联网连接
ping gitee.com -n 1 > nul
if errorlevel 1 (
	echo Gitee没ping通，你的互联网连接大概有问题，放弃更新
	exit 1
)

echo 正在提交本地更改／Commiting local changes
git.exe commit --quiet --all -m local_autocommit

echo 正在拉取远端更新／Fetching remote changes
git.exe fetch origin %branch%

git.exe merge -s recursive -X %POLICY% origin/%branch%
echo 已应用远端更新／Applied remote changes

cd ..
exit /b
