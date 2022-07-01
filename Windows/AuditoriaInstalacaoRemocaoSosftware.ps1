#Auditoria instalação e remoção de software
function SendStatusWS_OPVSAT {
    param ( 
        [string]$ComputerName,
        [string]$ApplicationName,
        [string]$StatusSolution,
        [string]$Details
    )
    
    #Ambiente de HML
    #$url = "http://"
    
    #Ambiente de PRD
    $url = "http://"

    Invoke-RestMethod -URI $url
}



#Var de API
$Hostname = $Env:COMPUTERNAME
$ApplicationName = "MonitorSoftwareInstall"



(Get-WinEvent -FilterHashtable @{LogName="Application";ID=11707;ProviderName="MsiInstaller"}) |  foreach {
    $sid = $_.userid;
    if($sid -eq $null) { return; }
    $objSID = New-Object System.Security.Principal.SecurityIdentifier($sid);
    $objUser = $objSID.Translate([System.Security.Principal.NTAccount]);
    $TimeCreated = $_.TimeCreated;
    $MachineName = $_.MachineName;
    $Message = $_.Message;
    [string]$Details = "Usuário= " + "$objUser" + "; " + "Data=" + "$TimeCreated" + "; " + "$Message"
    $Details = $Details -replace 'Produto', 'Produto='
    $Details = $Details -replace 'Product', 'Produto='
    $Details = $Details -replace '/', ''
    $Details = $Details -replace '[^\p{L}\p{Nd}/()=; /_]', ''
    $Status = "Sucesso"
    SendStatusWS_OPVSAT -ComputerName $Hostname -ApplicationName $ApplicationName -StatusSolution $Status -Details $Details
    
}


(Get-WinEvent -FilterHashtable @{LogName="Application";ID=11724;ProviderName="MsiInstaller"}) |  foreach {
    $sid = $_.userid;
    if($sid -eq $null) { return; }
    $objSID = New-Object System.Security.Principal.SecurityIdentifier($sid);
    $objUser = $objSID.Translate([System.Security.Principal.NTAccount]);
    $TimeCreated = $_.TimeCreated;
    $MachineName = $_.MachineName;
    $Message = $_.Message;
    [string]$Details = "Usuário= " + "$objUser" + "; " + "Data=" + "$TimeCreated" + "; " + "$Message"
    $Details = $Details -replace 'Produto', 'Produto='
    $Details = $Details -replace 'Product', 'Produto='
    $Details = $Details -replace '/', ''
    $Details = $Details -replace '[^\p{L}\p{Nd}/()=; /_]', ''
    $Status = "Falha"
    SendStatusWS_OPVSAT -ComputerName $Hostname -ApplicationName $ApplicationName -StatusSolution $Status -Details $Details
    
}
