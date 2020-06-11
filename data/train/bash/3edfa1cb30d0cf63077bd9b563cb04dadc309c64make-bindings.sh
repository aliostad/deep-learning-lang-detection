#!/bin/sh

# Some variables.
TOP=".."
LIBS="-lLinearMath -lBulletCollision -lBulletDynamics -lBulletSoftBody"
PREFIX="$TOP/install"
INCLUDES="-I$PREFIX/include/bullet"
CXXFLAGS="-m32 -fPIC -Wall -O2 $INCLUDES"
LFLAGS="-shared -L$PREFIX/lib $LIBS -Wl,-rpath=."

#SWIG="$HOME/swig-pharo/bin/swig"
SWIG="/home/ronie/src/swig/build/preinst-swig"

# Invoke swig.
$SWIG -Wextra -w516 -c++ $INCLUDES -pharo -impname BulletPharo BulletPharo.i || exit 1

# Invoke g++
g++ $CXXFLAGS -o libBulletPharo.so BulletPharo_wrap.cxx $LFLAGS || exit 1
 
