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
    $ListOfNetworkProfiles = netsh wlan show profiles
    $NetworkProfileNamesSelection = $ListOfNetworkProfiles | Select-String "\:(.+)$"
    $NetworkProfileNames = foreach($Selection in $NetworkProfileNamesSelection.Matches)
    {
        ($Selection.Value -split ":")[-1].Trim()
    }

    $WiFiNameAndPassword = foreach($NetworkProfileName in $NetworkProfileNames){
        Write-Host "Processing wlan profile [$NetworkProfileName]."
        if( ($NetworkProfileName -eq $null) -or ($NetworkProfileName.length -lt 1) )
        {
            continue
        }
        retrieve-wifi-password $NetworkProfileName
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

function retrieve-wifi-password([ValidateNotNullOrEmpty()][string] $NetworkProfileName){
    $NetworkInfo = netsh wlan show profiles name="$NetworkProfileName" key=clear

    $SsidName = "[null]"
    $SsidNameLine = $NetworkInfo | Select-String -Pattern 'SSID Name'
    if($SsidNameLine -ne $null)
    {
        $SsidName = ($SsidNameLine -split ":")[-1].Trim() -replace '"'
    }

    $Password = "[null]"
    $PasswordLine = $NetworkInfo | Select-String -Pattern 'Key Content'
    if($PasswordLine -ne $null)
    {
        $Password = ($PasswordLine -split ":")[-1].Trim() -replace '"'
    }

    return [PSCustomObject] @{
        NetworkProfileName = $NetworkProfileName
        SSID = $SsidName
        Password = $Password
    }
}

Export-ModuleMember -Function *
