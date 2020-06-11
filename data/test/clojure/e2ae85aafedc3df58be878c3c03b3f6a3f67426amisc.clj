(use 'clojure.java.io)

(defn copy-io!
  "Consumes the input-stream. If the output stream is given, the input stream's content is
written to the output stream. Otherwise the content is returned as a byte[]."
  [is & [os]]
  (let [os (or os (java.io.ByteArrayOutputStream.))
        bffr (byte-array 8192)]
    (with-open [is (input-stream is)]
      (loop []
        (let [r (.read is bffr)]
          (if (= -1 r) (when (instance? java.io.ByteArrayOutputStream os) (.toByteArray os))
              (do 
                (.write os bffr 0 r)
                (recur))))))))

