#!/bin/bash
node[0]="/home/david/.wine/drive_c/Program Files (x86)/MT4-DEMO-1/MQL4"
node[1]="/home/david/.wine/drive_c/Program Files (x86)/MT4-DEMO-2/MQL4"
node[2]="/home/david/.wine/drive_c/Program Files (x86)/MT4-REAL-1/MQL4"
node[3]="/home/david/.wine/drive_c/Program Files (x86)/MT4-REAL-2/MQL4"

source="$(pwd -P)"




for destination in "${node[@]}"
do 
	rsync -arv --exclude='deployToMetatraderNodes.sh'  ${source}/  "${destination}"
done	
