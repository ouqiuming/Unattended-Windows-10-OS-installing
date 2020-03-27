@echo off
::寻找OS安装盘的盘符, 用Owen这个文件夹来做标记
for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
if exist %%a:\Owen\ set IMAGESDRIVE=%%a
)
echo The OS folder is on drive: %IMAGESDRIVE%

for %%b in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (
if exist %%b:\20H1\ set IMAGESDRIVE_20H1=%%b
)
echo The OS(20H1) folder is on drive: %IMAGESDRIVE_20H1%

::判断测试系统能否识别到内置的硬盘, 如果不能识别则退出安装.
set getdiskinfo=%IMAGESDRIVE%:\getdiskinfo.txt
set diskinfo=%IMAGESDRIVE%:\diskinfo.txt
set lastdisk=%IMAGESDRIVE%:\lastdisk.txt

diskpart /s %getdiskinfo% > %diskinfo%
echo=
echo ==================Disk info==================
for /f "delims=~" %%i in (%diskinfo%) do echo %%i
echo ==================End========================
echo=

for /f "delims=" %%i in (%diskinfo%) do (
set lastLine=%%~i
)
echo %lastLine% > %lastdisk%
for /f "tokens=2" %%x in (%lastdisk%) do (
set lastdisksign=%%~x
)

if %lastdisksign% equ 0 goto exit_install_no_disk
echo The last disk sign is %lastdisksign%, it is mean can find inbuilt disk.
echo=

::判断输入的变量, 做出跳转.
%IMAGESDRIVE%:

:Select_OS
echo ============================================================
echo 1. 19H1
echo 2. 19H2
echo 3. 20H1
echo 4. RS5
echo 5. Boot to WinPe
echo 6. Exit WinPe
echo ============================================================
set OS="test"
set /p OS=please enter you want to install OS:

if %OS%=="test" goto Select_OS
if %OS% equ 1 goto 19H1
if %OS% equ 2 goto 19H2
if %OS% equ 3 goto 20H1
if %OS% equ 4 goto RS5
if %OS% equ 5 goto Exit_Install
if %OS% equ 6 goto Exit_WinPe
Echo Parameter error, please re-choose.
goto Select_OS

:RS5
echo ============================================================
echo 1. RS5 Pro
echo 2. RS5 Home
echo 0. Parent directory
echo ============================================================
set OS="test"
set /p OS=please enter you want to install OS:
if %OS%=="test" goto Select_OS
if %OS% equ 0 goto Select_OS
if %OS% equ 1 goto RS5_Pro
if %OS% equ 2 goto RS5_Home
Echo Parameter error, please re-choose.
goto Select_OS

:RS5_Pro
echo installing RS5
%IMAGESDRIVE%:\RS5\setup.exe /unattend:%IMAGESDRIVE%:\autounattend_Pro.xml
goto RS5

:RS5_Home
echo installing RS5
%IMAGESDRIVE%:\RS5\setup.exe /unattend:%IMAGESDRIVE%:\autounattend_home.xml
goto RS5

:19H1
echo ============================================================
echo 1. 19H1 Pro
echo 2. 19H1 Home
echo 0. Parent directory
echo ============================================================
set OS="test"
set /p OS=please enter you want to install OS:
if %OS%=="test" goto Select_OS
if %OS% equ 0 goto Select_OS
if %OS% equ 1 goto 19H1_Pro
if %OS% equ 2 goto 19H1_Home
Echo Parameter error, please re-choose.
goto Select_OS
:19H1_Pro
echo installing 19H1
%IMAGESDRIVE%:\19H1\setup.exe /unattend:%IMAGESDRIVE%:\autounattend_Pro.xml
goto Select_OS
:19H1_Home
echo installing 19H1
%IMAGESDRIVE%:\19H1\setup.exe /unattend:%IMAGESDRIVE%:\autounattend_Home.xml
goto Select_OS

:19H2
echo ============================================================
echo 1. 19H2 Pro
echo 2. 19H2 Home
echo 0. Parent directory
echo ============================================================
set OS="test"
set /p OS=please enter you want to install OS:
if %OS%=="test" goto Select_OS
if %OS% equ 0 goto Select_OS
if %OS% equ 1 goto 19H2_Pro
if %OS% equ 2 goto 19H2_Home
Echo Parameter error, please re-choose.
goto Select_OS
:19H2_Pro
echo installing 19H2
%IMAGESDRIVE%:\19H2\setup.exe /unattend:%IMAGESDRIVE%:\autounattend_Pro.xml
goto Select_OS
:19H2_Home
echo installing 19H2
%IMAGESDRIVE%:\19H2\setup.exe /unattend:%IMAGESDRIVE%:\autounattend_Home.xml
goto Select_OS

:20H1
echo installing 20H1
%IMAGESDRIVE_20H1%:\20H1\setup.exe /unattend:%IMAGESDRIVE%:\autounattend_Pro.xml
goto Select_OS

:Exit_WinPe
exit

:exit_install_no_disk
echo Cannot find disk

:Exit_Install
echo Boot to Winpe