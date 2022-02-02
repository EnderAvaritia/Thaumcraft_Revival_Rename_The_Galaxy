@echo off
REM 这段简单，配置仓库地址和分支，这个也就是区分不同周目的方法了
set branch=test
set origin=https://gitee.com/EnderAvaritia/Thaumcraft_Revival_Rename_The_Galaxy.git
set packname=神秘复兴·星瀚再临
REM 这次只用到了git和xcopy，故只设置这两个环境变量够了
set PATH=%WINDIR%\system32;%~dp0%git-mini

title %packname% 正在更新

REM 检测互联网连接
ping gitee.com -n 1 > nul
if errorlevel 1 (
	echo Gitee没ping通，你的互联网连接大概有问题，放弃更新
	exit 1
)

REM 展示运行时间，以确定这个日志是最新一次启动的时候生成的。这里的变量在后面备份的时候也有用到
FOR /F "tokens=1-4 delims=/ " %%i in ('date/t') do set localdate=%%i-%%j-%%k
FOR /F "tokens=*" %%t in ('time/t') do set localtime=%%t
echo %localdate% %localtime%

REM 无视具体位置，始终跳转到正确的.minecraft目录
cd /d %~dp0
cd ..\.minecraft

REM 若.minecraft因为异变把.git目录消除了，就报错；若没有初始化flag，则进行普通更新
REM 警告：切勿将下面的flag文件放进.minecraft目录，后果自负。
if not exist .git exit 1

REM 在参数里加firstupdate以直接进入dofirstupdate部分，这是为了配合相应vbs脚本使用，以在首次更新的较长时间里显示更新相关的窗口，避免用户产生疑惑
if "%~1" equ "firstupdate" (goto dofirstupdate)
REM 若不指定参数（正常情况），则根据是否存在flag文件来确定后续流程
if exist I_WANT_TO_RESET_WORLD (goto firstupdatehandler) else (goto normalupdate)

:dofirstupdate
echo 正在进行首次配置／Intializing local copy

REM 再次检查一下，以免出问题
if not exist I_WANT_TO_RESET_WORLD (exit 1)

REM 在localstorage目录创建更新指示文件（另一版本中在根目录创建，不过用户有可能给手动删掉这个文件，那就很尴尬）
type nul > ..\localstorage\UPDATE_IN_PROGRESS.txt

echo 正在创建关键本地数据备份／Creating a partial backup for less grief
if not exist saves (
	echo 未发现saves目录，整合包应当是全新的，跳过备份
	goto firstupdatepart2
	)
for %%f in (config, journeymap, saves) do xcopy /s /q /i /r /y %%f ..\localstorage\Backup-LocalReset-%localdate%\%%f
xcopy /r /y /q options.txt ..\localstorage\Backup-LocalReset-%localdate%\
xcopy /r /y /q optionsof.txt ..\localstorage\Backup-LocalReset-%localdate%\

:firstupdatepart2
echo 正在将资源文件复制到本地存储／Copying first-served files to local storage
for %%g in (assets, libraries, versions) do xcopy /s /q /i /r /y %%g ..\localstorage\rootdir\%%g
xcopy /r /y /q launcher_profiles.json ..\localstorage\rootdir\

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

echo 正在硬重置本地目录／Hard resetting local world
git.exe reset --hard origin/%branch%

echo 一点点清理工作……／A little cleanup...
git.exe clean -d -x -f

xcopy /s /q ..\localstorage\rootdir\* .
echo 已复制本地资源文件，整合包现已完整／Copied local storage data for a full modpack

del ..\localstorage\UPDATE_IN_PROGRESS.txt

cd ..
exit 0

:normalupdate
echo 正在检查更新／Checking for updates
set POLICY=t

echo 正在提交本地更改／Commiting local changes
git.exe commit --quiet --all -m local_autocommit

echo 正在拉取远端更新／Fetching remote changes
git.exe fetch origin %branch%

git.exe merge -s recursive -X %POLICY% origin/%branch%
echo 已应用远端更新／Applied remote changes

cd ..
exit 0

:firstupdatehandler
REM 进行首次更新的情况，此时需要显示cmd窗口以展示更新进度。
REM 这里的做法是用vbs重新启动一个cmd实例，然后用参数直接指定走firstupdate流程。没有再写一个文件来调用，是为了尽量减少文件数量
xcopy /r /y /q .\I_WANT_TO_RESET_WORLD ..\
cmd.exe /C "..\localstorage\update.vbs"

:checkfile
REM hmcl判断启动前执行命令的方法就是看它执行的第一个命令是否结束。因此，在前台更新的实例结束之前，这里的实例也必须保持运行。
REM 这里用等待并检查的循环，来判断更新过程是否已结束。
echo 正在等待更新完成...
ping localhost -n 4 > nul
if exist "..\localstorage\UPDATE_IN_PROGRESS.txt" (
goto checkfile
)

exit 0