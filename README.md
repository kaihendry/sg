# <abbr title="Suckless Graphing">sg</abbr> features

* Designed for a [time series](http://en.wikipedia.org/wiki/Time_series)
* sg-* are  <100 SLOC
* Uses ssh and rsync to copy things over, use control sockets to make it fast
* `c/` for example cronjob scripts to get interesting data to plot
* `g/` for example graphing scripts to plot PNGs or Web graphics

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

You don't need to use SSH. No destination implies local.

You can use `/dev/stdin` instead of supplying `sg-client` a file to read.

## Enabling an example grapher by simply linking them in

Directory `c/` for cron client scripts and `g/` for graphing generation scripts

	$SG_HOST:/var/sg/x220/temp$ ln -s ../../bin/g/all-png.sh

Create your own graphing script, and share it? :)

TODO:

* Figure out how to iframe different graphs in a nicer way than [this](http://stats.webconverger.org/x220/temp/iframe.html)
* Emulate http://www.geckoboard.com/

## Running the service on $SG_HOST

	$SG_HOST:/var/sg/bin$ ./sg-service
	Setting up watches.  Beware: since -r was given, this may take a while!
	Watches established.
	Triggered: /var/sg/x220/m/monitor-png.sh

When a CSV file is appended to, this event is detected by `sg-service` and the
linked in graph shell scripts are run. The graphs they produce are in turn
updated.

## Example graphs

	*/5 * * * * ID=temp sg-client -d stats.webconverger.org -g temp /sys/class/thermal/thermal_zone0/temp

<img width=640 height=480 src=http://stats.webconverger.org/x220/temp/all.png>

	*/10 * * * * ID=m ~/bin/sg/c/monitor.sh -h webconverger.com -i 208.113.198.182 | ~/bin/sg/sg-client -d sg -g webconverger.com

<img src=http://stats.webconverger.org/x220/webconverger.com/monitor.png>

Please create your own [graphing scripts](https://github.com/kaihendry/sg/tree/master/g) and share them!

## Setting up a jailed stats user on $SG_HOST with OpenSSH's ChrootDirectory

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

	hendry@h2 ~$ rsync -e 'ssh -v' stats@sg.webconverger.com

To setup rsync, follow this [rsync ChrootDirectory guide](http://en.positon.org/post/SFTP-chroot-rsync)
