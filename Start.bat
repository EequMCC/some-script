@echo off&setlocal enabledelayedexpansion
if not exist D:\youtube-dl\history.log cd.>D:\youtube-dl\history.log
set "pl=%~dp0"
echo %pl%|find " ">nul &&echo ·��%pl%�к��пո�&&exit
set proxy=--proxy "socks5://127.0.0.1:1080/"
goto A

:A
echo ��ǰĿ¼%pl%������%proxy:~7%
echo ��ֱ�ӻس�����videos.txt�ж�ȡ���ӡ����롰px�������ô������롰ot�������๦��
set/p "Str=���������ӣ�"
if not defined Str (goto T)
if /i "%Str%"=="px" (goto Px)
if /i "%Str%"=="ot" (goto Man)
set/a kk=0&&set/a count+=1&&set/a n+=1
goto EchoQ

:Px
set/p mproxy=������������ӣ�Ĭ���ޣ���
if not defined mproxy (set proxy= ) else (set proxy=--proxy "%mproxy%")
set Str=&&set mproxy=
cls
goto A

:T
set/a kk=1
if EXIST %pl%videos.txt goto B
echo �뽫��Ƶ���Ӹ��Ƶ��˴���һ��һ����������ɾ����>%pl%videos.txt
start %pl%videos.txt
pause
goto B

:B
set/a n=0
set/a Line=0
for /f "delims=" %%i in (%pl%videos.txt) do (set/a n+=1)
if %n%==0 (echo û������&&echo.&&goto A)
goto EchoQ

:EchoQ
echo ��Ƶ��[134]360p	[135]480p	[136]720p	[137]1080p	[271]2k      [313]4k
echo ��Ƶ��[249,250]�ͱ�����[171]�б�����	[140,251]�߱�����
echo �Զ���[man]��ѡ������	[man+����]ֱ�����ظô�������Ƶ
echo ��Ļ��[sub]��ѡ��Ļ	[sub+����]ֱ�����ظ�������Ļ	[aut]�����Զ����ɵ���Ļ	
set strv="134-135-136-137-271-313"
set stra="249-171-140"
goto InQ

:InQ
set/p q=�����루Ĭ����������Ƶ����
if defined q (set "msub=%q:~4%") else (set msub=)
if defined q (set "mfm=%q:~4%") else (set mfm=)
if defined q set "q=%q:~0,3%"
if not defined q (set av=��Ƶ&&set fc=&&set q=mr&&goto C)
for %%i in (134,135,136,137,271,313,249,171,140,man,sub,aut) do (if /i %%i==%q% goto SetQ)
set q=&&goto InQ

:SetQ
if /i %q%==sub (set fc=--write-sub --sub-lang %msub% --skip-download&&set av=��Ļ&&goto C)
if /i %q%==aut (set fc=--write-auto-sub --skip-download&&set av=��Ļ&&goto C)
if /i %q%==man (set fc=-f %mfm%&&set av=�Զ�&&goto C)
echo %strv%|find /i "%q%">nul &&set av=��Ƶ&&set fc=-f %q%+140&&goto C
echo %stra%|find /i "%q%">nul &&set av=��Ƶ&&set fc=-f %q%&&goto C

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
echo ��ȡ��%count%/%n%��%av%��Ϣ......
youtube-dl %proxy% -R infinite -F "%Str%"
if errorlevel 1 (echo.&&set Str=&&goto A)
set/p fm=�����루Ĭ����������Ƶ����
if not defined fm (set fc=) else (set fc=-f %fm%)
goto D

:Subs
if defined msub (goto D) else (set sub=)
echo.
echo ���ڻ�ȡ��Ļ����......
youtube-dl %proxy% --list-subs "%Str%"
if errorlevel 1 (echo.&&set Str=&&goto A)
set/p sub=��������Ļ���루Ĭ��ȫ������
if not defined sub (set fc=--all-subs --skip-download) else (set fc=--write-sub --sub-lang %sub%  --skip-download)
goto D

:D
echo.
echo �������ص�%count%/%n%��%av%�����Ե�......
youtube-dl %proxy% --console-title -o "%pl%%%(title)s.%%(ext)s" %fc% "%Str%"
if errorlevel 1 (set er=%er%%count%��&&echo %Str%>>%pl%δ������Ƶ.txt) else (findstr /i /c:"%Str%" "D:\youtube-dl\history.log">nul 2>nul||echo %Str%>>E:\youtube-dl\history.log)
set/a Line+=1
if %Line% == %n% (goto Fn) else (goto C)

:Fn
if defined er set er=%er:~0,-1%
if defined er (set note=����%er%��δ���أ���鿴��%pl%δ������Ƶ.txt��) else (set note=)
echo.&&echo %av%�������%note%
set q=&&set Str=&&set er=&&set Skip=
echo.
goto A

:Man
cls
echo -U			����youtube-dl			--list-subs		�г�������Ļ
echo -j, --dump-json		��ȡJSON��Ϣ			--all-subs		�������п��õ���Ļ
echo -F, --list-formats	�г����п��ø�ʽ		--write-auto-sub	�����Զ����ɵ���Ļ(��YouTube)
echo -f, --format		ָ����ʽ��+�����Ӷ��		--sub-lang		ָ����Ļ����,��ʹ��Ӣ�Ķ��ŷָ�
echo -g, --get-url		��ȡ��Ƶֱ��			--skip-download		��������Ƶ
echo -e, --get-title		��ȡ����			--embed-subs		����ĻǶ����Ƶ(��mp4,webm��mkv)
echo --get-id		��ȡid				%%pl%%			���浱ǰĿ¼
echo --get-description	��ȡ��Ƶ����			%%y%%			youtube-dl
echo --get-duration		��ȡ��Ƶ����
echo --get-filename		��ȡ�����Ƶ�ļ���
echo --playlist-start	ָ���б�ʼλ��
echo --playlist-end		ָ���б����λ��
echo --playlist-items	ָ���б��ض�λ��		exit			�������˵�
set px=--proxy "socks5://127.0.0.1:1080/"
set y=youtube-dl %px% 
echo.
set Str=
%~d0
cd %pl%
call cmd
cls
goto A