#!/bin/bash
export REPO=X

wget $REPO/up/vars/kuber_env.sh
wget $REPO/kubernetes/setup.sh
wget $REPO/kubernetes/certgen.sh

mkdir -p manifests
cd manifests
wget $REPO/kubernetes/manifests/apiserver.yaml
wget $REPO/kubernetes/manifests/controller.yaml
wget $REPO/kubernetes/manifests/scheduler.yaml
cd ..
sudo chown core:core manifests -R

mkdir -p bin
cd bin
wget $REPO/kubernetes/bin/kubectl
wget $REPO/kubernetes/bin/kubelet
wget $REPO/kubernetes/bin/kube-proxy
cd ..
sudo chown core:core bin -R


mkdir -p bin


