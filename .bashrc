# BEGIN My addittions

## Make ls be colored and format the output some more by default
alias ls="ls --color -CF"
alias grep="grep --color"

## Make typing commands easier if you havent messed up your file/project structure
bind 'set completion-ignore-case on'

#My color scheme in the PS1:
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[01;36m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '
### The base variant without colors saying what to include when showing the path for reference:
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

# Take argument 1, zip it recursively,
# pass the output on (the - parameter),
# append it to argument 2 with cat.
zipcat () { zip -r - $1 | cat >> $2 ; }
