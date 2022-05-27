$comp = Get-Content C:\temp\IP-landesk.txt
$i = $comp.Count
foreach ($scan in $comp){

Invoke-WmiMethod –ComputerName $scan -Class win32_process -Name create -ArgumentList "C:\Program Files (x86)\LANDesk\LDClient\LDISCN32.EXE /f /sync"
$i = $i -1
Write-Host $i = $scan

#utilize se quiser verificar processo em execução remotamente. 
#Tasklist -s $scan | Select-String "LDISCN32.EXE"
}
