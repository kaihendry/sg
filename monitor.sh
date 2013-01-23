#!/bin/bash
# */10 * * * * ID=m ~/bin/sg/monitor.sh | ~/bin/sg/sg-client -d sg -g m

host=webconverger.com
ip=208.113.198.182

# Non-zero is bad

ping -c 1 $host &>/dev/null
l="${l}$? "
curl -I "http://$host" --connect-timeout 10 &>/dev/null
l="${l}$? "
dig $host | grep -v '^;' | grep A | grep -q $ip
l="${l}$? "
nc -z -w 5 $host 25 &>/dev/null
l="${l}$? "

echo $l
