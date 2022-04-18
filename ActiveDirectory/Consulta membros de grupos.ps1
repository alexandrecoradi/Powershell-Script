Get-ADGroupMember  -identity "migracao" | get-aduser -Properties * | select samaccountname, mail, extensionAttribute9,enabled
