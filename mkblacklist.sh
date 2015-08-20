#!/bin/sh

BLACKLIST='blacklist.txt'
BLACKLIST_CONF='/etc/unbound/blacklist.conf'

BLOCKED=`cat $BLACKLIST | sort | uniq`

cat /dev/null > $BLACKLIST_CONF

for site in $BLOCKED;
do
    echo "    local-zone: \"$site\" redirect"  >> $BLACKLIST_CONF
    echo "    local-data: \"$site A 127.0.0.1\""  >> $BLACKLIST_CONF
done

killall -HUP unbound
