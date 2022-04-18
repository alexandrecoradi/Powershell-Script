$cpf = Get-Content C:\temp\user.txt
foreach ($user in $cpf){
Get-ADUser -Filter {extensionAttribute9 -eq $user} -Properties * | select mail, extensionAttribute9, enabled  | Export-Csv c:\temp\getad.csv -Append -Encoding UTF8
}
