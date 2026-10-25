@echo off
SET MSBUILD=%WINDIR%\microsoft.net\framework\v4.0.30319\MSBuild.exe

REM Build for WPF40
%MSBUILD% ..\BuildControls.proj /property:Configuration=Release;Platform="Any CPU";WPF40=true;PlatformType=WPF;BuildControlsXaml=true;ReleaseDate=%1;DevelopmentFolder=$(MSBuildProjectDirectory)\..\..\;NoSA=true;NoCA=true;IsSourceCodeBuild=true %2 /l:FileLogger,Microsoft.Build.Engine;logfile=Build_WPF40.log;append=false;verbosity=detailed;encoding=utf-8