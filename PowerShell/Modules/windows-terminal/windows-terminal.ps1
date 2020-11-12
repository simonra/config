Function launch-makimono-workspace
{
    # Notes:
    # Currently have to use "&&" instead of ';' to chain commands,
    # because the ';'s get swallowed by wt which tries to make new tabs of "git fetch" and "git status",
    # which fails miserably.
    wt `
        new-tab `
            --title "Makimono" `
            --startingDirectory ~/Projects/Makimono `
            pwsh -NoExit -Command "./Scripts/activate && git fetch && git status" `; `
        new-tab `
            --title "Publish" `
            --startingDirectory ~/Projects/Makimono/publish `
            pwsh -NoExit -Command "git status" `; `
        focus-tab --target 0
}

Export-ModuleMember -Function *
