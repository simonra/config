# XKB mapping to AltGr-keys

My usecase was that I wanted to map a special set of keys
to certain key combinations using AltGr (right alt) on the
us keyboard layout. The way I did it was that I took a dump
of the international us layout, edited it, and set it as the
keyboard. Step by step:

* Change to the us international layout by running:
    * `setxkbmap -layout us -variant altgr-intl -option nodeadkeys -option ctrl:nocaps`
* Dump the layout to file by running:
    * `xkbcomp $DISPLAY dump_keyboard_file_name.xkb`
* Edit the third and fourth entriesin the `xkb_symbols "pc+us(altgr-intl)+inet(evdev)+ctrl(nocaps)"` section (should be at about line 1219).
    * å,Å is aring,Aring
    * æ,Æ is ae,AE
    * ø,Ø is oslash,Oslash
* Load the new map by running
    * `xkbcomp dump_keyboard_file_name.xkb $DISPLAY`

Share and enjoy =)

The source I used for figuring this out: http://unix.stackexchange.com/a/204687/122600

## Note on using with i3 on Arch

I had some issues with applying the keyboard map above in Manjaro while using i3.
I tried the xmodmap route described below and applying it as suggested in my .xinitrc, to no avail.
The way I got it to work was by calling the `applyMyXkbMap.sh` script from my i3 config.

The way I did it was add a line to `~/.i3/config` that looked approximately like this:

```
exec "/path/to/repo/.xkb/applyMyXkbMap.sh"
```

## If using xmodmap

If you for some reason need to use xmodmap the process is quite similar,
but with some notable differences:

* Change to the us international layout by running:
    * `setxkbmap -layout us -variant altgr-intl -option nodeadkeys -option ctrl:nocaps`
* Dump the layout to file by running:
    * `xmodmap -pke > dump_keyboard_file_name.xmodmap`
* Edit the lines for a, e, and o (keycode 38, 26 and 32)
    * å,Å is aring,Aring
    * æ,Æ is ae,AE
    * ø,Ø is oslash,Oslash
* Load the new map by running
    * `xmodmap dump_keyboard_file_name.xmodmap`

Depending on your setup, it might be that `~/.xinitrc` automatically loads `~/.Xmodmap` as the user modmap.
In that case, you could simply use `~/.Xmodmap` as the filename in the steps above.
