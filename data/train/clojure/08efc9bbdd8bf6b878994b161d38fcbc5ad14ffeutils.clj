(ns com.thoughtworks.codelapse.utils
  (:use  clojure.contrib.io)
  (:import
    (java.io IOException ByteArrayOutputStream File)
    (java.lang RuntimeException)
    (org.apache.commons.exec CommandLine DefaultExecutor ExecuteWatchdog PumpStreamHandler ExecuteException)))

(defn split [str delimiter]
  (seq (.split str delimiter)))

(defn split-on [delimiter str]
  "Like a normal split, but with the delimiter first to allow for partial application"
  (seq (.split str delimiter)))

(defn split-lines [str]
  (seq (.split #"\r?\n" str)))

(defn execute
  "Executes a command-line program, returning stdout if a zero return code, else the
  error out. Takes a list of strings which represent the command & arguments"
  [& args]

  (let [output-stream (new ByteArrayOutputStream)
        error-stream (new ByteArrayOutputStream)
        stream-handler (new PumpStreamHandler output-stream error-stream)
        executor (doto
                  (new DefaultExecutor)
                  (.setExitValue 0)
                  (.setStreamHandler stream-handler)
                  (.setWatchdog (new ExecuteWatchdog 20000)))]

    (try
     (if (= 0 (.execute executor (CommandLine/parse (apply str (interpose " " args)))))
       (.toString output-stream)
       (.toString error-stream))
      (catch Exception e (throw (new RuntimeException (str "Error: " (.getMessage e) "\n. Command:" (apply str (interpose " " args)) "\n. Output Was:" (.toString error-stream)) e))))))

(defn make-temp-dir []
  "Creates a temporary directory that will be cleaned up when the JVM exits"
  (let [temp-file  (File/createTempFile "temp" (Long/toString (System/currentTimeMillis)))]
    (do
      (delete-file temp-file)
      (if (.mkdir temp-file)
        (.getAbsolutePath temp-file)
        (throw (java.io.IOException (str "Could not create directory " (.getAbsolutePath temp-file))))))))

