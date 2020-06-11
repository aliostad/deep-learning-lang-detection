(ns hiredman.zip
	(:import (java.util.zip ZipEntry ZipOutputStream ZipInputStream)
			 (java.io ByteArrayInputStream ByteArrayOutputStream)))

(defn pad-to-8 [string]
	  (if (> 8 (count string))
		(recur (.concat "0" string))
		string))

(defn zip-string [string]
	  (let [a (ByteArrayOutputStream. )]
		(doto (ZipOutputStream. a)
			  (.putNextEntry (ZipEntry. ""))
			  (.write (.getBytes (apply str (map (comp pad-to-8 #(Integer/toBinaryString %)) (.getBytes string)))))
			  .finish
			  .close)
		(.toByteArray a)))

(defn unzip-string [string]
	  (let [a (ByteArrayInputStream. (into-array Byte/TYPE string))
			in (doto (ZipInputStream. a)
					 .getNextEntry)
			out (ByteArrayOutputStream.)]
		(loop []
			  (if (not= (.available in) 0)
				(do (.write out (.read in))
				    (recur))
				(let [r (apply str (map char (.toByteArray out)))
					  c (.length r)]
				  (apply str (map (comp char #(Integer/parseInt % 2) (partial apply str)) (partition 8 (subs r 0 (dec c))))))))))



(with-open [file (-> "/home/hiredman/foo.jpg" java.io.FileWriter.)]
		   (.write file (unzip-string (zip-string (slurp "/home/hiredman/.two")))))
