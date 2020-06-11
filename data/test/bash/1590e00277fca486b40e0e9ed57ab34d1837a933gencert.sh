#!/bin/bash

if [[ -z "$1" ]]; then
    HOWMANYSERVERS=2
elif [ "$1" -le 10 ]; then
    HOWMANYSERVERS=$1
else
    echo "Please change number of servers. Servers range 1..10"
    exit
fi

# Create CA
echo "Generating CA..."
openssl genrsa -out sample.ca.key.pem 2048
openssl req -new -x509 -days 3650 -extensions v3_ca -subj "/C=EU/ST=Someland/L=Some City/O=Sample/CN=Sample Dev CA" -key sample.ca.key.pem -out ca_cert.pem
echo ""

# Create load balancer certs
echo "Generating Load Balancer certs..."
openssl genrsa -out sample.load_balancer.key.pem 2048
openssl rsa -in sample.load_balancer.key.pem -pubout -out sample.load_balancer.key.pub.pem
openssl req -new -key sample.load_balancer.key.pem -out sample.load_balancer.req.csr -subj "/C=EU/ST=Someland/L=Some City/O=Sample/CN=Sample Dev Load Balancer"
openssl x509 -req -days 365 -in sample.load_balancer.req.csr -CA ca_cert.pem -CAkey sample.ca.key.pem -CAcreateserial -out sample.load_balancer.cert.pem
rm -f sample.load_balancer.req.csr
echo ""

# Create web admin certs
echo "Generating Web Admin certs..."
openssl genrsa -out sample.web_admin.key.pem 2048
openssl rsa -in sample.web_admin.key.pem -pubout -out sample.web_admin.key.pub.pem
openssl req -new -key sample.web_admin.key.pem -out sample.web_admin.req.csr -subj "/C=EU/ST=Someland/L=Some City/O=Sample/CN=Sample Dev Web Admin"
openssl x509 -req -days 365 -in sample.web_admin.req.csr -CA ca_cert.pem -CAkey sample.ca.key.pem -CAcreateserial -out sample.web_admin.cert.pem
rm -f sample.web_admin.req.csr
echo ""

# Create servers certs
i=1
while [ $i -le $HOWMANYSERVERS ]
do
echo "Generating Server $i certs..."
openssl genrsa -out sample.server$i.key.pem 2048
openssl rsa -in sample.server$i.key.pem -pubout -out sample.server$i.key.pub.pem
openssl req -new -key sample.server$i.key.pem -out sample.server$i.req.csr -subj "/C=EU/ST=Someland/L=Some City/O=Sample/CN=Sample Dev Server $i"
openssl x509 -req -days 365 -in sample.server$i.req.csr -CA ca_cert.pem -CAkey sample.ca.key.pem -CAcreateserial -out sample.server$i.cert.pem
rm -f sample.server$i.req.csr
echo ""
i=$[i+1]
done

rm -f ca_cert.srl

echo "Done."
