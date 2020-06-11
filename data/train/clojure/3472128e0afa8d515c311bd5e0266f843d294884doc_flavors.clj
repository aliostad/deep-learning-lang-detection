(ns ^{:doc "The myriad of DocFlavors supported by javax.print"
      :author "Roberto Acevedo"}
  clj-print.doc-flavors
  (:import (javax.print DocFlavor$INPUT_STREAM
                        DocFlavor$URL)))

(defn input-stream
  "Returns a DocFlavor with the given MIME type and a
   representation class of java.io.InputStream. See the
   `input-streams` var for a listing of the psf InputStream
   DocFlavors supplied by Java."
  [mime-type]
  (DocFlavor$INPUT_STREAM. mime-type))

(def input-streams {:autosense DocFlavor$INPUT_STREAM/AUTOSENSE
                   :gif DocFlavor$INPUT_STREAM/GIF
                   :jpeg DocFlavor$INPUT_STREAM/JPEG
                   :pcl DocFlavor$INPUT_STREAM/PCL
                   :pdf DocFlavor$INPUT_STREAM/PDF
                   :png DocFlavor$INPUT_STREAM/PNG
                   :postscript DocFlavor$INPUT_STREAM/POSTSCRIPT
                   :text-html-host DocFlavor$INPUT_STREAM/TEXT_HTML_HOST
                   :text-html-us-ascii DocFlavor$INPUT_STREAM/TEXT_HTML_US_ASCII
                   :text-html-utf-16 DocFlavor$INPUT_STREAM/TEXT_HTML_UTF_16
                   :text-html-utf-16be DocFlavor$INPUT_STREAM/TEXT_HTML_UTF_16BE
                   :text-html-utf-16le DocFlavor$INPUT_STREAM/TEXT_HTML_UTF_16LE
                   :text-html-utf-8 DocFlavor$INPUT_STREAM/TEXT_HTML_UTF_8
                   :text-plain-host DocFlavor$INPUT_STREAM/TEXT_PLAIN_HOST
                   :text-plain-us-ascii DocFlavor$INPUT_STREAM/TEXT_PLAIN_US_ASCII
                   :text-plain-utf-16 DocFlavor$INPUT_STREAM/TEXT_PLAIN_UTF_16
                   :text-plain-utf-16be DocFlavor$INPUT_STREAM/TEXT_PLAIN_UTF_16BE
                   :text-plain-utf-16le DocFlavor$INPUT_STREAM/TEXT_PLAIN_UTF_16LE
                   :text-plain-utf-8 DocFlavor$INPUT_STREAM/TEXT_PLAIN_UTF_8})

(defn url
  "Returns a DocFlavor with the given MIME type and a
   representation class of java.net.URL. See the `urls`
   var for a listing of the psf URL DocFlavors supplied by Java."
  [mime-type]
  (DocFlavor$INPUT_STREAM. mime-type))

(def urls {:autosense DocFlavor$URL/AUTOSENSE
          :gif DocFlavor$URL/GIF
          :jpeg DocFlavor$URL/JPEG
          :pcl DocFlavor$URL/PCL
          :pdf DocFlavor$URL/PDF
          :png DocFlavor$URL/PNG
          :postscript DocFlavor$URL/POSTSCRIPT
          :text-html-host DocFlavor$URL/TEXT_HTML_HOST
          :text-html-us-ascii DocFlavor$URL/TEXT_HTML_US_ASCII
          :text-html-utf-16 DocFlavor$URL/TEXT_HTML_UTF_16
          :text-html-utf-16be DocFlavor$URL/TEXT_HTML_UTF_16BE
          :text-html-utf-16le DocFlavor$URL/TEXT_HTML_UTF_16LE
          :text-html-utf-8 DocFlavor$URL/TEXT_HTML_UTF_8
          :text-plain-host DocFlavor$URL/TEXT_PLAIN_HOST
          :text-plain-us-ascii DocFlavor$URL/TEXT_PLAIN_US_ASCII
          :text-plain-utf-16 DocFlavor$URL/TEXT_PLAIN_UTF_16
          :text-plain-utf-16be DocFlavor$URL/TEXT_PLAIN_UTF_16BE
          :text-plain-utf-16le DocFlavor$URL/TEXT_PLAIN_UTF_16LE
          :text-plain-utf-8 DocFlavor$URL/TEXT_PLAIN_UTF_8})
