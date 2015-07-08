#XKB mapping to AltGr-keys

My usecase was that I wanted to map a special set of keys
to certain key combinations using AltGr (right alt) on the
us keyboard layout. The way I did it was that I took a dump
of the international us layout, edited it, and set it as the
keyboard. Step by step:

* Change to the us international layout by running:
    * setxkbmap -layout us -variant altgr-intl -option nodeadkeys
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
