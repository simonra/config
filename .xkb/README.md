# XKB mapping to AltGr-keys

My usecase was that I wanted to map a special set of keys
to certain key combinations using AltGr (right alt) on the
us keyboard layout. The way I did it was that I took a dump
of the international us layout, edited it, and set it as the
keyboard. Step by step:

* Change to the us international layout by running:
    * setxkbmap -layout us -variant altgr-intl -option nodeadkeys -option ctrl:nocaps
* Dump the layout to file by running:
    * xkbcomp $DISPLAY dump\_keyboard\_file\_name.xkb
* Edit the third and fourth entriesin the "xkbi\_symbols "pc+us(altgr-intl)+inet(evdev)" section (should be at about line 1095).
    * å,Å is aring,Aring
    * æ,Æ is ae,AE
    * ø,Ø is oslash,Oslash
* Load the new map by running
    * xkbcomp dump\_keyboard\_file\_name.xkb $DISPLAY

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
    * setxkbmap -layout us -variant altgr-intl -option nodeadkeys -option ctrl:nocaps
* Dump the layout to file by running:
    * xmodmap -pke > dump\_keyboard\_file\_name.xmodmap
* Edit the lines for a, e, and o (keycode 38, 26 and 32)
    * å,Å is aring,Aring
    * æ,Æ is ae,AE
    * ø,Ø is oslash,Oslash
* Load the new map by running
    * xmodmap dump\_keyboard\_file\_name.xmodmap
