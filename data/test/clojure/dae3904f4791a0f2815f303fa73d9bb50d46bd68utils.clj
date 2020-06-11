(ns learnengl.utils
  (:require
    clojure.contrib.io
    clojure.java.io
    clojure.java.shell
    clojure.string
    [clj-time.core :as time]
    [clj-time.format :as time-format]
    [cheshire.core :as json]
    [ring.util.codec :as codec]
    [clj-http.client :as client])
  (:import java.io.PushbackReader)
  ;(:import java.net.InetAddress)
  ;(:import java.net URLEncoder)
  (:import java.io.FileReader))

(defn gethostname []
  (let [full-name (:out (clojure.java.shell/sh "hostname"))]
    (clojure.string/trim-newline
      (first (clojure.string/split full-name #"\.")))))

;(defn encode-str-utf8 [s]
;  (URLEncoder/encode s "UTF-8")

;(defn ver->int [v]
;  (map read-string (clojure.string/split v #"\.")))


;(defn upload-movie [m]
;  (client/post "http://movielex.com/api/put-movie" {:form-params m :content-type :json}))

;(defn upload-movie-from-file [fname]
;  (if (.exists (clojure.contrib.io/as-file fname))
;    (if-let [ms (load-file fname)]
;      (map upload-movie ms))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(def text1 "This is an example text. When you want to add a translation word you have to use a certain syntax. Otherwise it would be impossible to manage the translated words. You may use the example and add more text as you like.")

(def ignored-words #{"." "," "!" "?" "This" "is" "an" "a" "the" "and" "to" "I" "it" })

(defn in?
  "true if seq contains elm"
  [seq elm]
  (some #(= elm %) seq))

(defn split-with-delim [s d]
  (clojure.string/split s (re-pattern (str "(?=" d ")|(?<=" d ")"))))

(defn not-blank? [s]
  (not (clojure.string/blank? s)))

(defn split-by-words [s]
  (filter not-blank? (split-with-delim s #"[\s\.,!\?]")))

(defn process-word-pair [p]
  (if (clojure.string/blank? (second p))
    (first p)
    (str "[" (first p) "|" (second p) "]")))

(def google-translate-url "http://translate.google.co.il/translate_a/t?client=x&text=%s&sl=%s&tl=%s")

(defn translate-text-raw [text sl tl]
  (let [ url (format google-translate-url text sl tl)
         resp (client/get url {:decode-body-headers true :as :auto})]
    resp))

(defn translate-words [text sl tl]
  (let [ resp (translate-text-raw text sl tl)
         body (:body resp)]
    (json/parse-string body true)))

(defn process-ignored-words [ignored-words orig trans]
  (if (in? ignored-words orig)
    ""
    trans))

(defn translate [sl tl text]
  (let [t (translate-words text sl tl)
        s (first (t :sentences))
        trans (:trans s)
        orig  (:orig s)]
    [orig trans]))

(defn translate-ignore [ignored-words sl tl orig]
  (if (in? ignored-words orig)
    [orig ""]
    (translate sl tl orig)))

(defn translate-text [ignored-words sl tl text]
  (doall
    (map (partial translate-ignore ignored-words sl tl) (split-by-words text))))

(defn translation-pairs-to-string [ pairs ]
  (clojure.string/join " " (map process-word-pair pairs)))

