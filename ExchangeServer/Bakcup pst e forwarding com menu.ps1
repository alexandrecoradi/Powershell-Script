$Loop = $True
While ($Loop)
  {
  Clear-Host

  Write-Host '[1]  Criar Redirecionamento de e-mail'
  Write-Host '[2]  Criar Backup de e-mail'
  Write-Host '[3]  Consulta status da solicitação de backup'
  Write-Host '[4]  Exit'
  Write-Host

  $Option = Read-Host "Selecione a opcao [1-4]"
  Switch ($Option) 

    {

    1
    {
    Clear-Host

    Write-Host '[1]  Criar Redirecionamento de e-mail'			  


    $nome = Read-Host "Informar o nome completo"
    $emailpessoal = Read-Host "Informar o endereço de e-mail pessoal"
    $emailboti = Read-Host "Informar o endereço de e-mail xx.com.br"

    Write-Host
    Write-Host '** Revise as informações **'	
    Write-Host
    write-host "Nome:" -ForegroundColor Gray -NoNewline
    write-host $nome -ForegroundColor Green 
    write-host "E-mail pessoal:" -ForegroundColor Gray -NoNewline
    write-host  $emailpessoal -ForegroundColor Green 
    write-host "E-mail:" -ForegroundColor Gray -NoNewline
    write-host  $emailboti -ForegroundColor Green 
    Write-Host
    Write-Host

    if ($emailpessoal -like "*xx.com.br*" -or $emailboti -notlike "*xx.com.br*")
      {
        write-host
        write-host "Algo de errado com as informações" -BackgroundColor DarkRed
        write-host
      Pause

      }
      else
      {

      $Answer = Read-Host "Confirmar as informações [Y/N]"

      If ($Answer.ToUpper() -eq "Y")
      {

        #rodar o comando aqui
        Write-Host "Criando contato de e-mail: $emailpessoal"

        $nome_exchange = "ContatoExchange "+ $nome
        New-MailContact -Name $nome_exchange -ExternalEmailAddress $emailpessoal -OrganizationalUnit "OU=ContatoExchange,OU=Usuarios,DC=extranet"
        Set-Mailbox -Identity $emailboti -DeliverToMailboxAndForward $true -ForwardingAddress $emailpessoal

        Get-Mailbox $emailboti | fl *forwa*

        Write-Host "Redirecionamento de e-mail criado com sucesso: OK" -ForegroundColor Green

        Pause

      }

      }

    }


    2
    {
    Clear-Host

    Write-Host '[2]  Criar Backup de e-mail no formato .PST'

    $mailbo = Read-Host "Informe o endereço de e-mail xx.com.br"  
    Write-Host
    Write-Host '** Revise as informações **'	
    Write-Host
    write-host "E-mail xx.com.br: " -ForegroundColor Red -NoNewline
    write-host  $mailboti -ForegroundColor Green 
    Write-Host
    Write-Host

    $Answer = Read-Host "Confirmar as informações [Y/N]"

    If ($Answer.ToUpper() -eq "Y")
    {
      Write-Host "Inicio do processo de export"

      New-MailboxExportRequest -Mailbox $mailboti -FilePath "\\share\pst\$mailbo.pst"

      Write-Host "Solicitação de export iniciado com sucesso: OK"

      Get-MailboxExportRequest -Mailbox $mailboti | Format-List Name,FilePath,Mailbox,Status
      $status = (Get-MailboxExportRequest -Mailbox $mailbo | select Status).Status

    if ($status -eq "Completed")
    {

      Write-Host "Arquivo de backup gerado com sucesso: OK" -ForegroundColor Green
      Write-Host "Arquivo de PST disponibilizado no diretório: " -NoNewline
      Write-Host "C:\Temp\Exchange\PST" -ForegroundColor Green
      Write-Host
      pause
      }else{
      Write-Host "Arquivo de backup pendente" -ForegroundColor Yellow
      Write-Host "Arquivo de PST será disponibilizado no diretório: " -NoNewline
      Write-Host "C:\Temp\Exchange\PST" -ForegroundColor Green
      Write-Host
      pause
      }

      }

    }

    3
    {

    Clear-Host

    Write-Host 'Consulta status da solicitação de backup .PST'

    $mailboti = Read-Host "Informe o endereço de e-mail o.com.br"  
    Write-Host
    Get-MailboxExportRequest -Mailbox $mailboti | Format-List Name,FilePath,Mailbox,Status
    $status = (Get-MailboxExportRequest -Mailbox $mailboti | select Status).Status

    if ($status -eq "Completed")
    {

      Write-Host "Arquivo de backup gerado com sucesso: OK" -ForegroundColor Green
      Write-Host "Arquivo de PST disponibilizado no diretório: " -NoNewline
      Write-Host "C:\Temp\Exchange\PST" -ForegroundColor Green
      Write-Host
      pause
     }else{
      Write-Host "Arquivo de backup pendente: Em andamento" -ForegroundColor Yellow
      Write-Host "$status" -ForegroundColor Yellow
      Write-Host
      pause
      }



    }

    4
    {
    Clear-Host


    Write-Host "Goodbye!"
    Write-Host ": )"

    Exit
    }

    }

}
