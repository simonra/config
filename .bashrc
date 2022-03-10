# BEGIN My addittions

## Make ls be colored and format the output some more by default
alias ls="ls --color -CF"
alias grep="grep --color"

## Make typing commands easier if you havent messed up your file/project structure
bind 'set completion-ignore-case on'

## Source bash-completions
if test -f /usr/share/bash-completion/bash_completion
then
	source /usr/share/bash-completion/bash_completion
else
	echo "Bash completions not found."
fi

## My color scheme in the PS1:
PS1='${debian_chroot:+($debian_chroot)}\[\033[01;35m\]\u\[\033[01;36m\]@\[\033[01;32m\]\h\[\033[00m\]:\[\033[01;33m\]\w\[\033[00m\]\$ '
### The base variant without colors saying what to include when showing the path for reference:
# PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '

## Upgrades
function upgrade() {
	if command -v pacman &> /dev/null
	then
		echo "Begin upgrading pacman packages."
		echo "=============================="
		sudo pacman -Syu
		echo "=============================="
		echo "Finish upgrading pacman packages."
	else
		echo "Pacman is not installed, skipping upgrading it."
	fi
	if command -v yay &> /dev/null
	then
		echo "Begin upgrading AUR packages."
		echo "=============================="
		yay -Syu
		echo "=============================="
		echo "Finish upgrading AUR packages."
	else
		echo "yay is not installed, skipping upgrading it."
	fi
	if command -v flatpak &> /dev/null
	then
		echo "Begin upgrading flatpak packages."
		echo "=============================="
		sudo flatpak update
		echo "=============================="
		echo "Finish upgrading flatpak packages."
	else
		echo "flatpak is not installed, skipping upgrading it."
	fi
	if command -v snap &> /dev/null
	then
		echo "Begin upgrading snap packages."
		echo "=============================="
		sudo snap refresh
		echo "=============================="
		echo "Finish upgrading snap packages."
	else
		echo "snap is not installed, skipping upgrading it."
	fi
	if command -v apt-get &> /dev/null
	then
		echo "Begin upgrading apt packages."
		echo "=============================="
		sudo apt-get update
		sudo apt-get upgrade
		echo "=============================="
		echo "Finish upgrading apt packages."
	else
		echo "apt-get is not installed, skipping upgrading it."
	fi
}
export -f upgrade

# END My addittions
