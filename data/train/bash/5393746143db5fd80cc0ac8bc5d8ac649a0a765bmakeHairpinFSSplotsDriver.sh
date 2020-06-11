#!/bin/bash

scriptsdir="$HOME/DNA/scripts"

nproc=1

factor=1.7
suff="NoDih$factor"
descr="(with dihedral interaction disabled and base pairing increased by a factor $factor)"


xargs -P $nproc -n 1 octave-3.6.4 -q -p $scriptsdir --eval << EOF
"pkg load optim; makeHairpinStateFSSplots"
"pkg load optim; makeHairpinEnergyFSSplots"
"pkg load optim; makeHairpinEndToEndFSSplots"
"pkg load optim; makeHairpinGyradFSSplots"
EOF

exit




xargs -P $nproc -n 1 octave-3.6.4 -q -p $scriptsdir --eval << EOF
"pkg load optim; makeHairpinStateFSSplots"
"pkg load optim; makeHairpinEnergyFSSplots"
"pkg load optim; makeHairpinEndToEndFSSplots"
"pkg load optim; makeHairpinGyradFSSplots"
"pkg load optim; makeHairpinStateFSSplots('$suff', '$descr')"
"pkg load optim; makeHairpinEnergyFSSplots('$suff', '$descr')"
"pkg load optim; makeHairpinEndToEndFSSplots('$suff', '$descr')"
"pkg load optim; makeHairpinGyradFSSplots('$suff', '$descr')"
EOF

