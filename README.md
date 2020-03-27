由于直接用autounattend.xml会有一定风险格式化的OS安装盘.
现在分享一个通过WinPE自动安装的方案来满足各种OS安装的要求.
这个WinPE现在有如下特性:

	自动寻找OS安装盘符

	自动判断测试系统是否识别到内置硬盘, 避免格式化U盘

	多种OS 版本集合一起, 通过批处理命令来选择安装.

	在U盘根目录放入autounattend_pro/home.xml, 然后创建RS5\19H1\19H2 文件夹, 并放入对应的OS安装文件.

U盘启动进入WinPE后, 可以输入对应的参数来安装不同的OS.

(autounattend_pro/home.xml设置的区域语言键盘是US, user: test, psw:1)
 

下面是怎么创建属于自己的WinPE 安装盘
Step to customize WinPE:
1.	创建一个pure 的WinPE环境,  大家可以从下面链接学习一下, 这里有一个我创建的pure WinPE.
https://docs.microsoft.com/en-us/windows-hardware/manufacture/desktop/winpe-create-usb-bootable-drive
2.	加载boot.wim文件
Dism /Mount-Image /ImageFile:"J:\sources\boot.wim" /index:1 /MountDir:"D:\WinPE_amd64\mount"
J:\sources\boot.wim 为WINPE的boot.wim路径
D:\WinPE_amd64\mount 为boot.wim的加载载路径.
3.	加载完boot.wim后, 找出Startnet.cmd文件来进行编辑, 位于D:\WinPE_amd64\mount\Windows\system32\Startnet.cmd.
(Startnet.cmd是winpe启动时自动运行的脚本, 写入自己的命令来达到我们的要求.)

比如: 寻找OS安装盘的盘符, 这里我用Owen来做标记符, 只要U盘根目录下创建Owen这个文件夹, 就可以找到你的盘符, 你也可以其他名称来替换.

for %%a in (C D E F G H I J K L M N O P Q R S T U V W X Y Z) do (if exist %%a:\Owen\ set IMAGESDRIVE=%%a)

echo The OS folder is on drive: %IMAGESDRIVE%

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

4.	修改完Startnet.cmd, 通过下面的命令卸载boot.wim.

Dism /Unmount-Image /MountDir:"d:\WinPE_amd64\mount" /commit
