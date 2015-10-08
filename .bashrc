# My addittions:
# Make ls be colored and format the output some more by default
alias ls="ls --color -CF"
alias grep="grep --color"
# Make typing commands easier if you havent messed up your file/project structure
bind 'set completion-ignore-case on'
#Source the bash completion file so that you can have git completion in the shell:
source ~/etc/git-completion.bash
#Samfundet:
alias dbreset="rake db:drop; rake db:create; rake db:migrate; rake db:seed"

#My color scheme in the PS1:
#(Remember to enable "force_color_prompt=yes", or uncomment the following line for this to work...)
#color_prompt=yes
if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[01;36m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
