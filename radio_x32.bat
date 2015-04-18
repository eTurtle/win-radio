@echo off
:title

:: Создаем JS файл
echo var objFolder = (new ActiveXObject("Shell.Application")).BrowseForFolder(0, "Укажите директорию для сохранения файлов", 0);>>browse_dir.js
echo if (objFolder) WScript.StdOut.Write(objFolder.Self.Path);>>browse_dir.js

title RADIO RECORDS
del /f /s /q %tmp%\*.m3u
cls
IF NOT EXIST "%programfiles%\streamripper\streamripper.exe" start "get" /wait "http://sourceforge.net/project/showfiles.php?group_id=6172&package_id=258843"

:: Проверяем файл настроек сохранения пути для записи
IF NOT EXIST %userprofile%\radio_save_dir goto browse_new_radio_save_dir
IF EXIST %userprofile%\radio_save_dir goto start_radio_save_dir

:: Если файл есть, берем из него путь для сохранения
:start_radio_save_dir
chcp 1251 > nul
for /f "usebackq tokens=* delims=" %%i In ("%userprofile%\radio_save_dir") do set file_save_dir=%%i
chcp 866 > nul

:: Удаляем JS файл
del /f /s /q browse_dir.js
cls

echo.
echo RADIO RECORDS
echo.
echo [1] DI.FM - Hard Dance
echo [2] DI.FM - Hard Core
echo [3] DI.FM - Breaks
echo [4] DI.FM - Euro Dance
echo [5] DI.FM - Classic Euro Dance
echo [6] DI.FM - Goa-Psy Trance
echo [7] DI.FM - Gabber
echo [8] DI.FM - Classic Euro Disco
echo [9] DI.FM - Drum N Bass
echo [a] HardCoreRadio.nl - Hard Core
echo [b] RadioZamZam.com
echo [c] WunschRadio.de - Wunsch Radio Schlager
echo [d] 181.FM - Bluegrass
echo [e] Radio Schizoid [PSYCHEDELIC TRANCE]

echo.
echo [0] Exit
echo.
echo ==================================================
echo Enter your choice:
SET /P startradio=
echo.

:start
SET tm=%time%
SET tm=%tm::=.%
SET tm=%tm:,=.%
SET tm=%tm: =0%
SET h=%tm:~0,-9%
SET m=%tm:~3,-6%
SET s=%tm:~6,-3%
SET dt=%date%
SET yyyy=%dt:~-4%
SET mm=%dt:~3,-5%
IF %mm%==01 SET mm=Jan
IF %mm%==02 SET mm=Feb
IF %mm%==03 SET mm=Mar
IF %mm%==04 SET mm=Apr
IF %mm%==05 SET mm=May
IF %mm%==06 SET mm=Jun
IF %mm%==07 SET mm=Jul
IF %mm%==08 SET mm=Aug
IF %mm%==09 SET mm=Sep
IF %mm%==10 SET mm=Oct
IF %mm%==11 SET mm=Nov
IF %mm%==12 SET mm=Dec
SET dd=%dt:~0,-8%

SET sr="%programfiles%\streamripper\streamripper.exe"
::SET dir="%file_save_dir%\%yyyy%.%dt:~3,-5%[%mm%].%dd%_(%h%.%m%.%s%)"
SET dir="%file_save_dir%\%yyyy%-%dt:~3,-5%-%dd%_-_%h%-%m%"
SET re=127.0.0.1:800

IF %startradio%==1 SET url="http://pub5.di.fm:80/di_harddance"
IF %startradio%==2 SET url="http://pub5.di.fm:80/di_hardcore"
IF %startradio%==3 SET url="http://pub5.di.fm:80/di_breaks"
IF %startradio%==4 SET url="http://pub5.di.fm:80/di_eurodance"
IF %startradio%==5 SET url="http://pub5.di.fm:80/di_classiceurodance"
IF %startradio%==6 SET url="http://pub6.di.fm:80/di_goapsy"
IF %startradio%==7 SET url="http://pub6.di.fm:80/di_gabber"
IF %startradio%==8 SET url="http://pub6.di.fm:80/di_classiceurodisco"
IF %startradio%==9 SET url="http://pub7.di.fm:80/di_darkdnb"
IF %startradio%==a SET url="http://shoutcast3.hardcoreradio.nl"
IF %startradio%==b SET url="http://188.165.156.97:8220"
IF %startradio%==c SET url="http://www.wunschradio.de/streamlinks/schlager/winamp.pls"
IF %startradio%==d SET url="http://uplink.duplexfx.com:8016/"
IF %startradio%==e SET url="http://78.46.73.237:8000/schizoid"
IF %startradio%==0 goto exit

SET station=%tmp%\%startradio%.m3u
echo http://%re%/ >> %station%
start "radio" /i %station%
%sr% %url% -d %dir% -i -r %re%

goto start

:: Если нет файла с настройками путей для сохранения - создаем его и отправляем в начало
:browse_new_radio_save_dir
chcp 1251 > nul
FOR /F "tokens=*" %%i IN ('cscript /nologo browse_dir.js') DO SET file_save_dir=%%i
echo %file_save_dir%>%userprofile%\radio_save_dir
chcp 866 > nul
attrib +h %userprofile%\radio_save_dir
goto title

:exit
exit
