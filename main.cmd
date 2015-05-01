@ECHO OFF

::==============================::
::  SteamCMD Auto Updater 1.0   ::
::           Credits            ::
::           C0nw0nk            ::
::==============================::

:: This is the SteamDEV api key required for automatic updates ::
:: If you do not have one you may obtain your API key from here = http://steamcommunity.com/dev/apikey ::
set steamkey=

:: This is the required login for SteamCMD to download updates ::
:: example = login=C0nw0nk Password ::
:: For most game servers you do not require this and can leave it as anonymous ::
:: Certain game servers you have to use a username and password to install them ::
set login=anonymous

:: This is the directory you wish to install and keep your server updated to ::
set install_directory=C:\game-servers\CSGO

:: This is the app ID of the game server you are installing / running ::
set appid=740

:: This is the app ID the url will check for updates on that game ::
:: Some games this is the same as the installation appid other games it is a different numeric value ::
:: if your latest-version.txt file is empty you need to make this value different to the installation appid, just go to the steam store page and get the appid from the end url ::
set update_appid=730

:: This is for the directory where you installed steamcmd ::
set steamcmd_path=c:\steamcmd\steamcmd.exe

:: This is the path to the exe of the game server this allows us to close and run the server for and after a update ::
:: Example ::
:: set exe_path=C:\game-servers\CSGO\srcds.exe -game csgo -console -usercon +game_type 0 +game_mode 0 +mapgroup mg_active +map de_dust2 ::
set exe_path=

:: This is the title of your server this will help you know what server this auto updater is running for ::
set servername=My CSGO#1 Server

:: Automatic Updating Interval (in seconds) this will set how often you check the steam servers for a new update ::
:: I recommend 5-10 mins ::
set interval=300

:: Don't edit anything past this point ::

:: I AM SERIOUS DO NOT TOUCH ::

:: DON'T MAKE ME HURT YOU! ::

:: il fite u ::

:: Do you realy want some! ::

:: Come on don't be a skrub! ::

:: Sorry did not mean anything I just said go ahead and edit below this point see if I care (seriously just don't touch anything below this)::

:: for the fact you have even scrolled down this far shows your persistence ::

title SteamCMD Auto Updater V1.0   %servername%


if $SYSTEM_os_arch==x86 (
rem echo OS is 32bit
set curl=curl-32bit.exe
) else (
rem echo OS is 64bit
set curl=curl-64bit.exe
)

:loop
%curl% -o latest-version.txt ""http://api.steampowered.com/ISteamUserStats/GetSchemaForGame/v2/?key=%steamkey%^&appid=%update_appid%^&format=json"" > nul
if exist current-version.txt (
rem echo file exist so do nothing and perform file check to compare existing files
) else (
rem echo file doesn't exist so create it and update / install the game server to the latest version
COPY latest-version.txt current-version.txt
goto error
)
rem file check compare the latest game server version with the current and if they match or miss match
fc latest-version.txt current-version.txt > nul
if errorlevel 1 goto error
:next
rem echo file version match with currently installed so do nothing and attempt to start the server if not already running
rem get the running game server process id from our pid file
set /p texte=< pid.txt
rem echo %texte%
rem use the process id and check if it is running or not
setlocal enableDelayedExpansion
set "cmd=tasklist.exe /FI "pid eq %texte%""
for /F "delims=*" %%p in ('!cmd! ^| findstr "%texte%" ') do (
rem echo pid running and found %%p
timeout /t %interval% /NOBREAK
goto loop
)
rem echo pid not found pause so start running the game server and get game server pid
rem process id in pid file not found or running so lets start the game server to get it running and store the game server pid in the file
for /f "tokens=2 delims==; " %%a in (' wmic process call create "%exe_path%" ^| find "ProcessId" ') do set PID=%%a
rem echo %PID% > pid.txt
timeout /t %interval% /NOBREAK
goto loop
pause
:error
rem echo failed check so execute steamcmd to update / install the server
rem First we have to kill the running game server pid in order to update it
rem get the running game server process id from our pid file
set /p texte=< pid.txt
rem echo %texte%
rem use the process id and check if it is running or not
setlocal enableDelayedExpansion
set "cmd=tasklist.exe /FI "pid eq %texte%""
for /F "delims=*" %%p in ('!cmd! ^| findstr "%texte%" ') do (
echo pid of game server running and found so kill / end the process %%p
taskkill /PID %texte%
)
rem execute updater and then close when updates installed and validated
%steamcmd_path% +login %login% +force_install_dir %install_directory% +app_update %appid% validate +quit
rem when update complete go back to the start and check for updates on a regular basis again and launch the updated game server
rem we cant forget to set the current version to the latest installed version
COPY latest-version.txt current-version.txt > nul
goto loop
pause