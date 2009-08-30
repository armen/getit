#!/bin/sh

ROOT_UID=0
CWD="`pwd`"

DAEMON="$CWD/getitd"
INITSCRIPT="$CWD/getit"
CONFIG="$CWD/getitd.cfg"
CTL="$CWD/getitctl"

echo $CONFIG

if [ "$UID" -ne "$ROOT_UID" ]
then
  echo "Error: Only root can run this script." >&2
  exit 1;
fi

# Check if wget is exists
if [ "x`which wget`" == "x" ] ; then
    echo "Error: You have to install wget. it's required to run this tool." >&2
    exit 1
fi

# Check if inotify is exists
if [ "x`which inotifywait`" == "x" ] ; then
    echo "Error: You have to install inotify-tools. it's required to run this tool." >&2
    exit 1
fi

case "$1" in
    remove)
        /etc/init.d/getit stop

        rm -f /etc/init.d/getit
        rm -f /etc/default/getit.cfg
        rm -f /usr/sbin/getitd
        rm -f /usr/bin/getitctl

      echo
      update-rc.d getit remove
      echo
    ;;
    *)

        cp $DAEMON /usr/sbin/getitd
        cp $INITSCRIPT /etc/init.d/getit
        cp $CONFIG /etc/default/getitd.cfg
        cp $CTL /usr/bin/getitctl

        echo
        update-rc.d getit defaults 99 01
        echo
    ;;
esac
