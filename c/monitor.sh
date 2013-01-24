#!/bin/bash
# */10 * * * * ID=m ~/bin/sg/c/monitor.sh -h webconverger.com -i 208.113.198.182 | ~/bin/sg/sg-client -d sg -g webconverger.com

die() {
echo $@ >&2
exit 1
}

while getopts "h:i:" o
do
	case "$o" in
	(h) host="$OPTARG";; # host
	(i) ip="$OPTARG";; # ip
	esac
done
shift $((OPTIND - 1))

test "$host" || die host not defined
test "$ip" || die ip not defined

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
