
#sudo apt-get update
#sudo apt-get install -y collectd collectd-utils

sudo /etc/init.d/collectd stop

sudo rm /etc/collectd/collectd.conf.d/plugins.conf
sudo cat <<EOF > /etc/collectd/collectd.conf.d/plugins.conf

<Plugin ping>
       Host "google.com"
</Plugin>

EOF

sudo rm /etc/collectd/collectd.conf
sudo cat <<EOF > /etc/collectd/collectd.conf

Hostname `hostname`

FQDNLookup true
Interval 30
ReadThreads 1
LoadPlugin syslog

<Plugin syslog>
        LogLevel info
</Plugin>

#LoadPlugin df
LoadPlugin network
LoadPlugin cpu
LoadPlugin entropy
LoadPlugin interface
LoadPlugin load
LoadPlugin memory
LoadPlugin processes
LoadPlugin rrdtool
LoadPlugin unixsock

#LoadPlugin nginx
#LoadPlugin iptables
LoadPlugin uptime
#LoadPlugin dns
LoadPlugin ping

# select device by typing df
#<Plugin df>
#    Device "/dev/vda"
#    MountPoint "/"
#    FSType "ext3"
#</Plugin>

<Plugin unixsock>
  SocketFile "/var/run/collectd-unixsock"
  SocketGroup "root"
  SocketPerms "0777"
  DeleteSocket true
</Plugin>

<Plugin interface>
    Interface "eth0"
    IgnoreSelected false
</Plugin>

<Plugin "network">
    #servers_do_not_remove
    ReportStats true
</Plugin>

<Plugin rrdtool>
    DataDir "/var/lib/collectd/rrd"
</Plugin>

<Include "/etc/collectd/collectd.conf.d">
    Filter "*.conf"
</Include>

EOF

sudo /etc/init.d/collectd start
