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

function retrieve-all-wifi-passwords
{
    $listOfNetworkProfiles = netsh wlan show profiles
    $networkProfileNamesSelection = $listOfNetworkProfiles | Select-String "\:(.+)$"
    $networkProfileNames = foreach($selection in $networkProfileNamesSelection.Matches)
    {
        ($selection.Value -split ":")[-1].Trim()
    }

    $WiFiNameAndPassword = foreach($networkProfileName in $networkProfileNames){
        write-host "Processing wlan profile [$networkProfileName]."
        if( ($networkProfileName -eq $null) -or ($networkProfileName.length -lt 1) )
        {
            continue
        }
        retrieve-wifi-password $networkProfileName
    }

    # If you for some reason Out-GridView doesn't work for you, you can use the line below to print to the console instead.
    # $WiFiNameAndPassword | Format-Table -AutoSize
    $WiFiNameAndPassword | Sort-Object SSID | Out-GridView
}

function retrieve-current-wifi-password
{
    $NetworkProfileName = (Get-NetConnectionProfile).Name
    $WiFiNameAndPassword = retrieve-wifi-password $NetworkProfileName
    $WiFiNameAndPassword | Format-Table -AutoSize
}

function retrieve-wifi-password($NetworkProfileName){
    $networkInfo = netsh wlan show profiles name="$NetworkProfileName" key=clear

    $ssidName = "[null]"
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
        NetworkProfileName = $NetworkProfileName
        SSID = $ssidName
        Password = $password
    }
}

Export-ModuleMember -Function *
