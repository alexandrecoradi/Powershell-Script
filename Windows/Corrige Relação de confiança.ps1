#Script corrige relação de confiança


$status= nltest /sc_query:nome do dominio
$status

$Usuario = "usuário com permissão para incluir computador no dominio" #dominio\usuário
$Senha = "safety.txt"
$KeyFile = "AES.key"
$Key = Get-Content $KeyFile

$Credential = New-Object –TypeName System.Management.Automation.PSCredential –ArgumentList $Usuario, (Get-Content $Senha | ConvertTo-SecureString -Key $key)

        If ($status -like "*ACCESS_DENIED*"){
           Test-ComputerSecureChannel -Repair -server nome do servidor de dominio -Credential $Credential
           

        }
        
  
