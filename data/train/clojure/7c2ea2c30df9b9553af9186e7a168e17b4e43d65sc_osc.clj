(ns fadeddata.sc-osc
  (:import (java.net InetAddress ServerSocket Socket SocketException)
           (java.io InputStreamReader OutputStream OutputStreamWriter PrintWriter)
           (clojure.lang LineNumberingPushbackReader))
  (:use clojure.main
	clojure.contrib.server-socket
	fadeddata.binary-structure))

(defn create-stream [seq]
  (let [c (ref seq)] 
     (proxy [java.io.InputStream] [] 
         (read [] 
           (dosync 
            (let [ret (first @c)] 
              (alter c rest) 
              (int ret)))))))

(defn content-type [bytes]
     (let [begin (map char (take 7 bytes))]
       (cond (= begin '(\# \b \u \n \d \l \e)) :osc-bundle
	     true :osc-message)))

(def-binary-primitive :int32
  {:Reader
   (bit-or (bit-shift-left (. #^java.io.InputStream (:stream args) read) 24)
	   (bit-or (bit-shift-left (. #^java.io.InputStream (:stream args) read) 16)
		   (bit-or (bit-shift-left (. #^java.io.InputStream (:stream args) read) 8)
			   (. #^java.io.InputStream (:stream args) read))))
   :Writer
   (println "Not implemented.")})

(def-binary-primitive :time-tag
  {:Reader
   (let [t (ref [])]
     (dotimes [_ 8]
       (dosync (commute t conj (. (:stream args) read))))
     @t)
   :Writer
   ()})

(def-binary-primitive :content
  {:Reader
   (let [c (ref [])
	 t (ref [])]
     (dotimes [_ 8]
       (dosync (commute t conj (. (:stream args) read))))
     (dotimes [_ (- (:size args) 8)]
       (dosync (commute c conj (. (:stream args) read))))
     (let [type (content-type @t)] 
       {:type type :content (read-value {:Type type :stream (create-stream @c)}) }))
   :Writer 
   (println "Not implemented")})

(def-binary-structure :osc-bundle
  ((time-tag :time-tag {})
   (size :int32 {})))

(def-binary-structure :osc-message
  ())

(def-binary-structure :osc-packet
  ((size :int32 {})
   (content :content {:size size})))
	 

(def osc (ref []))

(defn listen [ins outs]
  (let [in (InputStreamReader. ins)
	out (OutputStreamWriter. outs)]
  (loop []
    (dosync
     (commute osc conj (. ins read)))
    (recur))))
  
(def bundle [0 0 0 44 35 98 117 110 100 108 101 0 205 124 4 190 82 137 71 59 0 0 0 24 47 103 111 111 100 47 110 101 119 115 0 0 44 105 102 0 0 0 0 1 63 166 102 102])

(def osc-stream 
  (let [c (ref '(0 0 0 44 35 98 117 110 100 108 101 0 205 124 4 190 82 137 71 59 0 0 0 24 47 103 111 111 100 47 110 101 119 115 0 0 44 105 102 0 0 0 0 1 63 166 102 102))] 
     (proxy [java.io.InputStream] [] 
         (read [] 
           (dosync 
            (let [ret (first @c)] 
              (alter c rest) 
              (int ret)))))))