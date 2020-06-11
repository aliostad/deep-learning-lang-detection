(ns main)

(import 
  '(java.net URL)
  '(java.io InputStreamReader)
  '(java.io BufferedReader)
  '(java.io DataInputStream) 
)

(defn download-url 
  "Returns the document at url as a string"  
  [#^String url]
  (let [u (URL. url)]
    (with-open [stream (. u (openStream))]
      (let [buf (BufferedReader. (InputStreamReader. stream))]
        (apply str (line-seq buf))))))

(defn post-url
  "Posts a map of parameters to an url and returns the response as a string"
  [#^String url parameter-map ]
    (rea)
  
  )

(print (download-url "http://www.flickr.com/photos/akal")

  )