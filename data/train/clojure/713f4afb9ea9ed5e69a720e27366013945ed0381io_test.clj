(ns octo-chicken.io-test
  (:use midje.sweet
        octo-chicken.io))

(fact "input-stream->lazy-seq"
      (fact "InputStream with data"
            (let [byte-seq (map byte (cycle (range -128 128)))
                  size 100000
                  bais (java.io.ByteArrayInputStream. (byte-array (take size byte-seq)))]
              (input-stream->lazy-seq bais) => (take size byte-seq)))
      (fact "Empty InputStream"
            (input-stream->lazy-seq (java.io.ByteArrayInputStream. (byte-array []))) => '())
      (fact "nil input"
            (input-stream->lazy-seq nil) => nil))
