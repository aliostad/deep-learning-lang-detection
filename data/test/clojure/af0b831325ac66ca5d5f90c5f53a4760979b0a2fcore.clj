(ns swindon.core
  (:import [java.util.zip Deflater]
           [java.util.zip Inflater]
           [java.util.zip DeflaterInputStream]
           [java.util.zip DeflaterOutputStream]
           [java.util.zip InflaterInputStream]
           [java.util.zip ZipInputStream]
           [java.io ByteArrayInputStream]
           [java.io ByteArrayOutputStream]))

(def ^:private default-level 3)

(defn zip
  ([buffer]
     (zip buffer false))
  ([buffer wrap]
     (zip buffer wrap default-level))
  ([buffer wrap level]
     (let [defl (Deflater. level wrap)
           bais (ByteArrayInputStream. buffer)
           dis (DeflaterInputStream. bais defl)
           baos (ByteArrayOutputStream.)]
       (org.apache.commons.io.IOUtils/copy dis baos)
    (.toByteArray baos))))

(defn unzip 
  ([buffer]
     (unzip buffer false))
  ([buffer wrap]
     (let [inf (Inflater. wrap)
           bais (ByteArrayInputStream. buffer)
           iis (InflaterInputStream. bais inf)
           baos (ByteArrayOutputStream.)]
       (org.apache.commons.io.IOUtils/copy iis baos)
       (.toByteArray baos))))

(defn unzip-pkzip [buffer]
  (let [bais (ZipInputStream. (ByteArrayInputStream. buffer))
        baos (ByteArrayOutputStream.)]
    (org.apache.commons.io.IOUtils/copy bais baos)
    (.toByteArray baos)))
