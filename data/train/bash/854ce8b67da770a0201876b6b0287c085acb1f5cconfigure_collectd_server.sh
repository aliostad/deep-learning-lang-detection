
sudo /etc/init.d/collectd stop

sudo rm /etc/carbon/storage-schemas.conf
sudo cat <<EOF > /etc/carbon/storage-schemas.conf

[collectd]
pattern = ^collectd.*
retention = 10s:1d,1m:7d,10m:1y

EOF

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
LoadPlugin write_graphite

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
    # Can also be "*" "25826" to listen on 0.0.0.0
    # Listen "$EXTERNAL_IPV4$" "25826"
    # Listen "$EXTERNAL_IPV6$" "25826"
    Listen "*" "25826"
    ReportStats true
</Plugin>

<Plugin rrdtool>
    DataDir "/var/lib/collectd/rrd"
    CacheTimeout 120
    CacheFlush 900
    RRARows 210240
    RRATimespan 2102400, 12614400, 63072000
</Plugin>

<Plugin write_graphite>
    <Node "graphing">
        Host "localhost"
        Port "2003"
        Protocol "tcp"
        LogSendErrors true
        Prefix "collectd"
        StoreRates true
        AlwaysAppendDS false
        EscapeCharactire "_"
    </Node>
</Plugin>

<Include "/etc/collectd/collectd.conf.d">
    Filter "*.conf"
</Include>

EOF

sudo /etc/init.d/collectd start
