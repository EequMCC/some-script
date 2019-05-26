@echo off&setlocal enabledelayedexpansion
if not exist D:\youtube-dl\history.log cd.>D:\youtube-dl\history.log
set "pl=%~dp0"
echo %pl%|find " ">nul &&echo 路径%pl%中含有空格！&&exit
set proxy=--proxy "socks5://127.0.0.1:1080/"
goto A

:A
echo 当前目录%pl%，代理到%proxy:~7%
echo 【直接回车】从videos.txt中读取链接【输入“px”】设置代理【输入“ot”】更多功能
set/p "Str=请输入链接："
if not defined Str (goto T)
if /i "%Str%"=="px" (goto Px)
if /i "%Str%"=="ot" (goto Man)
set/a kk=0&&set/a count+=1&&set/a n+=1
goto EchoQ

:Px
set/p mproxy=请输入代理链接（默认无）：
if not defined mproxy (set proxy= ) else (set proxy=--proxy "%mproxy%")
set Str=&&set mproxy=
cls
goto A

:T
set/a kk=1
if EXIST %pl%videos.txt goto B
echo 请将视频链接复制到此处，一行一个（本行须删除）>%pl%videos.txt
start %pl%videos.txt
pause
goto B

:B
set/a n=0
set/a Line=0
for /f "delims=" %%i in (%pl%videos.txt) do (set/a n+=1)
if %n%==0 (echo 没有链接&&echo.&&goto A)
goto EchoQ

:EchoQ
echo 视频：[134]360p	[135]480p	[136]720p	[137]1080p	[271]2k      [313]4k
echo 音频：[249,250]低比特率[171]中比特率	[140,251]高比特率
echo 自定：[man]自选清晰度	[man+代码]直接下载该代码音视频
echo 字幕：[sub]自选字幕	[sub+语言]直接下载该语言字幕	[aut]下载自动生成的字幕	
set strv="134-135-136-137-271-313"
set stra="249-171-140"
goto InQ

:InQ
set/p q=请输入（默认最清晰视频）：
if defined q (set "msub=%q:~4%") else (set msub=)
if defined q (set "mfm=%q:~4%") else (set mfm=)
if defined q set "q=%q:~0,3%"
if not defined q (set av=视频&&set fc=&&set q=mr&&goto C)
for %%i in (134,135,136,137,271,313,249,171,140,man,sub,aut) do (if /i %%i==%q% goto SetQ)
set q=&&goto InQ

:SetQ
if /i %q%==sub (set fc=--write-sub --sub-lang %msub% --skip-download&&set av=字幕&&goto C)
if /i %q%==aut (set fc=--write-auto-sub --skip-download&&set av=字幕&&goto C)
if /i %q%==man (set fc=-f %mfm%&&set av=自定&&goto C)
echo %strv%|find /i "%q%">nul &&set av=视频&&set fc=-f %q%+140&&goto C
echo %stra%|find /i "%q%">nul &&set av=音频&&set fc=-f %q%&&goto C

:C
if %kk%==0 (goto StrV)
if %Line% gtr 0 set Skip=skip=%Line%
set/a count=%Line%+1
for /f "%Skip% delims=" %%i in (%pl%videos.txt) do (
        set "Str=%%~i"
        goto StrV
)

:StrV
echo "%Str%"|find /i "&">nul&&(for /f "delims=&" %%i in ("%Str%") do (set "Str=%%i"))
if %q%==sub (goto Subs)
if %q%==man (goto Formats)
goto D

:Formats
if defined mfm (goto D) else (set fm=)
echo.
echo 获取第%count%/%n%个%av%信息......
youtube-dl %proxy% -R infinite -F "%Str%"
if errorlevel 1 (echo.&&set Str=&&goto A)
set/p fm=请输入（默认最清晰视频）：
if not defined fm (set fc=) else (set fc=-f %fm%)
goto D

:Subs
if defined msub (goto D) else (set sub=)
echo.
echo 正在获取字幕代码......
youtube-dl %proxy% --list-subs "%Str%"
if errorlevel 1 (echo.&&set Str=&&goto A)
set/p sub=请输入字幕代码（默认全部）：
if not defined sub (set fc=--all-subs --skip-download) else (set fc=--write-sub --sub-lang %sub%  --skip-download)
goto D

:D
echo.
echo 正在下载第%count%/%n%个%av%，请稍等......
youtube-dl %proxy% --console-title -o "%pl%%%(title)s.%%(ext)s" %fc% "%Str%"
if errorlevel 1 (set er=%er%%count%，&&echo %Str%>>%pl%未下载视频.txt) else (findstr /i /c:"%Str%" "D:\youtube-dl\history.log">nul 2>nul||echo %Str%>>E:\youtube-dl\history.log)
set/a Line+=1
if %Line% == %n% (goto Fn) else (goto C)

:Fn
if defined er set er=%er:~0,-1%
if defined er (set note=，第%er%个未下载，请查看“%pl%未下载视频.txt”) else (set note=)
echo.&&echo %av%下载完成%note%
set q=&&set Str=&&set er=&&set Skip=
echo.
goto A

:Man
cls
echo -U			升级youtube-dl			--list-subs		列出所有字幕
echo -j, --dump-json		获取JSON信息			--all-subs		下载所有可用的字幕
echo -F, --list-formats	列出所有可用格式		--write-auto-sub	下载自动生成的字幕(仅YouTube)
echo -f, --format		指定格式，+号连接多个		--sub-lang		指定字幕语言,请使用英文逗号分隔
echo -g, --get-url		获取视频直连			--skip-download		不下载视频
echo -e, --get-title		获取标题			--embed-subs		将字幕嵌入视频(仅mp4,webm和mkv)
echo --get-id		获取id				%%pl%%			代替当前目录
echo --get-description	获取视频描述			%%y%%			youtube-dl
echo --get-duration		获取视频长度
echo --get-filename		获取输出视频文件名
echo --playlist-start	指定列表开始位置
echo --playlist-end		指定列表结束位置
echo --playlist-items	指定列表特定位置		exit			返回主菜单
set px=--proxy "socks5://127.0.0.1:1080/"
set y=youtube-dl %px% 
echo.
set Str=
%~d0
cd %pl%
call cmd
cls
goto A