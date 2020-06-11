(ns se.raek.file-ref
  (:import [java.io InputStreamReader OutputStreamWriter
	    FileInputStream FileOutputStream
	    FileNotFoundException PushbackReader]))

(defn- write-to-file [filename value]
  (binding [*out* (-> filename FileOutputStream. OutputStreamWriter.)]
    (pr value)
    (.close *out*))
  value)

(defn- read-from-file [filename]
  (let [stream (-> filename FileInputStream.
		   InputStreamReader. PushbackReader.)
	value (read stream)]
    (.close stream)
    value))

(defn- make-watch [filename]
  (fn [key reference old-state new-state]
    (write-to-file filename new-state)))

(defn file-ref [ref-type filename default-value]
  (let [value (try (read-from-file filename)
		   (catch FileNotFoundException _
		     (write-to-file filename default-value)
		     default-value))]
    (let [reference (ref-type value)]
      (add-watch reference (keyword (gensym)) (make-watch filename))
      reference)))
