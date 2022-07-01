$InstallAppX = Get-AppxPackage -allusers MicrosoftCorporationII.QuickAssist

If ($InstallAppX.status -eq 'OK'){
#remover versão antiga.
Remove-WindowsCapability -Online -Name 'App.Support.QuickAssist~~~~0.0.1.0' -ErrorAction 'SilentlyContinue'
}

If ($InstallAppX.status -ne 'OK'){
Add-AppxProvisionedPackage -online -SkipLicense -PackagePath '.\MicrosoftCorporationII.QuickAssist.AppxBundle'
Remove-WindowsCapability -Online -Name 'App.Support.QuickAssist~~~~0.0.1.0' -ErrorAction 'SilentlyContinue'
}
