Set-PSReadlineOption -BellStyle None

# Sensible tab completion:
Set-PSReadlineKeyHandler -Key Tab -Function Complete

# More comfortable than typing exit all the time:
Set-PSReadlineKeyHandler -Key Ctrl+d -Function DeleteCharOrExit

# Uncomment to set color scheme from console-color module:
# Set-ConsoleColors $PSScriptRoot/Modules/console-colors/themes/dark.csv

# Uncomment to override path with user-defined string:
# $env:Path = ((Get-Content $PSScriptRoot/path.txt -Raw) -replace "(?m)#.*`n?", '').Replace("`r`n","")
