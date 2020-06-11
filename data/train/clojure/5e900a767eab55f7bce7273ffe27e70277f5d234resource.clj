(ns pallet.common.resource
  "Forms for manipulating (classpath) resources"
  (:refer-clojure :exclude [slurp]))

(defn slurp
  "Reads the resource named by name using the encoding enc into a string
   and returns it."
  ([name] (slurp name (.name (java.nio.charset.Charset/defaultCharset))))
  ([#^String name #^String enc]
     (let [stream (-> (.getContextClassLoader (Thread/currentThread))
                      (.getResourceAsStream name)
                      (java.io.InputStreamReader.))]
       (when stream
         (with-open [stream stream]
           (clojure.core/slurp stream))))))
