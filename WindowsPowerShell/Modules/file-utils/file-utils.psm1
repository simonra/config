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

function diffContent($fileA, $fileB)
{
    diff (cat $fileA) (cat $fileB)
}

Export-ModuleMember -Function *
