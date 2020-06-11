(ns malletfn.fileutil
  (:import (java.io File 
             ObjectOutputStream FileOutputStream BufferedOutputStream 
             PrintStream ObjectInputStream FileInputStream)))

(defn basename [filename]
  (first (.split filename "\\.")))

(defn serialize-object [obj file]
  (let [oos (new ObjectOutputStream
              (new BufferedOutputStream
                (new FileOutputStream file)))]
    (try (.writeObject oos obj)
      (finally (.close oos)))))

(defn deserialize-object [file]
  (let [ois (new ObjectInputStream
              (new FileInputStream file))]
    (try (.readObject ois)
      (finally (.close ois)))))

(defn with-file-output-stream [file fun]
  (let [fos (new PrintStream
;              (new BufferedOutputStream
                (new FileOutputStream file))]
    (try (fun fos)
      (finally (.close fos)))))


(defmacro with-output-log 
  "Usage: 
     (with-output-log \"doblah.log\" 
       (println \"blah\"))"
  
  [logfile & body]
  `(let [~'save-o *out*
         ~'save-e *err*
         ~'os (writer ~logfile)]
     (try
       (set! *out* ~'os)
       (set! *err* ~'os)
       (println "###" (str (new java.util.Date)) '~@body)
       (do ~@body)
       (finally
         (println "###" (str (new java.util.Date)) '~@body)
         (.close ~'os)
         (set! *out* ~'save-o)
         (set! *err* ~'save-e)))))


;;(basename "lda-model.ser")
;;(with-file-output-stream  "blah.blah.txt" (fn [os] (.println os "blah")))
