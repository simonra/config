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

function touch($file)
{
    if($file -eq $null)
    {
        throw "Touch requires that you submit a file to create or update"
    }
    if(Test-Path $file)
    {
        (Get-ChildItem $file).LastWriteTime = Get-Date
    }
    else
    {
        echo $null > $file
    }
}

# Uncomment to override path with user-defined string:
# $env:Path = ((Get-Content $HOME/Documents/WindowsPowerShell/path.txt -Raw) -replace "(?m)#.*`n?", '').Replace("`r`n","")
