#!/bin/sh

ROOT_UID=0
CWD=`pwd`

CORE="$CWD/getit-core"
SH_SETUP="$CWD/sh-setup"
DAEMON="$CWD/getitd"
INITSCRIPT="$CWD/getit"
CONFIG="$CWD/getitd.cfg"
CTL="$CWD/getitctl"

CORE_DEST="/usr/bin/getit-core"
SH_SETUP_DEST="/usr/bin/sh-setup"
DAEMON_DEST="/usr/sbin/getitd"
INITSCRIPT_DEST="/etc/init.d/getit"
CONFIG_DEST="/etc/default/getitd.cfg"
CTL_DEST="/usr/bin/getitctl"

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
        /etc/init.d/getit stop 2>/dev/null

        rm -f $CORE_DEST
        rm -f $SH_SETUP_DEST
        rm -f $DAEMON_DEST
        rm -f $INITSCRIPT_DEST
        rm -f $CONFIG_DEST
        rm -f $CTL_DEST

        echo
        update-rc.d getit remove
        echo
    ;;
    *)

        cp $CORE $CORE_DEST
        cp $SH_SETUP $SH_SETUP_DEST
        cp $DAEMON $DAEMON_DEST
        cp $INITSCRIPT $INITSCRIPT_DEST
        cp $CONFIG $CONFIG_DEST
        cp $CTL $CTL_DEST

        echo
        update-rc.d getit defaults 99 01
        echo
    ;;
esac
