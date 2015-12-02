#!/bin/bash

PID=`ps -ef | grep dbeaver | grep java | awk '{ print $2 }'`

echo "Cheking if Dbeaver is running..."	
if [ ! "$PID" ]; then 
	echo "... Dbeaver is not running."	
else
	echo "...Dbeaver is running. "
	echo "Closing Dbeaver instance [$PID] ..."		
	kill $PID
	echo "...closed"
fi

if [ -d "dbeaver_old" ]; then 
	rm -rf dbeaver_old
fi

if [ -d "dbeaver" ]; then 
	mv dbeaver dbeaver_old
fi

wget "http://dbeaver.jkiss.org/files/dbeaver-ce-latest-linux.gtk.x86_64.tar.gz"

tar -vzxf dbeaver*.tar.gz

rm dbeaver*.tar.gz

