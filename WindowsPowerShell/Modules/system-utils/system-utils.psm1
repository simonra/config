# Because sometimes you want to know the path to a binary:
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

function Restart-Explorer
{
    Stop-Process -ProcessName explorer
}

function sudo
{
    # This should maybe try to take the arguments, and then pass them to be run in the new elevated shell that is spawned.
    # Or maybe start the new elevated session in the same directory which it is called from.
    # For now it is a weak reproduction of `sudo -i`/`sudo su`, but still (slightly) better than the alternatives.
    Start-Process powershell -Verb RunAs
}

New-Alias reboot Restart-Computer
New-Alias shutdown Stop-Computer
function logoff
{
    Shutdown.exe -L
}

Export-ModuleMember -Function *
