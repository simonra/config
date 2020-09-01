function cur($uri)
{
    [Net.ServicePointManager]::SecurityProtocol = "Tls12, Tls11, Tls, Ssl3"
    (Invoke-WebRequest -Uri $uri -UseBasicParsing).Content
}

function flushdns
{
    echo "clearing the dns cache"
    # Should be equivalent to ipconfig /flushdns
    Clear-DnsClientCache
}

function refresh-dhcp
{
    echo "releasing current dhcp leases"
    ipconfig /release
    echo "dhcp leases released"
    Start-Sleep -s 2
    echo "renewing dhcp leases"
    ipconfig /renew
    echo "dhcp leases renewed"
}

function reset-networking
{
    refresh-dhcp
    flushdns
}

function print-network-passwords
{
    $networkNamesSelection = netsh wlan show profiles | Select-String "\:(.+)$"
    $networkNames = foreach($selection in $networkNamesSelection.Matches)
    {
        ($selection.Value -split ":")[-1].Trim()
    }

    $nameAndPassword = foreach($name in $networkNames){
        write-host "Processing wlan profile [$name]."
        if( ($name -eq $null) -or ($name.length -lt 1) ){
            continue
        }
        print-password-for-network $name
    }

    # If you for some reason Out-GridView doesn't work for you, you can use the line below to print to the console instead.
    # $nameAndPassword | Format-Table -AutoSize
    $nameAndPassword | Out-GridView
}

function print-password-for-network($networkName){
    $networkInfo = netsh wlan show profiles name="$networkName" key=clear

    $ssidName = "[null] (SSID for [$networkName] not found)"
    $ssidNameLine = $networkInfo | Select-String -Pattern 'SSID Name'
    if($ssidNameLine -ne $null)
    {
        $ssidName = ($ssidNameLine -split ":")[-1].Trim() -replace '"'
    }

    $password = "[null]"
    $passwordLine = $networkInfo | Select-String -Pattern 'Key Content'
    if($passwordLine -ne $null)
    {
        $password = ($passwordLine -split ":")[-1].Trim() -replace '"'
    }

    return [PSCustomObject] @{
        WiFiName = $ssidName
        Password = $password
    }
}

Export-ModuleMember -Function *
