# Setting up "suckless graphing"

	mkdir /var/sg
	chown $USER:www-data /var/sg
	cd /var/sg
	/var/sg$ git clone git@github.com:kaihendry/sg.git bin
	/srv/www$ ln -s /var/sg stats.example.com
	SG_HOST=$(hostname)

## On a remote machine you want to monitor temperature on

	sg-client -d $SG_HOST -g temp /sys/class/thermal/thermal_zone0/temp

## Enabling an example grapher

	mx:/var/sg/35634830e80b2d6371739680000003a4/temp$ ln -s ../../bin/all-png.sh

Create your own graphing script, and share it? :)

## On $SG_HOST you might want to log the load avg

	cat /proc/loadavg | sg-client -g load

## Run the service on $SG_HOST

	mx:/var/sg/bin$ ./sg-service
	Setting up watches.  Beware: since -r was given, this may take a while!
	Watches established.
	Warning: empty y range [67000:67000], adjusting to [66330:67670]
	Triggered: /var/sg/35634830e80b2d6371739680000003a4/temp/all-png.sh
