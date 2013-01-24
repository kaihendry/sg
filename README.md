# Setting up "suckless graphing"

	mkdir /var/sg
	chown -R $USER:www-data /var/sg
	cd /var/sg
	/var/sg$ git clone git@github.com:kaihendry/sg.git bin
	SG_HOST=$(hostname)

Assuming you have [Virtual hosting](http://dabase.com/e/04025/) setup from `/srv/www`

	/srv/www$ ln -s /var/sg stats.example.com

## Machine you want to monitor temperature and send it to $SG_HOST

	sg-client -d $SG_HOST -g temp /sys/class/thermal/thermal_zone0/temp

We typically need a destination (`-d`) and a name (`-g`) for the graph.

## Enabling an example grapher by simply linking them in

Directory `c/` for cron client scripts and `g/` for graphing generation scripts

	$SG_HOST:/var/sg/x220/temp$ ln -s ../../bin/g/all-png.sh

Create your own graphing script, and share it? :)

TODO:

* Graph for daily `$(ls -t *.csv | head -n1)`
* Graph for last three days `$(ls -t *.csv | head -n3)`
* JSON &rarr; [flot](http://www.flotcharts.org/) / [rickshaw](http://code.shutterstock.com/rickshaw/) / [morris.js](http://www.oesmith.co.uk/morris.js/) / [d3js](http://d3js.org/)
* Emulate http://www.geckoboard.com/

## On $SG_HOST you might want to log the load average

	cat /proc/loadavg | sg-client -g load

You don't need to use SSH. No destination implies local.

You can use `/dev/stdin` instead of supplying `sg-client` a file to read.

## Running the service on $SG_HOST

	$SG_HOST:/var/sg/bin$ ./sg-service
	Setting up watches.  Beware: since -r was given, this may take a while!
	Watches established.
	Triggered: /var/sg/x220/m/monitor-png.sh

When a CSV file is appended to, this event is detected by `sg-service` and the
linked in graph shell scripts are run. The graphs or JSON data they produce are
in turn updated.

## Example graph that is updated every 5 minutes

	*/5 * * * * ID=temp sg-client -d stats.webconverger.org -g temp /sys/class/thermal/thermal_zone0/temp

<img width=640 height=480 src=http://stats.webconverger.org/x220/temp/all.png>

	*/10 * * * * ID=m ~/bin/sg/c/monitor.sh -h webconverger.com -i 208.113.198.182 | ~/bin/sg/sg-client -d sg -g webconverger.com

<img src=http://stats.webconverger.org/x220/webconverger.com/monitor.png>

## Setting up a jailed stats user on $SG_HOST with OpenSSH's ChrootDirectory

TODO: Somehow limit to just appending and creating directories

$SG_HOST's `/etc/passwd` entry:

	stats:x:1006:1006::/home/stats:/bin/sh

Append keys to `/home/stats/.ssh/authorized_keys`

in `/etc/ssh/sshd_config`:

	Match user stats
	  ChrootDirectory /var/sg

You will see `fatal: bad ownership or modes for chroot directory "/var/sg"`
unless it's owned by root. You can alter subdirectory permissions to whatever you want.

Next you will see failing with: `/bin/sh: No such file or directory`

	cp /bin/busybox /var/sg/bin/sh

Test with `ssh stats@SG_HOST`

Crontab root needs to be tweaked like so:

	*/10 * * * * /var/sg/bin/c/temp.sh | /var/sg/bin/sg-client -r / -g temp -d stats@sg.webconverger.com

Make sure your ControlPath is setup, `cat ~/.ssh/config`:

	Host *
	ControlPath ~/.ssh/master-%r@%h:%p
	ControlMaster auto

And keep an ssh open to make it **fast**.

	hendry@h2 ~$ ssh -v stats@sg.webconverger.com whoami
	OpenSSH_6.0p1 Debian-2~artax1, OpenSSL 0.9.8o 01 Jun 2010
	debug1: Reading configuration data /home/hendry/.ssh/config
	debug1: /home/hendry/.ssh/config line 1: Applying options for *
	debug1: Reading configuration data /etc/ssh/ssh_config
	debug1: /etc/ssh/ssh_config line 19: Applying options for *
	debug1: auto-mux: Trying existing master
	debug1: mux_client_request_session: master session id: 3
	whoami: unknown uid 1006
