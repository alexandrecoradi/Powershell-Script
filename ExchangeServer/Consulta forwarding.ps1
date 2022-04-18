$usuarios = Get-Content "user.txt"
foreach ($user in $usuarios)
{

Get-Mailbox $user | select PrimarySmtpAddress, ForwardingAddress, ForwardingSmtpAddress | Export-Csv "c:\temp\report\Forwarding.csv" -Append -Encoding UTF8

}
