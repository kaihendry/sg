# <abbr title="Suckless Graphing">sg</abbr> features

* Designed for a [time series](http://en.wikipedia.org/wiki/Time_series)
* sg-* are  <100 SLOC
* Uses rsync to copy things over, network tolerant, keep a SSH control socket open to make it faster
* [c/](c/) for example cronjob scripts to get interesting data to plot
* [g/](g/) for example graphing scripts to plot PNGs or Web graphics

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

We typically need a destination (`-d`) and a name (`-g`) for the graph. Use
cron to submit datapoints at uniform time intervals.

You don't need to use SSH. No destination implies local `/var/sg`, where data is collected in any case.

You can use `/dev/stdin` instead of supplying `sg-client` a file to read.

## Enable an example grapher by simply linking it in

	$SG_HOST:/var/sg/x220/temp$ ln -s ../../bin/g/all-png.sh

Please create your own [graphing script](g/), and share it? :)

## Running the service on $SG_HOST

	$SG_HOST:/var/sg/bin$ ./sg-service
	Setting up watches.  Beware: since -r was given, this may take a while!
	Watches established.
	1359953560: /var/sg/x220/temp/all-png.sh
	1359953560: /var/sg/x220/temp/flot.sh
	1359953560: /var/sg/x220/temp/google.sh
	1359953560: /var/sg/x220/temp/morris.sh

When `sg-client` writes to the CSV file named after the day of the year is appended
to, this event is detected by `sg-service` and the linked in graph shell
scripts are run. The graphs they produce are in turn updated.

There is also a [systemd sg service file](sg.service).

## Example graphs

### Plotting a thermometer attached to a Raspberry PI

Running as a cronjob every 5 minutes on a [Rpi with a thermometer](http://www.flickr.com/photos/hendry/9649125655/):

	*/5 * * * * ~/temp/a.out | ~/bin/sg/sg-client -r / -d stats@sg.webconverger.com -g temp

See the [graph directory](/g) for the shell scripts that generate these outputs:

* http://stats.webconverger.org/pihsg/temp/all.png
* http://stats.webconverger.org/pihsg/temp/google.html
* http://stats.webconverger.org/pihsg/temp/morris.html
* http://stats.webconverger.org/pihsg/temp/flot.html

This assumes I have a ssh connection open with the destination host `sg`:

### Plotting the temperature of my laptop as well as the kernel version

	*/5 * * * * echo $(cat /sys/class/thermal/thermal_zone0/temp) $(uname -r) | ~/bin/sg/sg-client -d sg -g temp

<img width=640 height=480 src=http://stats.webconverger.org/x220/temp/latest.png>

## Setting up a jailed stats user on $SG_HOST with OpenSSH's ChrootDirectory (tricky & optional)

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

Notice the `-r /` for the chroot path and the user@.

Make sure your ControlPath is setup, `cat ~/.ssh/config`:

	Host *
	ControlPath ~/.ssh/master-%r@%h:%p
	ControlMaster auto

And keep an ssh connection open to make it **fast**.

To setup rsync, follow this [rsync ChrootDirectory guide](http://en.positon.org/post/SFTP-chroot-rsync)
