(ns protocol
    (:import (java.io FileInputStream InputStreamReader BufferedReader)))

(defn make-reader [src]
  (-> src FileInputStream. InputStreamReader. BufferedReader.))

(defn multi-make-reader [src]
  (-> (condp = (type src)
             java.io.InputStream src
             java.lang.String (FileInputStream. src)
             java.io.File (FileInputStream. src)
             java.net.Socket (.getInputStream src)
             java.net.URL (if (= "file" (.getProtocol src))
                            (-> src .getPath FileInputStream.)
                            (.openStream src))
             )))

(defn gulp [src]
  (let [stringBuilder (StringBuilder.)]
    (with-open [reader (-> src 
                           FileInputStream.
                           InputStreamReader.
                           BufferedReader.
                           )]
               (loop [c (.read reader)]
                     (if (neg? c)
                       (str stringBuilder)
                       (do
                         (.append stringBuilder (char c))
                         (recur (.read reader)))
                       ))
    )
  )
)


(defn better-gulp [src]
  (let [builder (StringBuilder.)]
    (with-open [reader (make-reader src)]
               (loop [c (.read reader)]
                     (if (neg? c)
                       (str builder)
                       (do
                         (.append builder (char c))
                         (recur (.read reader))))
                     )
               )
    )
  )

;(println (gulp "input.data"))
(println (better-gulp "input.data"))






