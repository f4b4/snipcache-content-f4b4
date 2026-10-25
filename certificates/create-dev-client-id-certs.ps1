$password='keins'

for ($i = 9999999; $i > 999900; $i--)
{
    $fileName = 'CommServ' + $i
    $subject='/CN=' + $fileName + '/OU=' + $fileName + '/O=DUD-TEST ONLY'
    $privatePemName = $fileName + '-private.pem'
    $pemName = $fileName + '.pem'
    $pfxName = $fileName + '.pfx'
    $crtName = $fileName + '.crt'
    $cerName = $fileName + '.cer'
	$passParam = 'pass:' + $password

	# Creates CommServ<ClientId>.cer und CommServ<ClientId>.pfx certificates
	# for all ClientIds in the database.
    & openssl req -newkey rsa:2048 -nodes -keyout $privatePemName -x509 -days 365 -out $pemName -subj $subject
	& openssl pkcs12 -inkey $privatePemName -in $pemName -export -out $pfxName -password $passParam
	& openssl pkcs12 -in $pfxName -out $crtName -nokeys -clcerts -password $passParam
	& openssl x509 -inform pem -in $crtName -outform der -out $cerName
	
	Remove-Item $pemName
	Remove-Item $crtName
	Remove-Item $privatePemName
}
