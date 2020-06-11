#!/bin/bash

../bin/convert --ifile sample-train --ofilex sample-train.x --ofiley sample-train.y
../bin/convert --ifile sample-test --ofilex sample-test.x --ofiley sample-test.y
../bin/convert --ifile rel.user --ofilex rel.user.x --ofiley rel.user.y
../bin/convert --ifile rel.item --ofilex rel.item.x --ofiley rel.item.y

../bin/transpose --ifile sample-train.x --ofile sample-train.xt
../bin/transpose --ifile sample-test.x --ofile sample-test.xt
../bin/transpose --ifile rel.user.x --ofile rel.user.xt
../bin/transpose --ifile rel.item.x --ofile rel.item.xt

../bin/libFM -task r -train sample-train -test sample-test -dim ’1,1,8’ --relation rel.user,rel.item -out out
