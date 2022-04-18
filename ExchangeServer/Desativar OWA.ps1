$user = Get-Content "C:\temp\Report\Disabled\conta_generica.txt"
$qtduser = $user.Count
$i=$qtduser

foreach ($desabilitar in $user){

Set-CASMailbox $desabilitar -ActiveSyncEnabled $false -OWAEnabled $false -PopEnabled $false -ImapEnabled $false -MapiEnabled $false

$i = $i -1
Write-Host $i = $desabilitar

}
