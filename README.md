Suckless Graphs does two things:

`sgc` helps collect simple time series data locally in a CSV format anchored by epoch time, e.g.

	$(date +%s) $(cat /sys/class/thermal/thermal_zone0/temp)

`sgc`'s `-d` switch allows you to define a internet addressable **server** to push the data to.

Optionally `sgd` offers a service that notices changes and calls symlinked
*.sh scripts to plot that data. This is typically run on the **server** but
can be run on the client too.

# <abbr title="Suckless Graphing">sg</abbr> features

* Simple
* Designed for a [time series](http://en.wikipedia.org/wiki/Time_series)
* sg-* are  <100 SLOC
* Uses rsync to copy things over, network tolerant, keep a SSH control socket open to make it faster
* [examples/](examples/) contains a systemd timer example to get interesting data to plot
* [plotters/](plotters/) are graphing scripts to plot PNGs or Web pages

# Setting up "suckless graphing"

	make

Notice the assumed ` /usr/local/share/` directory

## How to collect data

Assuming an example temperature script is in place:

	$ ls /etc/systemd/system/sg*
	/etc/systemd/system/sgc-temp@.service  /etc/systemd/system/sgc-temp@.timer

	systemctl list-timers | grep sgc
	sudo systemctl start sgc-temp@$USER.timer
	sudo systemctl enable sgc-temp@$USER.timer

Learn about systemd timers to adjust the frequency.

Data lands up in ~/.cache/sg/$HOSTNAME/temp

## How to setup plotters for your data

	sudo systemctl start sgd@$USER.service
	sudo systemctl enable sgd@$USER.service

In you collect data called "temp" from a machine named "foo" and you want a PNG
version of the data generated on any update:

	~/.cache/sg/foo/temp$ ln -s /usr/local/share/sg/plotters/gnuplot.sh

With that script symlinked into the data directory, sgd will execute *.sh when it notices new data.

So in this example `~/.cache/sg/foo/temp/gnuplot.png` will be generated whenever a CSV has been appended to.
