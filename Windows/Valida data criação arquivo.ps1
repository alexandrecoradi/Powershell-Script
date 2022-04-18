if (Test-Path "caminho"){
    $data = Get-Date -Format 'dd/MM/yyy'
    $FileDate = Get-ChildItem "caminho do arquivo" | Select-Object -ExpandProperty LastWriteTime | Get-Date -f dd/MM/yyy

    if ($FileDate -eq "22/09/2021" -or $FileDate -eq "21/09/2021" -or $FileDate -eq "23/09/2021" -or $FileDate -eq "24/09/2021") {
    exit 32550}else
    {exit 32549}
}else
{
exit 32545
}
