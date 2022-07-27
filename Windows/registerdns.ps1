$nics=Get-WmiObject "Win32_NetworkAdapterConfiguration where IPEnabled='TRUE'"
        foreach($nic in $nics)
        {
        $nic.SetDynamicDNSRegistration($false)
        } 
        ipconfig /registerdns
        Start-Sleep -s 10
        $nics=Get-WmiObject "Win32_NetworkAdapterConfiguration where IPEnabled='TRUE'"
        foreach($nic in $nics)
        {
        $nic.SetDynamicDNSRegistration($true)
        }
