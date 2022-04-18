$OUpath = 'OU=UsuariosExtranet,DC=extranet'
$ExportPath = 'C:\Temp\Exchange\users_in_ou1.csv'
Get-ADUser -Filter * -SearchBase $OUpath | Select-object DistinguishedName,Name,UserPrincipalName,mail | Export-Csv -NoType $ExportPath
