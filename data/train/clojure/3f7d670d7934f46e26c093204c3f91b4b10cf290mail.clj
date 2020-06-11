(ns mail-xls-sheets-clj.mail
  (:import [javax.mail Flags$Flag Session]))

;; ; https://github.com/javaee/javamail/blob/cbf47f61945bde02301e2f9ddc4e2c4a1b7fbb72/demo/src/main/java/msgshow.java
;; enable https://myaccount.google.com/lesssecureapps

(def session (javax.mail.Session/getInstance (System/getProperties) nil))

#_(.setDebug session true)

(def store (.getStore session "imaps"))

(.connect store "imap.gmail.com" 993 username password)

(def folder (.getFolder (.getDefaultFolder store) "INBOX"))

(.open folder javax.mail.Folder/READ_WRITE)

(.getMessageCount folder)

(def message (.getMessage folder 1))

(comment "archiving in gmail"
         (.setFlag message Flags$Flag/DELETED true)
         (.close folder true))

(.getFrom message)

(.getContent message)

(.getSubject message)

(.getCount (.getContent message))

(.getContentType (.getBodyPart (.getContent message) 0))

(for [i (range (.getCount (.getContent message)))]
  (-> message .getContent (.getBodyPart i) .getContentType))

(for [i (range (.getCount (.getContent message)))]
  (-> message .getContent (.getBodyPart i) .getDisposition))

(def body-part (.getBodyPart (.getContent message) 1))

(def is-csv (re-find #"^TEXT/CSV" (.getContentType body-part)))

#_(.saveFile body-part (java.io.File. "/tmp/x"))

(def input-stream (.getInputStream body-part))

(if is-csv
  (slurp input-stream))

(if (not is-csv)
  (def zip-input-stream (java.util.zip.ZipInputStream. input-stream))

  (def entry (.getNextEntry zip-input-stream))

  (def output-stream (java.io.ByteArrayOutputStream.))

  (time (clojure.java.io/copy zip-input-stream output-stream))

  (.size output-stream)

  (count (str output-stream))

  (spit "/tmp/x" (str output-stream)))
