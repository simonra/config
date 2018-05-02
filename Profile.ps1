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

function mkdirWithTest($path)
{
    if (!(Test-Path $path) )
    {
        New-Item -ItemType Directory -Force -Path $path
    }
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
        $pathToFile = Split-Path -Path $file;
        if(![string]::IsNullOrEmpty($pathToFile))
        {
            mkdirWithTest($pathToFile);
        }
        echo $null > $file;
    }
}

function cur($uri)
{
    (Invoke-WebRequest -Uri $uri -UseBasicParsing).Content
}

function diffContent($fileA, $fileB)
{
    diff (cat $fileA) (cat $fileB)
}

# If you suspect the current profile is being stored in a weird place
# you can run this command to see the paths for the current profiles:
# $PROFILE | Format-List * -Force

# Uncomment to override path with user-defined string:
# $env:Path = ((Get-Content $PSScriptRoot/path.txt -Raw) -replace "(?m)#.*`n?", '').Replace("`r`n","")

#region size finding functions
function GetDirectorySize([ValidateNotNullOrEmpty()][string]$path)
{
    if(!(Test-Path $path)){
        throw "Directory not found at"
    }
    if(!(Test-Path $path -PathType Container)){
        throw "$path is not a directory"
    }

    $sizeInBytes = (Get-ChildItem -Recurse -Force $path | Measure-Object -Property Length -Sum).Sum
    return FormatSize($sizeInBytes)
}

function GetSubDirectoriesSize([ValidateNotNullOrEmpty()][string]$path)
{
    if(!(Test-Path $path)){
        throw "Directory not found"
    }
    if(!(Test-Path $path -PathType Container)){
        throw "$path is not a directory"
    }
    $subDirectories = Get-ChildItem $path | Where-Object {$_.PSIsContainer -eq $true} | Sort-Object
    foreach ($subDir in $subDirectories)
    {
        $subDirSize = GetDirectorySize((Join-Path $path $subDir))
        $subDirName = $subDir.FullName
        "$subDirName -- $subDirSize"
    }
}

function GetFileSize([ValidateNotNullOrEmpty()][string]$path)
{
    if(!(Test-Path $path)){
        throw "File not found"
    }
    if(!(Test-Path $path -PathType Leaf)){
        throw "$path is not a file. You might want to use GetDirectorySize instead."
    }

    $sizeInBytes = (Get-Item -Force $path).Length
    return FormatSize($sizeInBytes)
}

function GetSize([ValidateNotNullOrEmpty()][string]$Path)
{
    if(!(Test-Path $path)){
        throw "No item found at $path"
    }
    if(Test-Path $path -PathType Container){
        GetDirectorySize($path)
    }
    else {
        GetFileSize($Path)
    }
}

function FormatSize([double]$sizeInBytes)
{
    if($sizeInBytes -lt 1024){
        return "$sizeInBytes Bytes"
    }
    elseif(($sizeInBytes / 1kb) -lt 1024){
        return "{0:N2}" -f ($sizeInBytes / 1kb) + " KiB"
    }
    elseif(($sizeInBytes / 1mb) -lt 1024){
        return "{0:N2}" -f ($sizeInBytes / 1mb) + " MiB"
    }
    elseif(($sizeInBytes / 1gb) -lt 1024){
        return "{0:N2}" -f ($sizeInBytes / 1gb) + " GiB"
    }
    elseif(($sizeInBytes / 1tb) -lt 1024){
        return "{0:N2}" -f ($sizeInBytes / 1tb) + " TiB"
    }
    elseif(($sizeInBytes / 1pb) -lt 1024){
        return "{0:N2}" -f ($sizeInBytes / 1pb) + " PiB"
    }
    # Don't check for sizes in the range of exabytes or greater as powershell doesn't seem to support it natively yet
    return "$sizeInBytes Bytes"
}
#endregion
