#!/bin/bash

output=/tmp/tcpdump.pcap
wait=3
tcpdump="tcpdump -s0 -i any host 10.13.211.232 -W 1 -C 1024M -w $output"

$tcpdump &
pid=$!

tshark -l -i any -s0 -f 'dst net 10.13.211.232' -R '(nfs.nfsstat4 == 0)' > /tmp/tshark.tmp 2>&1 &
tail -fn 1 /tmp/tshark.tmp |
while read line
do
        ret=`echo $line`
        if [[ -n $ret ]]
        then
                sleep $wait
                pkill tcpdump
                rm /tmp/tshark.tmp
                break 1
        fi
done
