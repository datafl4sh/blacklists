#!/bin/sh

if [ $# != 1 ]; then
       echo "Usage: ${0} DIR"
       echo "  where \"DIR\" is the path from bind working dir to here"
       exit 1
fi

UPDATE=$(git pull)

if [ -e blacklist.zone ] && [ "${UPDATE}" == "Already up-to-date." ]; then
       exit 0
fi

echo "" > blacklist.zone
for site in $(cat blacklist.txt|tr [:upper:] [:lower:] |sort|uniq); do
       echo "zone \"$site\"            { type master; file \"${1}/noroute.db\"; };" >> blacklist.zone
done

#try to restart named
if [ -n "$(pidof /sbin/init)" ]; then
       if [ -e /etc/init.d/named ]; then
               /etc/init.d/named restart
       elif [ -e /usr/local/etc/rc.d/named ]; then
               /usr/local/etc/rc.d/named restart
       fi
elif [ -n "$(pidof systemd)" ]; then
       systemctl restart named
fi

