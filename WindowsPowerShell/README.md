PowerShell
======

Stuff to keep in mind when setting up a new install of Windows when you want to work in/with PowerShell.

# Executing scripts and loading the Profile

By default, executing scripts is usually disabled. This restriction is also applied to the profile (as it is technically a script that gets executed that attackers could append their malicious code to). Therefore you should make sure you can even run scripts before bothering with setting up a profile. These restrictions are usually set with the `ExecutionPolicy`. To see the current `ExecutionPolicy` run the
```PowerShell
Get-ExecutionPolicy
```
command. Now, there are a couple of sensible ways to set up the `ExecutionPolicy`, depending on if you want to require for instance all scripts to be singed, what scopes you want to allow running scripts in and so on and so forth. Generally you'll want:
```PowerShell
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned
```
(Has to be run in shell started as admin.)

# Setting up the Profile

The PowerShell Profile, just like `.gitconfig`, gets loaded automagially when placed in the correct directory and given a certain name. (Like most things you can probably make your own names and locations work if you hate yourself and your time sufficiently.) Usually there are a couple of permutations depending on whether you want the script to run for all users or just the current user, what hosts, etc. Now with OneDrive getting tossed into the mix it can get really fun to figure out which profile actually gets loaded.

So, to figure out where the profiles that are actually being loaded are located, you can run
```PowerShell
$profile | Format-List * -Force
```
For your personal setup you'll usually want to go with the location described as `CurrentUserCurrentHost`

# Modules

Modules get automatically loaded when placed in one of the directories listed when running `$env:PSModulePath`. If for some reason this doesn't happen you can add `Import-Module path/to/modules/from/above/*` (I briefly ran with `$PSScriptRoot/Modules/*`).

For module files (`.psm1`) to be automatically loaded they have to be placed in a directory having the same name as the the module it self. For instance if `~/Documents/WindowsPowerShell/Modules` is the modules path a module one wants to automatically be loaded named `mod` should be located here: `~/Documents/WindowsPowerShell/Modules/mod/mod.psm1`.

To expose functions defined in modules so that they can be called from elsewhere, this declaration is needed after the function: `Export-ModuleMember -Function theNameOfTheFunction`. Similarly, if you in the module have defined an alias using `New-Alias -Name shortname -Value theNameOfTheFunction`, you would expose the alias with appending `-Alias shortname`, making the entire command: `Export-ModuleMember -Function theNameOfTheFunction -Alias shortname`. However, usually modules end up small enough that there really aren't any helper functions or aliases you don't what exposed. Then you, instead of exposing every single one individually, can have one export-statement at the bottom and pass it `*`:
```PowerShell
Export-ModuleMember -Function * -Alias *
```

# Misc

`Out-GridView` can be neat from time to time. Not really useful(?), but very visual example: `Get-NetIPAddress | Out-GridView`.

To see what's actually in the path currently, you can run `$env:Path`. This is actually a mix of something like three different registry entries or something like that. If you for some reason are using a binary for a certain project that also likes to install itself system wide with different configs etc it can get really frustrating to ensure that the right path even gets loaded, not to speak of trying to get the right one to be the one that gets run in the end. Therefore the commented out line for overriding the path in the profile. But you usually want to keep some of the preexisting system directories. Therefore it can be a good idea to first run `$env:Path > $PSScriptRoot/path.txt`, before you start populating it with locations you keep track of yourself.

First time setup (can be run before setting  up the ExecutionPolicy, to not mess with permissions maybe don't run as admin?)
```PowerShell
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/simonra/config/master/WindowsPowerShell/Profile.ps1 -UseBasicParsing).content > $profile
```
