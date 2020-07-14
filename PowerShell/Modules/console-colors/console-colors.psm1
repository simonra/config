# Mostly based on what I found here, but tweaked to my liking: https://www.petri.com/change-powershell-console-font-and-background-colors
Function Get-NamedConsoleColors
{
    Param
    (
        [switch]$colorOutput
    )
    # $wsh = New-Object -ComObject wscript.shell
    $data = [enum]::GetNames([consolecolor])
    if ($colorOutput)
    {
        Foreach ($color in $data)
        {
            Write-Host $color -ForegroundColor $Color
        }
        # [void]$wsh.Popup("The current background color is $([console]::BackgroundColor)",16,"Get-ConsoleColor")
    }
    else
    {
        #display values
        $data
    }
} #Get-NamedConsoleColors

Function Show-CurrentConsoleColors
{
    Param
    (
        [switch]$colorOutput
    )
    $host.PrivateData.psobject.properties | 
    Foreach {
        #$text = "$($_.Name) = $($_.Value)"
        Write-host "$($_.name.padright(23)) = " -NoNewline
        if($colorOutput)
        {
            Write-Host $_.Value -ForegroundColor $_.value
        }
        else {
            Write-Host $_.Value
        }
    }
} #Show-CurrentConsoleColors

Function Test-ConsoleColors
{
    [cmdletbinding()]
    Param()

    Clear-Host
    $heading = "White"
    Write-Host "Pipeline Output" -ForegroundColor $heading
    Get-Service | Select -first 5

    Write-Host "`nError" -ForegroundColor $heading
    Write-Error "I made a mistake"

    Write-Host "`nWarning" -ForegroundColor $heading
    Write-Warning "Let this be a warning to you."

    Write-Host "`nVerbose" -ForegroundColor $heading
    $VerbosePreference = "Continue"
    Write-Verbose "I have a lot to say."
    $VerbosePreference = "SilentlyContinue"

    Write-Host "`nDebug" -ForegroundColor $heading
    $DebugPreference = "Continue"
    Write-Debug "`nSomething is bugging me. Figure it out."
    $DebugPreference = "SilentlyContinue"

    Write-Host "`nProgress" -ForegroundColor $heading
    1..10 | foreach -Begin {$i=0} -process {
        $i++
        $p = ($i/10)*100
        Write-Progress -Activity "Progress Test" -Status "Working" -CurrentOperation $_ -PercentComplete $p
        Start-Sleep -Milliseconds 250
    }
} #Test-ConsoleColor

Function Export-ConsoleColors
{
    [cmdletbinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0)]
        [ValidateNotNullorEmpty()]
        [string]$Path = '.\PSColorScheme.csv'
    )
    #verify this is the console and not the ISE
    if ($host.name -eq 'ConsoleHost')
    {
        $host.PrivateData | Add-Member -MemberType NoteProperty -Name ForegroundColor -Value $host.ui.rawui.ForegroundColor -Force
        $host.PrivateData | Add-Member -MemberType NoteProperty -Name BackgroundColor -Value $host.ui.rawui.BackgroundColor -Force
        Write-Verbose "Exporting to $path"
        Write-verbose ($host.PrivateData | out-string)
        $host.PrivateData | Export-CSV -Path $Path -Encoding ASCII -NoTypeInformation
    }
    else
    {
        Write-Warning "This only works in the console host, not the ISE."
    }
} #Export-ConsoleColor

Function Set-ConsoleColors
{
    [cmdletbinding(SupportsShouldProcess)]
    Param
    (
        [Parameter(Position=0)]
        [ValidateScript({Test-Path $_})]
        [string]$Path = '.\PSColorScheme.csv'
    )
    #verify this is the console and not the ISE
    if ($host.name -eq 'ConsoleHost')
    {
        Write-Verbose "Importing color settings from $path"
        $data = Import-CSV -Path $Path
        Write-Verbose ($data | out-string)
        if ($PSCmdlet.ShouldProcess($Path))
        {
            $host.ui.RawUI.ForegroundColor = $data.ForegroundColor
            $host.ui.RawUI.BackgroundColor = $data.BackgroundColor
            $host.PrivateData.ErrorForegroundColor = $data.ErrorForegroundColor
            $host.PrivateData.ErrorBackgroundColor = $data.ErrorBackgroundColor
            $host.PrivateData.WarningForegroundColor = $data.WarningForegroundColor
            $host.PrivateData.WarningBackgroundColor = $data.WarningBackgroundColor
            $host.PrivateData.DebugForegroundColor = $data.DebugForegroundColor
            $host.PrivateData.DebugBackgroundColor = $data.DebugBackgroundColor
            $host.PrivateData.VerboseForegroundColor = $data.VerboseForegroundColor
            $host.PrivateData.VerboseBackgroundColor = $data.VerboseBackgroundColor
            $host.PrivateData.ProgressForegroundColor = $data.ProgressForegroundColor
            $host.PrivateData.ProgressBackgroundColor = $data.ProgressBackgroundColor
            Clear-Host
        } #should process
    }
    else
    {
        Write-Warning "This only works in the console host, not the ISE."
    }
} #Set-ConsoleColor

# Note that the only really recquired function to load a profile is the Set-ConsoleColors function.
# However, I cohose to export all of them because it's nice to be able to see how to generate the file
# from a current configuration, and have the scripts to check the results readily at hand.
Export-ModuleMember -Function *
