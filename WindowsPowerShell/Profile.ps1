Set-PSReadlineOption -BellStyle None

# Sensible tab completion:
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# More comfortable than typing exit all the time:
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# Because sometimes you want to know the path to a binary:
function which($name)
{
    Get-Command $name | Select-Object -ExpandProperty Definition
}

# Uncomment to override path with user-defined string:
# $env:Path = ((Get-Content $PSScriptRoot/path.txt -Raw) -replace "(?m)#.*`n?", '').Replace("`r`n","")
