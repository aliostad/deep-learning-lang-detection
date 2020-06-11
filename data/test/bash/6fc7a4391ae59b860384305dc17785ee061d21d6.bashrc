#       csel-37's .bashrc last changed 2013/06/13

#       sourced by .bash_profile --- run in a login bash as well as any interactive bash

umask 077

. /soft/rko-modules/tcl/init/bash       #initialize module system

unset PATH

#includes the defaults from the default student .cshrc

module load dot                 #current directory part of PATH
module load user                #adds paths in my filespace as well as ~/.modules to modules paths
module load gnu                 #paths to gnu shell external commands --- these take priority as system is loaded later
module load local               #local software and public domain software paths
module load system              #paths to default shell external commands etc.
module load modules     #adds /opt/modules/3.1.0/* to several environment variables
module load soft/gcc
module load java
module load perl
module load x11
module load compilers
module load math/mathematica
module load scheme

#D
module load soft/dmd
module load soft/geany


unalias -a
