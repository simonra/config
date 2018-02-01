cd ~
source /local/skel/all.bash_profile
source ~/.bashrc
setterm -blength 0

#Chrome likes to make sure only one instance is running.
#This is so that you can run chrom(ium) even if it dind't
#terminate properly last time. (Because it is in in
#.bash_profile it should only be run when the user logs
#on, and thus makes crom(ium) available for the session.)
#(The -f is to make sure it doesn't complain when the file
#doesn't exist.)
rm -f ~/.config/chromium/SingletonLock


#Makes the file .setDisplayAndXauthority. What it does is
#that on logon it creates the file with the parameters from
#the environment loged in on, and makes it executable. Then
#a user can launc it from from an instance a tty, and any
#gui-program they then launch from the tty will launch in
#the wm loged in from (if loged in graphicaly locally on a
#machine).
#In the case we are logging in remotely, or loging in to a
#tty (the typical usecase where we want to use the script),
#we desire the variables to not be overwritten (graphics in
#tty are not much good after all). Therefore we check for
#whether the session we are logging in to has a display. If
#yes, the file is written. If not, the if check fails, and
#the file is not overwritten (which is the desired behaviour).

touch ~/etc/.setDisplayAndXauthority

#Space after if is important!!!
if [[ "x$DISPLAY" != "x" ]];then
{
echo "export XAUTHORITY=\"$XAUTHORITY\""
echo "export DISPLAY=\"$DISPLAY\""
}>~/etc/.setDisplayAndXauthority
else
. ~/etc/.setDisplayAndXauthority
fi

chmod +x ~/etc/.setDisplayAndXauthority

#End of ttyAwesomeScript


[[ -s "$HOME/.profile" ]] && source "$HOME/.profile" # Load the default .profile

[[ -s "$HOME/.rvm/scripts/rvm" ]] && source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
