#SO
if ((Get-WmiObject Win32_OperatingSystem).OSArchitecture -eq "64 bits")
{
$folder = Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | where-object {$_.DisplayName -like "Software X"} | select InstallSource
}
else
{
$folder = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* | where-object {$_.DisplayName -like "Software X"} | select InstallSource
}


$soft = $folder.InstallSource + "SoftwareX.msi"

if (!(Test-Path $soft)){
exit 32510}
