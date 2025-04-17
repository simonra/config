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

## Note on symbols

To find a more complete list of symbols, you can look in `/usr/include/X11/keysymdef.h`,
or if you want to use unicode symbols not defined there, refer them directly like `U2031`.

## Note on high F-Keys

If the keyboard emits high f-keys, like F13, F14, F15, ... F24, these don't appear to work as they should out of the box.
When running `sudo showkey --keycodes`, I got this sequence for
 F13, F14, F15, F16, and F17:

keycode 183 press
keycode 183 release
keycode 184 press
keycode 184 release
keycode 185 press
keycode 185 release
keycode 186 press
keycode 186 release
keycode 187 press
keycode 187 release

These, however, don't match the numbers in the xkb map file section `xkb_keymap.xkb_keycodes "evdev+aliases(qwerty)"`.
When binding to the xkb names (?) mapped to the keycodes, assigning F13 to 183 didn't work.
But when I assigned F13 to 191, it did work!

This site was also useful for verifying what keycodes were registered:
https://www.toptal.com/developers/keycode

If it ever disappears, it is basically an access of the onkeyup/down

```js
document.onkeyup = function(evt){
  evt = evt || window.event;
  console.table([
    ["Key",       evt.key       ],
    ["Code",      evt.code      ],
    ["KeyCode",   evt.keyCode   ],
    ["Which",     evt.which     ],
    ["Location",  evt.location  ],
    ["AltKey",    evt.altKey    ],
    ["CtrlKey",   evt.ctrlKey   ],
    ["MetaKey",   evt.metaKey   ],
    ["ShiftKey",  evt.shiftKey  ],
    ["Repeat",    evt.repeat    ],
  ]);
}
```

and extraction htmlification of these properties:

* `evt.key`: For instance `a`
* `evt.code`: For instance `KeyA`
* `evt.keyCode`: Deprecated, for instance `65`
* `evt.which`: Deprecated, for instance `65`
* `evt.location`: For instance `0`
* `evt.altKey`: For instance `false`
* `evt.ctrlKey`: For instance `false`
* `evt.metaKey`: For instance `false`
* `evt.shiftKey`: For instance `false`
* `evt.repeat`: For instance `false`

### Notes on Wayland

As wayland does not yet (2025-04) support custom user xkb keymaps
(maybe they'll someday add new exciting functionality to play with instead of just removing features?),
it appears you can unbrick the F13 - F24 keys by editing the file
`/usr/share/X11/xkb/symbols/inet`
Look in the section `xkb_symbols "evdev"{}` at about line 196, or just search for `FK13`.

Not yet tested, but if I'll ever have a reason to to migrate this can hopefully speed up the transition.

https://programming.dev/post/10968913
https://old.reddit.com/r/wayland/comments/x3tff6/adding_f13_f24_keys/kf36xa0/

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
