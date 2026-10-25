rem  /E  Kopiert alle Unterverzeichnisse (leer oder nicht leer).
rem  /Y  Unterdrückt die Aufforderung zur Best„tigung, dass eine
rem      vorhandene Zieldatei überschrieben werden soll.
rem  /H - Copies hidden and system files also. 
rem  /K - Copies attributes. Typically, Xcopy resets read-only attributes.
rem  /Q  Zeigt beim Kopieren keine Dateinamen an.
rem  /O - Copies file ownership and ACL information.
rem  /X - Copies file audit settings (implies /O)
xcopy <SOURCE_DIR> <DEST_DIR\> /e /h /y /k /q


rem /E     - copies all subdirectories (including empty ones)
rem /MT:32 - uses 32 threads for parallel copying (adjust based on your CPU)
rem /R:2   - retries only 2 times on failure
rem /W:5   - waits only 5 seconds between retries
robocopy <SOURCE_DIR> <DEST_DIR\> /E /MT:32 /R:2 /W:5
