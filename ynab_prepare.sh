#!/bin/bash

FILE=/home/talves/Desktop/extrato.txt

while read line;do
	
	arrIN=(${line//;/ })	
	echo $arrIN[1]
	

done < $FILE

