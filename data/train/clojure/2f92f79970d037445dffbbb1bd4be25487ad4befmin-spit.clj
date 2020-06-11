(ns reader.min-spit
  (:import (java.io FileInputStream InputStreamReader BufferedReader)))

(defn makeReader [src] (-> (condp = (type src)
                              java.io.InputStream src
                              java.lang.String (FileInputStream. src)
                              java.io.File (FileInputStream. src)
                              java.net.Socket (.getInputStream src)
                              java.net.URL (if (= "file" (.getProtocol src))
                                             (-> src .getPath FileInputStream.)
                                             (.openStream src)))
                               InputStreamReader. BufferedReader.))

(defn min-spit [src]
    (let [sb (new StringBuilder)]
        (with-open [reader (makeReader src)]
            (loop [readChar (.read reader)]
                (if (neg? readChar) (str sb) 
                    (do (.append sb (char readChar))
                        (recur (.read reader))))))))





