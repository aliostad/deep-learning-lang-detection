#!/bin/bash

GRUPO="$HOME/Desktop/grupo03"
INSTALL="$HOME/Desktop/install"
REPO="$HOME/Documentos/Facu/Sistemas Operativos/TPSO1C08"

rm -r -f $GRUPO
rm -r -f $INSTALL
mkdir $GRUPO
mkdir -p $INSTALL/tests
cp "$REPO/Galida/galida.sh" $INSTALL
cp "$REPO/Gemoni/gemoni.sh" $INSTALL
cp "$REPO/Ginsta/ginsta.sh" $INSTALL
cp "$REPO/Glog/glog.sh" $INSTALL
cp "$REPO/Gontro/gontro.pl" $INSTALL
cp "$REPO/Gontro/gontrosub.pm" $INSTALL
cp "$REPO/Mover/mover.sh" $INSTALL
cp "$REPO/Docs/README.txt" $INSTALL
cp -r "$REPO/Tests/arridir" $INSTALL/tests
cp -r "$REPO/Tests/confdir" $INSTALL/tests
