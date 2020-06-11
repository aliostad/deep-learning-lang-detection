(ns ogrim.common.downloader
  (:import java.net.URL
           java.lang.StringBuilder
           java.io.BufferedReader
           java.io.InputStreamReader
           java.nio.charset.Charset))

(defn download
  "Returns the web page as a string
   Args:
     url - The URL to fetch
     milliseconds - Pause before download"
  [address & encoding]
  (let [url (URL. address)
        encode (first encoding)
        cs (Charset/forName (if (seq encode) encode "UTF-8"))]
    (with-open [stream (. url (openStream))] 
      (let [buf (BufferedReader. (InputStreamReader. stream cs))]
        (apply str (line-seq buf))))))
