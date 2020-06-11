(ns nile.streams
  (:import (java.io InputStream FilterInputStream FilterOutputStream
                    OutputStream PipedInputStream PipedOutputStream)
           (org.apache.commons.io.input CountingInputStream)
           (org.apache.commons.io.output CountingOutputStream)))

(defn split-input-stream
  "Splits the given stream into n PipedInputStreams, spawns a future that reads
  from the original stream and writes to the streams. Once the InputStream has
  been completely read and written, it is closed. Uses a buffer size of 8192 if
  no size is specified.

  NOTE: The InputStreams must be read from IN PARALLEL (different threads), or
  else reading will block while waiting for the other streams to be read.
  Streams can be read as fast as the slowest reader.

  Returns a tuple of the future and sequence of input-streams, so derefing the
  future can be blocked on if desired."
  ([stream n]
     (split-input-stream stream n 8192))
  ([stream n buffer-length]
     (let [len buffer-length
           in-streams (doall (for [_ (range n)] (PipedInputStream. len)))
           out-streams (doall (for [in in-streams] (PipedOutputStream. in)))]
       [(future (try
                  (loop []
                    (let [buf (byte-array len)
                          read? (.read stream buf 0 len)]
                      (if (pos? read?)
                        (do (doseq [out out-streams]
                              (.write out buf 0 read?))
                            (recur))
                        (.close stream))))
                  true
                  (catch Exception e e)
                  (finally
                    (doseq [out out-streams]
                      (try
                        (.flush out)
                        (.close out)
                        (catch Exception _))))))
        in-streams])))

(defn counted-stream
  "Decorate a stream to turn it into a counted stream, which will keep
  track of the bytes that have passed through the stream. Once the stream has
  been closed, the handler will be called with the count of bytes that have
  been passed through the stream."
  [stream handler]
  (cond
   (instance? InputStream stream)
   (let [cis (CountingInputStream. stream)]
     (proxy [FilterInputStream] [cis]
       (close []
         (handler (.getByteCount cis)))))

   (instance? OutputStream stream)
   (let [cos (CountingOutputStream. stream)]
     (proxy [FilterOutputStream] [cos]
       (close []
         (handler (.getByteCount cos)))))

   :else
   (throw
    (Exception. "Input stream is neither an InputStream nor OutputStream"))))
