(ns my-cljs.core
  (:require [cljs-pdfkit.core :as cljs-pdfkit]
            [cljs.reader :as reader]
            ))

(def blob-stream (js/require "blob-stream"))

(defn ^:export refresh-pdf [text]
  (let [
        form (reader/read-string text)
        doc (cljs-pdfkit/pdf form)
        stream (.pipe doc (blob-stream))
        ]
    (.end doc)
    (.on stream "finish"
         #(let [url (.toBlobURL stream "application/pdf")]
            (set! (.-src (js/document.getElementById "frame")) url)))))

(defn ^:export f []
  (js/document.getElementById "frame"))
