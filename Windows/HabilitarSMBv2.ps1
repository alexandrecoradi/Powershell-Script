
#return smb access
$caminho = "HKLM:\SYSTEM\ControlSet001\Services\LanmanServer\Parameters\"

Set-ItemProperty -Path $caminho -Name 'Smb2' -Value 1
