@echo off
set EXEC_DIR= "C:\Projekte\Batch\check-current-dir"

rem aktuelles Verzeichnis ueberpruefen, darf Script darf nur dort ausgefuehrt
rem werden
if not "%EXEC_DIR%" == "%CD%" goto error

goto end

:error
echo -- ERROR ------------------------------------------------------------------
echo Script darf in diesem Verzeichnis nicht ausgefuehrt werden.
echo -- ERROR ------------------------------------------------------------------

:end
