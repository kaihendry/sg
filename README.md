# Setting up "suckless graphing"

	mkdir /var/sg
	chown $USER:www-data /var/sg
	cd /var/sg
	/var/sg$ git clone git@github.com:kaihendry/sg.git bin
	/srv/www$ ln -s /var/sg stats.example.com
	SG_HOST=$(hostname)

## On a machine you want to monitor temperature and send it to $SG_HOST like so

	sg-client -d $SG_HOST -g temp /sys/class/thermal/thermal_zone0/temp

We typically need a destination and a name for the graph.

## Enabling an example grapher

	mx:/var/sg/35634830e80b2d6371739680000003a4/temp$ ln -s ../../bin/all-png.sh

Create your own graphing script, and share it? :)

TODO:

* Graph for daily `$(ls -t *.csv | tail -n1)`
* Graph for last three days `$(ls -t *.csv | tail -n3)`
* JSON / flot / rickshaw / morris.js
* Emulate http://www.geckoboard.com/

## On $SG_HOST you might want to log the load avg

	cat /proc/loadavg | sg-client -g load

You don't need to use `sg-*` this over SSH. No destination implies local.

## Running the service on $SG_HOST

	mx:/var/sg/bin$ ./sg-service
	Setting up watches.  Beware: since -r was given, this may take a while!
	Watches established.
	Warning: empty y range [67000:67000], adjusting to [66330:67670]
	Triggered: /var/sg/35634830e80b2d6371739680000003a4/temp/all-png.sh

Everytime a CSV file is update, the linked in graph scripts are called and the
graphs they produce are in turn updated.

## Example graph that's updated every 5 minutes

<img width=640 height=480 src=http://stats.webconverger.org/35634830e80b2d6371739680000003a4/temp/all.png>
