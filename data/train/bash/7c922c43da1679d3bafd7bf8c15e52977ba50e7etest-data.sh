#!/bin/bash
set -e

lsd invoke.lsd gate.tokenizer_2.0.0 test-data/hello_world.txt test-data/tokenizer-expected.gate
lsd invoke.lsd gate.splitter_2.0.0 test-data/tokenizer-expected.gate test-data/splitter-expected.gate
lsd invoke.lsd gate.tagger_2.0.0 test-data/splitter-expected.gate test-data/tagger-expected.gate
lsd invoke.lsd gate.gazetteer_2.0.0 test-data/tagger-expected.gate test-data/gazetteer-expected.gate
lsd invoke.lsd gate.ner_2.0.0 test-data/gazetteer-expected.gate test-data/ner-expected.gate
lsd invoke.lsd gate.ortho_2.0.0 test-data/ner-expected.gate test-data/ortho-expected.gate
lsd invoke.lsd gate.npchunker_2.0.0 test-data/tagger-expected.gate test-data/npchunker-expected.gate
lsd invoke.lsd gate.vpchunker_2.0.0 test-data/tagger-expected.gate test-data/vpchunker-expected.gate
