layout_file_name=customUsInternationalKeyboad.xkb

# Set currently active layout to base you want to modify.
setxkbmap -layout us -variant altgr-intl -option nodeadkeys -option ctrl:nocaps -option numpad:mac
# Explanation of inpunts to setxkbmap:
# - `-option numpad:mac` makes it so that the numpad always enters numbers, even if numpad should accidentaly be toggled.
# - `-option ctrl:nocaps` makes it so that the CapsLock key becomes an actually useful Ctrl key instead.
# - `-option nodeadkeys` re-enables dead keys?
# - `-variant altgr-intl` makes it the international version of the US layout with AltGr dead keys.

# Dump current layout to file.
xkbcomp $DISPLAY $layout_file_name

# Set modifiers for æ, so that AltGr+e yields æ and AltGr+E gives Æ
# Set modifiers for ø, so that AltGr+o yields ø and AltGr+O gives Ø
# Set modifiers for å, so that AltGr+a yields å and AltGr+A gives Å
sed -i -E \
    --expression="s/^(\s*symbols\[Group[0-9]+\]\s*=\s*\[\s*e,\s*E)(,*\s*[a-zA-Z0-9_]*\s*,\s*[a-zA-Z0-9_]*\s*)(\]$)/\1, ae, AE \3/" \
    --expression="s/^(\s*symbols\[Group[0-9]+\]\s*=\s*\[\s*o,\s*O)(,*\s*[a-zA-Z0-9_]*\s*,\s*[a-zA-Z0-9_]*\s*)(\]$)/\1, oslash, Oslash \3/" \
    --expression="s/^(\s*symbols\[Group[0-9]+\]\s*=\s*\[\s*a,\s*A)(,*\s*[a-zA-Z0-9_]*\s*,\s*[a-zA-Z0-9_]*\s*)(\]$)/\1, aring, Aring \3/" \
    $layout_file_name

# Summary of what's actually happening in the sed soup.
# `-i` replaces matches in the file instead of printing file with modified content to console.
# `-E` enables extended regex mode. `-E` is supposed to work corss plattform, as opposed to `-r`.
# `--expression=""` allows you to process multiple expressions.
# `"s/<pattern>/<replacement>/"` tells sed to substitute/replace <pattern> with <replacement>. Note that the delimiteres, here `/` can be relatively freely chosen. So if you have a file path you want to match it could be a good idea to use another character so that you can reduce the escaping of slashes. Example could then be `s:<pattern>:<replacement>`.
# Note also that in this case, the `s` at the beginning is the "command" you supply to sed, in this case telling it to substitute. Beware that sed can do other things than replace, and that the command does not neccessarily have to come first in the command-string.
# `\s` should match whitespaces (including tabs).
# `*` should match zero or more occurrences. Example: `\s*` should match zero or more whitespaces.
# `+` should match one or more occurrences. Example `[0-9]+` should match one or more digits.
# `^` should match beginning of line.
# `$` should match end of line.
# `[a-zA-Z0-9_]` should match any single letter in a-z (upper or lowercase), digit, or underscore.
# `(<expression>)` should create a regex group. If you put it in the first/pattern part, you can reference (or ommit) it in the second/replacement part by `\<1_indexed_group_number>`. An example with two groups where you keep both: `"s/(<expression_1>)(<expression_2>)/\1\2"`. An example with 3 groups where you drop the content of the middle group but keep the rest of the line `"s/(<expression_1>)(<expression_2>)(<expression_3>)/\1\3"`.

# Notable chunks:
# - `^(\s*symbols\[Group[0-9]+\]\s*=\s*\[\s*` should match the beginning of the line, which at the time of writing looks like "        symbols[Group1]= [               ". Note the opening of the group, which closes after match on the base character that we don't wish to replace.
# - `(,*\s*[a-zA-Z0-9_]*\s*,\s*[a-zA-Z0-9_]*\s*)` should match the second group, which is the one that we want to replace. It should look something like ",          contentIDontCareAbout,          content_I_dont_care_about2  ". Note the inclusion of the comma with `*` here at the beginning, to guard against the base layout initially having no default mappings for AltGr for the keys.
# - `\1, aring, Aring \3` says that the replacement is the first group match, followed by ", aring, Aring ", and then having the third group at the end.

# Note on testing: Because sed by default writes a new string to stdout instead of altering the input, you can safely test by ommitting the `-i` parameter, e.g. running `sed -E "<expression>" filepath`. Alternatively `echo "testinput" | sed -E "<expression>"` or `cat testfile_path | sed -E "<expression>"` work equally well.

# For further reading about sed, I found this to be very usefull: https://www.grymoire.com/Unix/Sed.html

# Set newly created layout file with modifications as active.
xkbcomp $layout_file_name $DISPLAY
