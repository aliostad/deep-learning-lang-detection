echo '-----------atis-----------------------------'
echo '===========BigramModel=========================='
java -cp bin/ nlp.lm.BigramModel pos/atis/ 0.1
echo '===========BackwardBigramModel=========================='
java -cp bin/ nlp.lm.BackwardBigramModel pos/atis/ 0.1
echo '===========BidirectionalBigramModel=========================='
java -cp bin/ nlp.lm.BidirectionalBigramModel pos/atis/ 0.1

echo '-----------wsj-----------------------------'
echo '===========BigramModel=========================='
java -cp bin/ nlp.lm.BigramModel pos/wsj/ 0.1
echo '===========BackwardBigramModel=========================='
java -cp bin/ nlp.lm.BackwardBigramModel pos/wsj/ 0.1
echo '===========BidirectionalBigramModel=========================='
java -cp bin/ nlp.lm.BidirectionalBigramModel pos/wsj/ 0.1

echo '-----------brown-----------------------------'
echo '===========BigramModel=========================='
java -cp bin/ nlp.lm.BigramModel pos/brown/ 0.1
echo '===========BackwardBigramModel=========================='
java -cp bin/ nlp.lm.BackwardBigramModel pos/brown/ 0.1
echo '===========BidirectionalBigramModel=========================='
java -cp bin/ nlp.lm.BidirectionalBigramModel pos/brown/ 0.1
