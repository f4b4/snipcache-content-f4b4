@echo off
title WinVim
color a
cls
echo WinVim 1.02
echo.
echo To save press CTRL+Z then press enter
echo.
echo Make sure to include extension in file name
set /p name=File Name:
copy con %name%
if exist %name% copy %name% + con