<#========================================================================
# Created with: PowerShell ISE
# Created on:   
# Created by:   Coradi
# Organization: 
# Filename:     Remover 


#======================================================================== #>
#Get-AuthenticodeSignature

Set-ExecutionPolicy Unrestricted -Force

If ($PSVersionTable.PSVersion.Major -lt 5)
{
    Exit 30002 #Powershell desatualizado
}

#=======================================================[Inicialização]=======================================================
#region 0_Inicializacao

$version = "xx"

#Variáveis Gerais
$scriptname = $MyInvocation.MyCommand.Name
if ($PSCommandPath -ne "") { $scriptPath = Split-Path -parent $PSCommandPath } else { $scriptPath = (Get-Location).Path }
$retorno = 0
$Infra = "C:\TEMP\Infra"
$sDomain = "dominio"

#Variáveis específicas
$ProductShort = "RemoverX"
$MotorPath = "C:\Temp\Infra\RemoverX"

#Variáveis de Log
$InfraLogs ="C:\TEMP\Infra\Logs" 
if ($ProductShort -eq ""){ $LogPath = $InfraLogs }
else {$LogPath = Join-Path -Path $InfraLogs -ChildPath "$ProductShort"}
$LogName = "$ProductShort-$(Get-Date -Format yyyyMMdd-HHmm).log" 

#endregion 0_Inicializacao

#==========================================================[Funcoes]==========================================================
#region 1_Funcoes

    Function Write-Log()
    {
        <#
        .SYNOPSIS
            Writes A Given Message To The Specified Log File

        .DESCRIPTION
            Writes a message to the specified log file
            Return: What was written to the log
        .PARAMETER sMessage
            Message to write to the log file

        .PARAMETER iTabs
            Number of tabs to indent text

        .PARAMETER sFileName
            Name of the log file

        .INPUTS
            [-sLogFolder] <String> Path of the log file to write
            [-sLogFileName] <String> Filename of log to write
            [-sMessage] <String> Content to write to the log file
            [-iTabs] <Int32> Number of tabs to append at the beginning of the line

        .OUTPUTS
            <String> What was written to the log

        .EXAMPLE
            Write-Log -sLogFolder "C:\TEMP" -sLogFileName "test_task2.log" -sMessage "The message is ....." -iTabs 0 

        .NOTES
            
        #>
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory = $true, HelpMessage = "Log Text")]
            [Alias("LogText", "LogMessage")]
            [String]$sMessage = "",
            [Parameter(Mandatory = $false, HelpMessage = "Log Path")]
            [Alias("LogPath")]
            [String]$sLogFolder = $LogPath,
            [Parameter(Mandatory = $false, HelpMessage = "Log File Name")]
            [Alias("LogName")]
            [String]$sLogFileName = $LogName, #TODO: remover dependência de variável externa
            [Parameter(Mandatory = $false, HelpMessage = "Tabs at left")]
            [Alias("Tabs")]
            [Int]$iTabs = 0
        )
        #Write to host when $global:bDebug is $true
        If ($global:bDebug) { Write-Host $sContent -ForegroundColor Yellow -BackgroundColor Black }
                
        #Function's main 'Try'
        Try
        {
            #Loop through tabs provided to see If text should be indented within file
            $sTabs = ""
            For ($a = 1; $a -le $iTabs; $a++) { $sTabs = $sTabs + "`t" }
            
            #Populated content with tabs and message
            $sContent = "$(Get-Date -Format G) | $sTabs" + $sMessage
            
            #Define $sLogFile with the full file name
            $sLogFile = Join-Path -Path $sLogFolder -Childpath $sLogFileName
            
            #Verifica se a folder de logs existe, senão cria
            If (!(Test-Path $sLogFolder)) { New-Item $sLogFolder -ItemType Directory }

            #Verifica se o arquivo de log existe
            If (Test-Path $sLogFile -PathType Leaf)
                {
                    #Write contect to the file and If debug is on, to the console for troubleshooting
                    Try { Add-Content -Path $sLogFile -Value $sContent -Force }
                    Catch { $sContent = "ERROR: Log File '$sLogFile' could NOT be appended." }
                }
                Else { 
                    # "Arquivo de log  '$sLogFile'não existe."
                    $result = New-Item $sLogFile -ItemType File
                    $result = Add-Content -Path $sLogFile -Value $sContent -Force
                }
        }
        Catch { throw "Major failure. Error`: $($Error[0].Exception.ToString())" }
    } #End Of Write-Log
        Function Verify-SoftwareInstalled
    {
        <#
        .SYNOPSIS
            Verify that a specific product is installed

        .DESCRIPTION
            Searches for a product based on registry information either from HKLM Uninstall key or Installer 

        .INPUTS
            [-Name] Product name to be removed. Can be partial (mandatory)
            [-Version] Specific version. Can be partial (optional)
            
        .OUTPUTS
            [System.Collections.ArrayList] custom object array with product information found

        .EXAMPLE
            Verify-SoftwareInstalled -Name "Office"
            Verify-SoftwareInstalled -Name "Office" -Version "5"

        .NOTES
                
        #>
        [CmdletBinding()]
        Param (
            [Parameter(Mandatory = $true, HelpMessage = "Nome do Produto")]
                [String]$Name = "",
            [Parameter(Mandatory = $false, HelpMessage = "Versão")]
                [String]$Version = "*",
            [Parameter(Mandatory = $false, HelpMessage = "Somente verifica sem imprimir a versao")]
                [bool]$Silent = $false
        )

        #Variáveis de controle
        $ProcessWait = 1
        [System.Collections.ArrayList]$aInstalledProducts = @()

        $regKeys = @("HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
                    "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Installer\UserData\S-1-5-18\Products",
                    "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall")
        
        if (!$Silent) { $Action = "Verifica Software"; Write-Log -LogText "$Action $Name versao $Version" -iTabs 1 }
        foreach ($hive in $regKeys)
        {
            if ($hive.Contains("WOW6432") -and $env:PROCESSOR_ARCHITECTURE -eq "x86") {
                if (!$Silent) { write-log "Hive WOW6432Node é somente para sistemas 64-bits. Ignorando" -iTabs 2 }
                continue
            } else {
                $reg = Get-ChildItem $hive
            }

            foreach ($prod in $reg) 
            {   
                $oProduct = [PSCustomObject]@{
                                Name = "";
                                Version = "";
                                Uninstall = "";
                                Windowstyle = "Normal"
                            }

                if (($prod.ValueCount -gt 0) -and ($prod.OpenSubKey("InstallProperties") -ne $null)) {
                    $prod = $prod.OpenSubKey("InstallProperties")
                } 

                if (($prod.getvalue("DisplayName") -like "*$Name*") -and ($prod.getvalue("DisplayVersion") -like "$Version*")) {
                    $oProduct.Name = $prod.getvalue("DisplayName")
                    $oProduct.Version = $prod.getvalue("DisplayVersion")
                    
                    if ($prod.GetValue("QuietUninstallString") -and ($Quiet -eq $true)) { 
                        $oProduct.Uninstall = $prod.getvalue("QuietUninstallString")
                        $oProduct.Windowstyle = "Hidden"
                    } else {
                        if ($prod.getvalue("UninstallString") -eq $null) {
                            $oProduct.Uninstall = "N/A"
                        } else {
                            $oProduct.Uninstall = $prod.getvalue("UninstallString")
                        }
                    }

                    if (!$Silent)
                    { 
                        Write-Log "Produto detectado: " -iTabs 1
                        Write-Log "Chave: $($prod.Name)" -iTabs 2
                        Write-Log "Nome: $($oProduct.Name)" -iTabs 2
                        Write-Log "Versão: $($oProduct.Version)" -iTabs 2
                        Write-Log "Uninstall: $($oProduct.Uninstall)" -iTabs 2
                    }

                    $aInstalledProducts += $oProduct
                } 
            }
        }

        if ($aInstalledProducts.Count -gt 0 ){
            return $aInstalledProducts
        } 
        else{
            If (!$Silent) { Write-Log "Nenhum produto instalado no sistema com o nome $Name Versão $Version" -iTabs 2 }
            return $null
        }
    } #Function Verify-SoftwareInstalled
    $stringremove = Verify-SoftwareInstalled "Nome do software" | select Uninstall #utilizado para verificar nome do software
    
    if ($null -ne (Verify-SoftwareInstalled "Nome do software")){

        #condição, se exisitir software com nome X ignorar
        if (($null -ne (Verify-SoftwareInstalled "Nome do software")) -or ($null -ne (Verify-SoftwareInstalled "Nome do software")) -or ($null -ne (Verify-SoftwareInstalled "Nome do software")) -or ($null -ne (Verify-SoftwareInstalled "Nome do software"))){
        
               ForEach ($remove in $stringremove){
           
               $string = $remove.uninstall
               $string = $string.Replace("MsiExec.exe /I","/qn /X")
               Write-Log "Executando string: $string" -iTabs 1
               Start-Process msiexec.exe -ArgumentList $string -Wait
               }

        }else{Write-Log "Nome do software X localizado" -iTabs 1}
    
    }else{Write-Log "Nome do software de comparação identificado" -iTabs 1}
