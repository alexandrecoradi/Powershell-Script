#================================================================================
# Organization: Infra 
# Description:  Habilitar Ponto de Restauração 
# Created by:   
# Created on:   
# Type deploy:  LANDesk
#================================================================================

$CheckPointName = "InfraRestore"

Enable-ComputerRestore -Drive "C:"
Checkpoint-Computer -Description $CheckPointName -RestorePointType APPLICATION_INSTALL                                                     
$CheckStatusRestorePoint = Get-WmiObject -Namespace "root/default" -Query "SELECT * FROM SystemRestore WHERE Description='$CheckPointName'"

if ($CheckStatusRestorePoint.Description -eq $CheckPointName) {

    Exit 0

} else {

    Exit 30000

}
