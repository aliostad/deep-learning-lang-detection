(ns pdfbox.core
  (:require [clojure.contrib.trace :as trace])
  (:import [org.apache.pdfbox.pdmodel PDDocument PDPage]
           [org.apache.pdfbox.pdmodel.edit PDPageContentStream]
           [org.apache.pdfbox.pdmodel.font PDType1Font]))


(comment
 (let [doc (PDDocument.)
       page (PDPage.)]
   (.addPage doc page)
   (with-open [content-stream (PDPageContentStream. doc page)]
     (.beginText content-stream)
     (.setFont content-stream PDType1Font/HELVETICA_BOLD 12)
     (.moveTextPositionByAmount content-stream 100 700)
     (.drawString content-stream "Hello World")
     (.endText content-stream))
   (.save doc "test.pdf")
   (.close doc))

 )

(def *pdf* nil)

(defn close-content-stream []
  (if (and *pdf* @*pdf* (get @*pdf* :content-stream))
    (do
      (prn "closing content stream")
      (.close (get @*pdf* :content-stream))
      (swap! *pdf* dissoc :content-stream))))

(defn close-doc []
  (if (and *pdf* @*pdf* (get @*pdf* :document))
    (do
      (prn "closing document: " (str @*pdf*))
      (.close (get @*pdf* :document))
      (swap! *pdf* dissoc :document :current-page))))

(defmacro prog1 [first-expr & body]
  `(let [res# ~first-expr]
     ~@body
     res#))


(defmacro do-pdf [& body]
  `(binding [~'*pdf* (atom {:document (PDDocument.)})]
     (prog1
       (do
         ~@body)
       (close-text)
       (close-content-stream)
       (close-doc))))

(defn add-page []
  (let [page (PDPage.)]
    (prn "adding page")
    (.addPage (get @*pdf* :document) page)
    (swap! *pdf*
           assoc
           :current-page page
           :content-stream nil)))

(defn ensure-page []
  (if (not (get @*pdf* :current-page))
    (add-page)))

(defn current-page []
  (get @*pdf* :current-page))

(defn document []
  (get @*pdf* :document))

;; NB: automatically call beignText or not?
(defn ensure-content-stream []
  (ensure-page)
  (if (not (get @*pdf* :content-stream))
    (do
      (prn "creating content stream: " (str @*pdf*))
      (swap! *pdf* assoc
             :content-stream (PDPageContentStream.
                              (document)
                              (current-page))
             :begin-text true)
      (.beginText (content-stream)))))

(defn close-text []
  (if (and @*pdf* (get @*pdf* :begin-text))
    (do
      (prn "calling .endText")
      (.endText (get @*pdf* :content-stream))
      (swap! *pdf* dissoc :begin-text))))

;; TODO: support specifying things like font and size in options
(defn write-text [text & options]
  (ensure-content-stream)
  (prn "setting font, movnig text pos and drawing string: " text " :: " (str @*pdf*))
  (.setFont                  (content-stream) PDType1Font/HELVETICA_BOLD 12)
  ;; (.moveTextPositionByAmount (content-stream) 100 700)
  (.drawString               (content-stream) text))

;; NB: how can we do this gracefully?  How do we know end-text must be called?
(defn end-text []
  (.endText (content-stream)))

(defn save [file-name]
  (.save (get @*pdf* :document) file-name))

;; NB this is a crappy way of doing this...
(defn down-line [& options]
  (.moveTextPositionByAmount (get @*pdf* :content-stream) 100 700))

(trace/dotrace [down-line save end-text write-text close-text ensure-content-stream document current-page ensure-page add-page close-doc close-content-stream]
 (do-pdf
   (write-text "Hello World\n")
   ;; (write-text "Hello New line!\n")
   (save "test2.pdf")))