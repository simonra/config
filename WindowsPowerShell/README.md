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

# Misc

First time setup (can be run before seting up the ExecutionPolicy, to not mess with permissions maybe don't run as admin?)
```PowerShell
(Invoke-WebRequest -Uri https://raw.githubusercontent.com/simonra/config/master/WindowsPowerShell/Profile.ps1 -UseBasicParsing).content > $profile
```
