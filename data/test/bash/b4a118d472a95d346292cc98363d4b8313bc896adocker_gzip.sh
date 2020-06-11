#!/bin/bash

# helper command:
# docker images --format "docker save {{.Repository}}:{{.Tag}} | gzip > " > docker_gzip.sh


docker save jupyter/minimal-notebook:latest | gzip > jupyter.tar.gz
docker save mikesplain/openvas:latest | gzip > openvas.tar.gz
docker save weaveworks/weave-npc:1.9.2 | gzip > weave-npc.tar.gz
docker save weaveworks/weave-kube:1.9.2 | gzip > weave-kube.tar.gz
docker save vitess/lite:latest | gzip > vitess.tar.gz
docker save redis:latest | gzip > redis.tar.gz
docker save scylladb/scylla:latest | gzip > scylladb.tar.gz
docker save gcr.io/google_containers/kube-proxy-amd64:v1.5.3 | gzip > kube-proxy-amd64.tar.gz
docker save gcr.io/google_containers/kube-scheduler-amd64:v1.5.3 | gzip > kube-scheduler-amd64.tar.gz
docker save gcr.io/google_containers/kube-controller-manager-amd64:v1.5.3 | gzip > kube-controller-manager-amd64.tar.gz
docker save gcr.io/google_containers/kube-apiserver-amd64:v1.5.3 | gzip > kube-apiserver-amd64.tar.gz
docker save sameersbn/mysql:latest | gzip > mysql.tar.gz
docker save gcr.io/google_containers/etcd-amd64:3.0.14-kubeadm | gzip > etcd-amd64.tar.gz
docker save gcr.io/google_containers/kubedns-amd64:1.9 | gzip > kubedns-amd64.tar.gz
docker save gcr.io/google_containers/dnsmasq-metrics-amd64:1.0 | gzip > dnsmasq-metrics-amd64.tar.gz
docker save thesheff17/apt-cacher-ng:latest | gzip > apt-cacher-ng.tar.gz
docker save gcr.io/google_containers/kube-dnsmasq-amd64:1.4 | gzip > kube-dnsmasq-amd64.tar.gz
docker save gcr.io/google_containers/kube-discovery-amd64:1.0 | gzip > kube-discovery-amd64.tar.gz
docker save gcr.io/google_containers/exechealthz-amd64:1.2 | gzip > exechealthz-amd64.tar.gz
docker save vitess/etcd:v2.0.13-lite | gzip > vitess-etcd.tar.gz
docker save gcr.io/google_containers/pause-amd64:3.0 | gzip > pause-amd64.tar.gz
