set MC="C:\Program Files (x86)\Windows Kits\10\bin\10.0.15063.0\x64\makecert.exe"

set CLIENT_CERT=ClientCert
set SERVER_CERT=ServerCert

set CERT=%CLIENT_CERT%
makecert -n "CN=%CERT%" -r -sv %CERT%.pvk %CERT%.cer 
pvk2pfx /f /pvk %CERT%.pvk /spc %CERT%.cer /pfx %CERT%.pfx /pi "password" /po "password"

set CERT=%SERVER_CERT%
makecert -n "CN=%CERT%" -r -sv %CERT%.pvk %CERT%.cer 
pvk2pfx /f /pvk %CERT%.pvk /spc %CERT%.cer /pfx %CERT%.pfx /pi "password" /po "password"


rem makecert -sk SignedByCA -iv TempCA.pvk -n "CN=SignedByCA" -ic TempCA.cer SignedByCA.cer -sr currentuser -ss My
