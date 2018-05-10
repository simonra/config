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

Export-ModuleMember -Function *
# General pattern is:
#Export-ModuleMember -Function FunctionName -Alias AliasDefinedAbove
# To export all with respective aliases:
# Export-ModuleMember -Function * -Alias *
