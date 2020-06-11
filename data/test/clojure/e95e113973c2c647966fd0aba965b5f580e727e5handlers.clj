(ns litberator.handlers
  (:use
   [clojure.tools.logging :only (warn)]
   [litberator doi])
  (:import
   [java.net HttpURLConnection URL]
   [java.util.logging Level]
   [org.apache.commons.logging LogFactory]
   [com.gargoylesoftware.htmlunit WebClient BrowserVersion]))

(def ^{:dynamic true} client nil)

(HttpURLConnection/setFollowRedirects true)

(.setLevel
 (.getLogger
  (LogFactory/getLog "com.gargoylesoftware.htmlunit"))
 Level/OFF)

(defmacro without-js [form]
  `(do
     (.setJavaScriptEnabled client false)
     (let [result# ~form]
       (.setJavaScriptEnabled client true)
       result#)))

(defn url-to-stream [url]
  (.. (.getPage client url) getWebResponse getContentAsStream))

(defn substitute [s substitutions]
  (reduce (fn [s [pattern replace]]
            (.replace s pattern replace))
          s substitutions))

(defn string-join [sep coll]
  (apply str
         (interpose sep coll)))

(defn host-root [url]
  (string-join "."
                 (take-last 2
                            (.split (.getHost url) "\\."))))

(defn url-postfix-pdf-stream [url &{:keys [postfix]
                                    :or {postfix ".full.pdf"}}]
  (url-to-stream 
   (URL. (str (str url) postfix))))

(defn doi-pdf-stream [article]
  "For sites whose PDFs are named directly after DOIs."
  (url-to-stream
   (URL.
    (string-join "/"
                 ["http:/"
                  (.getHost (:url article))
                  "content/pdf"
                  (str (doi-suffix (:doi article)) ".pdf")]))))

(defn plos-doi-pdf-stream [doi]
  "PLOS journals all have a direct doi access to the PDF (neat)"
  (url-to-stream
   (URL. (str "http://dx.plos.org/" doi ".pdf"))))

(def pdf-stream* nil)
(defmulti pdf-stream*
  (fn [article]
    (let [root (host-root (:url article))]
      (if (.startsWith root "plos") :plos
          root)))
  :default nil)

(defmethod pdf-stream* "doi.org" [_] nil)

(defmethod pdf-stream* nil [article]
  (warn "NO DISPATCH FOR "
        (host-root (:url article))
        " --- " (:doi article)))

(defmethod pdf-stream* :plos [article]
  (plos-doi-pdf-stream (:doi article)))

(defmethod pdf-stream* "sgmjournals.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "wiley.com" [article]
  (without-js
   (let [start (substitute (str (:url article)) {"abstract" "pdf"})
         page (.getPage client start)]
     (url-to-stream
      (URL. (.getAttribute (.getElementById page "pdfDocument") "src"))))))

(defmethod pdf-stream* "jbiomedsem.org" [article]
  (doi-pdf-stream article))

(defmethod pdf-stream* "biodatamining.org" [article]
  (doi-pdf-stream article))

(defmethod pdf-stream* "acs.org" [article]
  (substitute (str (:url article)) {"doi" "pdf"}))

(defmethod pdf-stream* "asm.org" [article]
  (url-postfix-pdf-stream
   (substitute (str (:url article)) "content/abstract" "reprint")
   ".pdf"))

(defmethod pdf-stream* "mcponline.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "aacrjournals.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "oxfordjournals.org" [article] ;;oxfordjournals
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "springerlink.com" [article]
  (url-postfix-pdf-stream (:url article)
                          :postfix "fulltext.pdf")) ;;TODO: not working

(defmethod pdf-stream* "cshlp.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "bmj.com" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "sciencedirect.com" [article]
  (without-js
   (let [start (:url article)
         page (.getPage client start)]
     (.getInputStream
      (.openConnection
       (URL. (.getAttribute (.getElementById page "pdfLink") "pdfurl")))))))

(defmethod pdf-stream* "physiology.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "biomedcentral.com" [article]
  (doi-pdf-stream article))

(defmethod pdf-stream* "nature.com" [article]
  (url-to-stream
   (URL.
    (substitute (str (:url article)) {".html" ".pdf" "full" "pdf"}))))

(defmethod pdf-stream* "sciencemag.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "pnas.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "genomebiology.com" [article]
  (doi-pdf-stream article))

(defmethod pdf-stream* "jneurosci.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "jbc.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "jeccr.com" [article]
  (doi-pdf-stream article))

(defmethod pdf-stream* "jcheminf.com" [article]
  (doi-pdf-stream article))

(defmethod pdf-stream* "plantcell.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "plantphysiol.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "ahajournals.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "endojournals.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defmethod pdf-stream* "aspetjournals.org" [article]
  (url-postfix-pdf-stream (:url article)))

(defn pdf-stream [article]
  ;;TODO: perhaps other ways of getting URL
  (binding [client (WebClient. BrowserVersion/FIREFOX_3_6)]
   (if-let [url (follow-doi (:doi article))]
     (pdf-stream*
      (assoc article :url url)))))

