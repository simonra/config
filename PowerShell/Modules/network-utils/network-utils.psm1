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
    $NetworkProfileNames =
        foreach($Selection in $NetworkProfileNamesSelection.Matches)
        {
            ($Selection.Value -split ":")[-1].Trim()
        }

    $WiFiNameAndPassword =
        foreach($NetworkProfileName in $NetworkProfileNames)
        {
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

function retrieve-wifi-password([ValidateNotNullOrEmpty()][string] $NetworkProfileName)
{
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

function setdnsservers
{
    # Exit before user spends time entering new server addresses.
    $currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
    $callerIsAdmin = $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

    if(-not ($callerIsAdmin))
    {
        Write-Host "Setting DNS server addresses can only be done as Administrator. You can, however, still view the current IP addresses of the DNS servers if you want to continue.";

        $title    = 'Proceed'
        $question = 'Do you want to check what the current DNS addresses are?'
        $yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Show DNS addresses."
        $no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Quit."
        $choices = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no)
        [int]$defaultChoiceIndex = 0;
        $decision = $Host.UI.PromptForChoice($title, $question, $choices, $defaultChoiceIndex)
        if ($decision -eq 1) # $decision = index of chosen choice, 0-indexed.
        {
            return;
        }
    }

    $networks = Get-NetAdapter -IncludeHidden `
        | Sort-Object -Property `
            @{Expression = "Status"; Descending = $True}, `
            @{Expression = "ifIndex"; Descending = $false} `
        | Out-GridView -PassThru

    $interfaceIds = $networks | Select-Object -ExpandProperty ifIndex

    # Print current DNS server addresses for enabling recovery if messing up.
    Write-Host "Previous DNS server addresses for the chosen interfaces were as follows:"
    $interfaceIds | ForEach-Object { Get-DnsClientServerAddress -InterfaceIndex $_ }

    if(-not ($callerIsAdmin))
    {
        Write-Host "Setting DNS server addresses can only be done as Administrator. Exiting.";
        return;
    }

    # ToDo: Make better way of showing that this can also be IPv6 address strings. Also take arbitrary number of addresses without overloading the user with specific formatting rules?
    $newPrimaryAddress = Read-Host -Prompt "Enter new primary IPv4 DNS address"
    $newSecondaryAddress = Read-Host -Prompt "Enter new secondary IPv4 DNS address"
    $interfaceIds | ForEach-Object { Set-DnsClientServerAddress -InterfaceIndex $_ -ServerAddresses ($newPrimaryAddress,$newSecondaryAddress) -Validate }
    Write-Host "DNS server addresses for the chosen interfaces are now as follows:"
    $interfaceIds | ForEach-Object { Get-DnsClientServerAddress -InterfaceIndex $_ }
}

Export-ModuleMember -Function *
