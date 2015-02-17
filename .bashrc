# My addittions:
# Make ls be colored and format the output some more by default
alias ls="ls --color -CF"
alias grep="grep --color"
# Make typing commands easier if you havent messed up your file/project structure
bind 'set completion-ignore-case on'
#Samfundet:
alias dbreset="rake db:drop; rake db:create; rake db:migrate; rake db:seed"
