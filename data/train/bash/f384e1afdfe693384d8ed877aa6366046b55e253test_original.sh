#!/bin/sh

pushd ../src

make

./alcon2011 -s:../sample_data/level1/sample-level1-01.ppm -d:../result/original/sample-level1-01.txt -i:../result/original/sample-level1-01.ppm -g:../sample_data/level1/sample-level1-01.tr

./alcon2011 -s:../sample_data/level1/sample-level1-02.ppm -d:../result/original/sample-level1-02.txt -i:../result/original/sample-level1-02.ppm -g:../sample_data/level1/sample-level1-02.tr

./alcon2011 -s:../sample_data/level1/sample-level1-03.ppm -d:../result/original/sample-level1-03.txt -i:../result/original/sample-level1-03.ppm -g:../sample_data/level1/sample-level1-03.tr

./alcon2011 -s:../sample_data/level2/sample-level2-01.ppm -d:../result/original/sample-level2-01.txt -i:../result/original/sample-level2-01.ppm -g:../sample_data/level2/sample-level2-01.tr

./alcon2011 -s:../sample_data/level2/sample-level2-02.ppm -d:../result/original/sample-level2-02.txt -i:../result/original/sample-level2-02.ppm -g:../sample_data/level2/sample-level2-02.tr

./alcon2011 -s:../sample_data/level2/sample-level2-03.ppm -d:../result/original/sample-level2-03.txt -i:../result/original/sample-level2-03.ppm -g:../sample_data/level2/sample-level2-03.tr

./alcon2011 -s:../sample_data/level3/sample-level3-01.ppm -d:../result/original/sample-level3-01.txt -i:../result/original/sample-level3-01.ppm -g:../sample_data/level3/sample-level3-01.tr

./alcon2011 -s:../sample_data/level3/sample-level3-02.ppm -d:../result/original/sample-level3-02.txt -i:../result/original/sample-level3-02.ppm -g:../sample_data/level3/sample-level3-02.tr

./alcon2011 -s:../sample_data/level3/sample-level3-03.ppm -d:../result/original/sample-level3-03.txt -i:../result/original/sample-level3-03.ppm -g:../sample_data/level3/sample-level3-03.tr

popd
