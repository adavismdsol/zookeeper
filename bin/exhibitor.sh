#!/bin/sh

CONFIG_HOME=/mnt/zookeeper/current/conf
EXHIBITOR_HOME=/mnt/zookeeper/current/bin
umask 007

if test -f $CONFIG_HOME/exhibitor.cfg; then
  . $CONFIG_HOME/exhibitor.cfg
fi

case "$1" in
  start)
        if [ -f "/usr/bin/ec2metadata" ] ; then
            OS_HOSTNAME=$(ec2metadata --local-hostname)
        else
            OS_HOSTNAME=$(hostname -f)
            fi
        cd /mnt/zookeeper/current/bin
        exec java -Dlog4j.configuration=file:///${CONFIG_HOME}/log4j.properties -jar ${EXHIBITOR_HOME}/${EXHIBITOR_LIB} --hostname ${OS_HOSTNAME} ${EXHIBITOR_OPTS} > exhibitor.out &
        ;;
  stop)
	#kill pid 
  ;;
*)
        echo "Usage: /etc/init.d/ssh {start|stop|reload|force-reload|restart|try-restart|status}" || true
        exit 1
esac

exit 0

