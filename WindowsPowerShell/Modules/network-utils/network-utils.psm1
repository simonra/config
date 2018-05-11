function cur($uri)
{
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

Export-ModuleMember -Function *
