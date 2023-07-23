@echo off
setlocal 
set SUSPEND=d:\Utils\sysinternals\pssuspend.exe
%SUSPEND% -nobanner wintracker.exe
%SUSPEND% -nobanner monitoringtool.exe
%SUSPEND% -nobanner summitagentmonitor.exe
%SUSPEND% -nobanner samagent.exe
%SUSPEND% -nobanner winmont.exe
