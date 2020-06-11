echo "Updating load-balancer source code"
cd /root/openshift-extras
git fetch origin/load-balancer
git merge origin/load-balancer -m "boom"
echo "Compiling load-balancer"
rm -rf /tmp/tito
cd /root/openshift-extras/admin/load-balancer
tito build --rpm --test --offline
echo "Installing load-balancer rpm"
service openshift-load-balancer-daemon stop
yum remove rubygem-openshift-origin-load-balancer-daemon -y
rpm -iUvh /tmp/tito/noarch/rubygem-openshift-origin-load-balancer-daemon-*.noarch.rpm
echo "Configuring load-balancer"
sed -i -e 's/^LOAD_BALANCER=f5$/#LOAD_BALANCER=f5/' -e 's/^#LOAD_BALANCER=dummy$/LOAD_BALANCER=dummy/' -e 's/^ACTIVEMQ_HOST=broker.example.com$/ACTIVEMQ_HOST=127.0.0.1/' -e 's/^ACTIVEMQ_PORT=61613$/ACTIVEMQ_PORT=6163/' /etc/openshift/load-balancer.conf

echo "Restarting activemq, rhc-broker, load-balancer"
service activemq restart
service rhc-broker restart
service openshift-load-balancer-daemon start
service openshift-load-balancer-daemon status
