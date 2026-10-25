; openssl von http://slproweb.com/download/Win32OpenSSL-1_1_0h.exe

set CERT_NAME=CommServ9900001
set PWD=keins

openssl req -newkey rsa:2048 -nodes -keyout %CERT_NAME%-private.pem -x509 -days 365 -out %CERT_NAME%.pem -subj /CN=%CERT_NAME%/OU=%CERT_NAME%
openssl pkcs12 -inkey %CERT_NAME%-private.pem -in %CERT_NAME%.pem -export -out %CERT_NAME%.pfx -password pass:%PWD%
openssl pkcs12 -in %CERT_NAME%.pfx -out %CERT_NAME%.crt -nokeys -clcerts -password pass:%PWD%
openssl x509 -inform pem -in %CERT_NAME%.crt -outform der -out %CERT_NAME%.cer
