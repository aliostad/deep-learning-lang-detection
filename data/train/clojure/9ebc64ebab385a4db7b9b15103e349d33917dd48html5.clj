(ns unto-net-blog.html5
  (:require [clojure.xml :as xml])
  (:require [clojure.java.io :as io])
  (:import [nu.validator.htmlparser.sax HtmlParser HtmlSerializer])
  (:import [nu.validator.htmlparser.common XmlViolationPolicy])
  (:import [org.xml.sax InputSource])
  (:import [org.xml.sax.helpers AttributesImpl])
  (:import [java.net URI URL MalformedURLException Socket])
  (:import [java.io InputStream File FileInputStream ByteArrayInputStream
            BufferedInputStream InputStreamReader BufferedReader]))

(defn- encoding-from-content-type
  "Strips the character-set name from a Content-Type: HTTP header value."
  [content-type]
  (when content-type
        (second (re-find #"charset=(.*)$" (.toLowerCase content-type)))))

(defmulti #^{:doc "Like clojure.contrib.duck-streams/reader, but
  attempts to convert its argument to an InputStream. Returns a map
  mapping :stream to the stream and, potentially, :encoding to the
  encoding detected on that stream."}
  input-stream class)

(defmethod input-stream InputStream [#^InputStream x]
  {:stream x})

(defmethod input-stream File [#^File x]
  {:stream (FileInputStream. x)})

(defmethod input-stream URL [#^URL x]
  (if (= "file" (.getProtocol x))
    (FileInputStream. (.getPath x))
    (let [connection (.openConnection x)]
     {:stream (.getInputStream connection),
       :encoding (-> connection (.getHeaderField "Content-Type") encoding-from-content-type)})))

(defmethod input-stream URI [#^URI x]
  (input-stream (.toURL x)))

(defmethod input-stream String [#^String x]
  (try (let [url (URL. x)]
         (input-stream url))
       (catch MalformedURLException e
         (input-stream (File. x)))))

(defmethod input-stream Socket [#^Socket x]
  {:stream (.getInputStream x)})

(defmethod input-stream :default [x]
  (throw (Exception. (str "Cannot open " (pr-str x) " as an input stream."))))

(defn html5-parser [s content-handler]
  (let [p (HtmlParser.)
        stream (-> ((input-stream s) :stream) BufferedInputStream.)
        source (InputSource. stream)]
    (.setXmlPolicy p XmlViolationPolicy/ALLOW)
    (.setContentHandler p content-handler)
    (.parse p source)
    p))

(defn parse [s]
  "Parses and loads the source s, which can be a File, InputStream or
  String naming a URI. Returns a tree of the xml/element struct-map,
  which has the keys :tag, :attrs, and :content, and accessor fns tag,
  attrs, and content."
  (xml/parse s html5-parser))

(defn parse-str [s]
  (parse (io/input-stream (.getBytes s))))

(defn attributes [attr-map]
  (let [attr (AttributesImpl.)]
    (doseq [[key value] attr-map]
      (.addAttribute attr "" (name key) nil "string" value))
    attr))

(defn element? [element]
  (and (map? element) (= (apply hash-set (keys element)) #{:tag :attrs :content})))

(defn serialize-element [serializer element]
  {:pre [(or (element? element) (string? element))]}
  (if (string? element)
    (.characters serializer (char-array element) 0 (count element))
    (do
      (.startElement serializer "http://www.w3.org/1999/xhtml" (name (xml/tag element)) nil (attributes (xml/attrs element)))
      (doseq [x (xml/content element)] (serialize-element serializer x))
      (.endElement serializer "http://www.w3.org/1999/xhtml" (name (xml/tag element)) nil))))

(defn serialize-doc [element w]
  (let [serializer (HtmlSerializer. w)]
    (.startDocument serializer) 
    (serialize-element serializer element)
    (.endDocument serializer)))

(defn serialize-doc-to-str [element]
  (with-out-str
    (serialize-doc element *out*)))
