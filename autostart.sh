#!/usr/bin/env bash

# Ensure dbus is either already running, or safely start it
if [[ -z "${DBUS_SESSION_BUS_ADDRESS}" ]];
then
    eval $(dbus-launch --sh-syntax --exit-with-session)
fi

# Make the keyring daemon ready to communicate with nm-applet
export $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh,gpg)

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

#run "/usr/bin/redshift"
#run "/opt/dropbox/dropbox"
#run "insync start"
#run "/usr/bin/megasync"
run "xscreensaver --no-splash"
run "compton"
run "urxvtd -q -f -o"
run "mpd"
run "nm-applet"
bash "/home/msjche/Scripts/Theming/1080.sh"
