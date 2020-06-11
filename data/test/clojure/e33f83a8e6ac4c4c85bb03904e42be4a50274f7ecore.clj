(ns bashpipe.core
  (:require [clojure.java.io :as io]
            [clojure.java.shell :as shell]))


(defn- run [cmd]
  "Used to build the long lived bash process."
  (let [string-array ^"[Ljava.lang.String;" (into-array String cmd)
        builder (ProcessBuilder. string-array)
        process (.start builder)]
    {:out (.getInputStream process)
     :in (.getOutputStream process)
     :err (.getErrorStream process)
     :process process}))


(defonce bash (run ["bash"]))
(defonce bash-lock (Object.))
(defonce pipe-path (clojure.string/trim
                    (:out (shell/sh "mktemp" "-u" "-t" "bashpipe"))))

(shell/sh "mkfifo" pipe-path)


(defn- send! [command]
  (let [stream ^java.io.OutputStream (:in bash)]
    (io/copy (java.io.StringReader. (str command "; echo -n $? > " pipe-path "\n"))
             stream)
    (.flush stream)))


(defn- read-stream [^java.io.InputStream stream]
  (let [avail (.available stream)
        bytes (byte-array avail)]
    (.read stream bytes)
    (String. bytes)))


(defn- read-out []
  (read-stream (:out bash)))


(defn- read-err []
  (read-stream (:err bash)))


(defn sh [& args]
  "Passes the given arguments to bash.

Returns a map containing output of the command in :out and :err
  and the exit code in :exit."
  (locking bash-lock
    (send! (apply str args))
    (let [exit-code (Long/decode (slurp pipe-path))]
      {:exit exit-code
       :out (read-out)
       :err (read-err)})))
