#!/bin/sh

CONFIG_HOME=/mnt/zookeeper/current/conf
EXHIBITOR_HOME=/mnt/zookeeper/current/bin
umask 007

if test -f $CONFIG_HOME/exhibitor.cfg; then
  . $CONFIG_HOME/exhibitor.cfg
fi

start() {
	 if [ -f "/usr/bin/ec2metadata" ] ; then
            OS_HOSTNAME=$(ec2metadata --local-hostname)
        else
            OS_HOSTNAME=$(hostname -f)
            fi
        cd /mnt/zookeeper/current/bin
        running=`ps -ef |grep java |grep exh |grep -v grep |tr -s " "|cut -d " " -f2|wc -l`

        if [ "$running"  -ge 1 ]
        then
                 echo " process is already running ";
                exit;

        else

        exec java -Dlog4j.configuration=file:///${CONFIG_HOME}/log4j.properties -jar ${EXHIBITOR_HOME}/${EXHIBITOR_LIB} --hostname ${OS_HOSTNAME} ${EXHIBITOR_OPTS} > exhibitor.out 
	##add a i"&"  on the end of the line above if using as a conventional init script. removed as 12-factor wants to run the process in the forground.  
        fi
}

stop() {
       #kill pid
        kill `ps -ef |grep java |grep exhibitor |grep -v grep |tr -s " "|cut -d " " -f2`
        echo "Process Killed"
}


case "$1" in
  start)
	start	
        ;;
  stop)
	stop
	;;
  restart|reload)
	 stop
        start
        ;;
*)
        echo "Usage: {start|stop|reload|restart|status}" || true
        exit 1
esac

exit 0

