# Because sometimes you want to know the path to a binary:
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function Restart-Explorer
{
    Stop-Process -ProcessName explorer
}

Export-ModuleMember -Function *
