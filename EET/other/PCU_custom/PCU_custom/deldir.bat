VER |find /i "Windows 95" > NUL
IF NOT ERRORLEVEL 1 GOTO OLDDEL

VER |find /i "Windows 98" > NUL
IF NOT ERRORLEVEL 1 GOTO OLDDEL

VER |find /i "Windows Millennium" > NUL
IF NOT ERRORLEVEL 1 GOTO OLDDEL

VER | find "NT" > nul
IF %errorlevel% EQU 0 GOTO OLDDEL

VER | find "XP" > nul
IF %errorlevel% EQU 0 GOTO NEWDEL

VER | find "2000" > nul
IF %errorlevel% EQU 0 GOTO NEWDEL

:NEWDEL
rd /s /q %1
GOTO ENDDEL

:OLDDEL
deltree /y %1
GOTO ENDDEL

:ENDDEL