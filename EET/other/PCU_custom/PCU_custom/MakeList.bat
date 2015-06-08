@echo off
cd PCU_custom

IF NOT EXIST "Filelist.txt" GOTO NODELETE
call deldir Output
del Filelist.txt

:NODELETE
::create filelist
xcopy Input\*.* /E /L >> Filelist.txt