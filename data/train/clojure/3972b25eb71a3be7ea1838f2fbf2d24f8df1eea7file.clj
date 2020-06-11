(ns topoged.file
  (:use [clojure.java.io :only [input-stream output-stream reader]])
  (:import
   (java.io BufferedReader BufferedInputStream BufferedOutputStream File FileInputStream FileOutputStream InputStream OutputStream)
   (java.net MalformedURLException Socket URL URI)))
  


(defn copy-md5
  "Copy input to output and return the MD5 hash of the stream.
Based in duck-streams copy"
  [ainput aoutput]
  (with-open [input (input-stream ainput)
	      output (output-stream aoutput)]
    (let [buffer-size 1024
	  buffer (make-array Byte/TYPE buffer-size)
	  digest (java.security.MessageDigest/getInstance "MD5")]
      (loop []
	(let [ size (.read input buffer)]
	  (if (pos? size)
	    (do (.write output buffer 0 size)
		(.update digest buffer 0 size)
		(recur))
	    (.toString (java.math.BigInteger. 1 (.digest digest)) 16))))))) 

(defn copy-to-temp [prefix suffix input]
  (let [tempfile (File/createTempFile prefix suffix)
        md5 (with-open [^InputStream  r (input-stream input)
                        ^OutputStream w (output-stream tempfile)]
              (copy-md5 r w))]
    [tempfile md5]))
