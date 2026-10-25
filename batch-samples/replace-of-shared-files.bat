@rem deploy FmtTicketTool

REM close open files
for /f "skip=4 tokens=1" %%a in ('net files') do net files %%a /close

rename "%TicketToolDir%\FmtTicketTool.exe" "FmtTicketTool.exe_"
rename "%TicketToolDir%\FmtTicketTool.xml" "FmtTicketTool.xml_"
rename "%TicketToolDir%\FmtTickets.dll" "FmtTickets.dll_"
rename "%TicketToolDir%\sscmapi.dll" "sscmapi.dll_"

xcopy /y bin\Release\FmtTicketTool.exe "%TicketToolDir%"
@If Errorlevel 1 goto Failed
xcopy /y bin\Release\FmtTicketTool.xml "%TicketToolDir%"
@If Errorlevel 1 goto Failed
xcopy /y bin\Release\FmtTickets.dll "%TicketToolDir%"
@If Errorlevel 1 goto Failed
xcopy /y bin\Release\sscmapi.dll "%TicketToolDir%"
@If Errorlevel 1 goto Failed

del "%TicketToolDir%\FmtTicketTool.exe_"
del "%TicketToolDir%\FmtTicketTool.xml_"
del "%TicketToolDir%\FmtTickets.dll_"
del "%TicketToolDir%\sscmapi.dll_"


@echo ############################################################################
@echo ##############                 S U C C E S S               #################
@echo ############################################################################
@pause

@goto End

:Failed
@echo ############################################################################
@echo ##############                    F A I L                  #################
@echo ############################################################################
@pause

:End
