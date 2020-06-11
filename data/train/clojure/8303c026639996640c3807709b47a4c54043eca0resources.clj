(ns joy.resources)

(import [java.io BufferedReader InputStreamReader]
        [java.net URL])

(defn joc-www []
  (-> "http://joyofclojure.com/hello" URL.
      .openStream
      InputStreamReader.
      BufferedReader.))

(let [stream (joc-www)]
  (with-open [page stream]
    (println (.readLine page))
    (print "The stream will now close..."))
  (println "But let's read from it anyway"))

(defmacro with-resource [binding close-fn & body]
  `(let ~binding
     (try
       ~@body
       (finally
         (~close-fn ~(first binding))))))
