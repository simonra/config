config
======

Various general configurations I use

# Notes on how I got the new AMD GPU to work at the end of 2022

First I updated the kernel to 6.2 (not that it really helped):

```sh
sudo pacman -Syu base-devel git --needed
git clone https://gitlab.manjaro.org/packages/core/linux62
cd linux62
updpkgsums
makepkg --syncdeps --install
```

Then I removed the `shiboken6` package (for generating documentation for python), because it blocked the upgrade of the LLVM package beyond what is found in pacman (why would you ever hardcode a dependency version instead of just statically linking it at that point?)

```sh
sudo pacman -Rd --nodeps shiboken6
```

(Note that it wants you to specify that you wish to ignore dependenices twice, hence I supplied both `-d` and `--nodeps`.)

Also LLDB is a dependency for the install, which could be installed from pacman (even though LLDB then ended up being version 14, while the llvm I made was supposed to end up as version 16).

```sh
sudo pacman -S lldb
```

Then I could install the newer llvm version from source using aur

```sh
yay -S llvm-git
```

Note that this replaces a lot of things, including clang should you have that previously installed.

Before I could install mesa from source, I had to remove `lib32-vulkan-mesa-layers`, because it depends on `mesa`, and would not let the build/install procede (because it would replace mesa).

```sh
sudo pacman -R lib32-vulkan-mesa-layers
```

Then I could install mesa from source.
First I had to get the repo

```sh
cd Build
git clone https://aur.archlinux.org/mesa-git.git
cd mesa-git
```

Then I had to update the `PKGBUILD` file to use the LLVM version I built from AUR rather than the default.
To achieve this, I updated the `MESA_WHICH_LLVM` variable to use the `llvm-git` version (changed line 56 to `MESA_WHICH_LLVM=3`).

After that I could update the checksums, build, install, and finally reboot to see if I could get it all working.

```sh
updpkgsums
makepkg --syncdeps --install
```

This final step replaced a lot of the built in mesa pacakges.

At the end, find a list of all installed packages related to llvm and/or mesa:

```sh
pacman -Qs "mesa|llvm"
```

So that you can add them to `/etc/pacman.conf` with their own ignore-lines like
`IgnorePkg    = mesa-git` and `IgnorePkg    = llvm-git`.
This prevents `pacman` or `yay` from picking them up and upgrading them, because they need to be kept somewhat in sync, meaning that you should have to update them explicitly manually by hand once you've started making and installing them by hand like this.

Also note that the pacman regex search for installed packages `pacman -Qs "regex"` works better to get a complete list of packages than running the output from the `pacman` search thorugh `grep`, for instance with `pacman -Qe | grep -E "llvm|mesa"`, because you now have to repeatedly search or make complex sets (for instance `pacman -Qe` lists explicitly installed packages, `pacman -Qm` gives foreign packages, and so on).
Also the `pacman` regex search appears to not only searches the package names, but also descriptions.

# Notes on grep

Useful if you are stuck in a limmited environment (such as git-bash [cygwin] on windows), or have to be very speciffic and not leave stuff up to the goodness of the magical parser:

```bash
grep --include="*.extension" -nri "my query" ./relative/or/absolute/path/to/root/directory/of/search
```

Alternative example:

```bash
grep --include="*.cs" -nri ToDo .
```
