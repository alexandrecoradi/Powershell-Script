#===============================================
# Created with: Windows PowerShell
# Created on:   
# Created by:   Coradi
# reviewed by:  
# Organization: Infra 

# Resumo saida de erro:
# Erro1000 - Equipamento não é DHCP, neste caso quem distribui o DNS é o equipamento de network
# Erro1001 - Não foi localizado arquivo de backup das configurações
# Erro1002 - Não foi realizado o download do arquivo de restore

#===============================================


#informar o numero de DNS que deve ser utilizado pela ordem de prioridade na placa de rede
$DNSServers = "192.168.6.11","172.25.3.10","192.168.6.10"

#download arquivo de restore
$nomearquivo = "restore_dns.ps1"
$url = "http://URL/$nomearquivo"
$output = "C:\temp\$nomearquivo"
Invoke-WebRequest -Uri $url -OutFile $output

if(Test-Path "C:\temp\$nomearquivo")
{
    <#---------------------------------------------------------------------------------------------------
    verificar se adaptador de rede esta UP sendo que a descrição da placa é Intel.
    Pendente verificar se este é o melhor método.
    Isso é necessário pq podem existir adaptadores 4G conectados no computador
    ---------------------------------------------------------------------------------------------------#>
    $testeadap = get-wmiobject win32_networkadapter -filter {(netconnectionstatus = 2)} | where {$_.description -like "*Intel*"}
    $mac = $testeadap.MACAddress

    #verifica se o a rede é DHCP
    $recebe = Get-WmiObject -Class Win32_NetworkAdapterConfiguration  | Where-Object {($_.Macaddress -eq "$mac")}
    if ($recebe.DHCPEnabled)
        {
            #Network é DHCP
            exit 1000
        }
        else
        {
            #Network é IP fixo
            $adapters = Get-WmiObject -Class Win32_NetworkAdapterConfiguration  | Where-Object {($_.IPEnabled -eq $true) -and ($_.DHCPEnabled -eq $false) -and ($_.Macaddress -eq "$mac")}
            #backup das configurações de DNS antigas
            $adapters.DNSServerSearchOrder > "c:\temp\dnsinfo.txt"

            if (Test-Path c:\temp\dnsinfo.txt)
            {
                #configuração de DNS
                $adapters.SetDNSServerSearchOrder($DNSServers)
            }
            else
            {
                #Arquivo de restore não localizado
                exit 1001 
            
            }

        }
}
else
{
 exit 1002
}
