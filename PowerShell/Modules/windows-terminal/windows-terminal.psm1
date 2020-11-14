Function launch-makimono-workspace
{
    $MakimonoStartupScript = encode-command("./Scripts/activate; git fetch; git status;")
    wt `
        new-tab `
            --title "Makimono" `
            --startingDirectory "~/Projects/Makimono" `
            pwsh -NoExit -EncodedCommand $MakimonoStartupScript `; `
        new-tab `
            --title "Publish" `
            --startingDirectory "~/Projects/Makimono/publish" `
            pwsh -NoExit -Command "git status" `; `
        focus-tab --target 0
}

Function encode-command([string] $PlaintextCommand)
{
    # Function for encoding commands/scripts to base 64
    # so that they can be passed to new terminal sessions
    # without tripping up the windows terminal CLI on quotes,
    # semicolons, and other (basic?) building blocks of scripts.

    # Note that ::Unicode assumes UTF 16, if you're working in UTF 8
    # land you have to use ::UTF8.
    $CommandAsBytes = [System.Text.Encoding]::Unicode.GetBytes($PlaintextCommand)
    $EncodedCommand = [Convert]::ToBase64String($CommandAsBytes)
    return $EncodedCommand
}

Export-ModuleMember -Function *
