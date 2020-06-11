(defprotocol IOFactory
    (make-reader [this] "Create a Buffered Reader")
    (make-writer [this] "Create a Buffered Writer")
)

(extend InputStream IOFactory
        (:make-reader (fn [src] (-> src InputStreamReader. BufferedReader. )))
        (:make-writer (fn [dst] (throw (IllegalArgumentException. "Can't Create InputStream"))))
)

(extend  OutputStream IOFactory
         (:make-reader (fn [src] throw (IllegalArgumentException. "Can't Create OutputStream")))
         (:make-writer (fn [dst] (-> dst OutputStreamWriter. BufferedWriter.)))
)


;; multi-funtions load from other .clj file :)
(extend-type File IOFactory
         (:make-reader [src] (multi-make-reader (FileInputStream.  src)))
         (:make-writer [dst] (multi-make-writer (FileOutputStream. dst)))
)



