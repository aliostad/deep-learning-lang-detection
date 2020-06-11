#! /bin/sh
#
# run.sh
# Copyright (C) 2015 truong-d <truong-d@dellxps>
#
# Distributed under terms of the MIT license.
#


# This is the training script to train the CRFs model for openvtalk

# Required CRFSuite
export PATH=/home/truong-d/works/tools/vita/build/crfsuite/installed/bin:$PATH

dir=models
python_segment=scripts/segment.py
python_chunk=scripts/chunking.py
python_pos=scripts/pos_new.py
mkdir -p $dir


# ============= Train the segmentation model ===========
python $python_segment < ./data/segment/vi-segment.train >  ./data/segment/vi-segment.train.crfsuite || exit 1
python $python_segment < ./data/segment/vi-segment.test >  ./data/segment/vi-segment.test.crfsuite || exit 1

crfsuite learn -e2 -m $dir/word_segment.model ./data/segment/vi-segment.train.crfsuite ./data/segment/vi-segment.test.crfsuite

# ============= Train the chunking model ===========
python $python_chunk < ./data/chunk/vi-chunk.train >  ./data/chunk/vi-chunk.train.crfsuite || exit 1
python $python_chunk < ./data/chunk/vi-chunk.test >  ./data/chunk/vi-chunk.test.crfsuite || exit 1

crfsuite learn -e2 -m $dir/word_chunk.model ./data/chunk/vi-chunk.train.crfsuite ./data/chunk/vi-chunk.test.crfsuite

# ============= Train the Pos tagging model ===========
python $python_pos < ./data/pos/vi-pos.train >  ./data/pos/vi-pos.train.crfsuite &
python $python_pos < ./data/pos/vi-pos.test >  ./data/pos/vi-pos.test.crfsuite
wait

crfsuite learn -e2 -m $dir/word_pos.model ./data/pos/vi-pos.train.crfsuite ./data/pos/vi-pos.test.crfsuite

#cp ./data/vn.dict $dir
