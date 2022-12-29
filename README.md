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

(note that it wants you to specify that you wish to ignore dependenices twice, hence I supplied both `-d` and `--nodeps`.)

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

# Notes on grep

Useful if you are stuck in a limmited environment (such as git-bash [cygwin] on windows), or have to be very speciffic and not leave stuff up to the goodness of the magical parser:

```bash
grep --include="*.extension" -nri "my query" ./relative/or/absolute/path/to/root/directory/of/search
```

Alternative example:

```bash
grep --include="*.cs" -nri ToDo .
```
