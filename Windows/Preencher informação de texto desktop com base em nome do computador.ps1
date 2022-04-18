$computer = $env:COMPUTERNAME

$info = Import-Csv .\email.csv -delimiter ";" 

foreach ($cod in $info){
$emailantigo = $cod.emailold
$codnovo = $cod.cod
$codantigo = $cod.old
$login = "USUÁRIO: " + $cod.emailnovo
$senha = "SENHA: " + $cod.senha
$URL = "Acesse: "
$atencao = "ATENÇÃO!!!!"
$INFO = "O seu e-mail ." 
$obs = "Observação: A sua caixa de e-mail ($emailantigo) não poderá mais ser acessada via Exchange"

if (($computer -like "*$codnovo*") -or ($computer -like "*$codantigo*")){

Clear-Content "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT" 
Add-Content "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT" "`n$atencao"
Add-Content "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT" "$INFO"
Add-Content "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT" "`n$login"
Add-Content "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT" "$senha"
Add-Content "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT" "`n$URL"
Add-Content "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT" "`n$obs"

Start-Process "$env:USERPROFILE\Desktop\EMAIL - LOGIN E SENHA.TXT"

} 

}


