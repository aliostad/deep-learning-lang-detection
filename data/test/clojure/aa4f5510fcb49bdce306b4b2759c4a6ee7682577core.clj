(ns clj-vlc.core
  (:require [clojure.java.shell :refer [sh]]
            [clj-vlc.utils :refer [get-channel run-vlc-cmds-tcp]]))
  (import '(java.net ServerSocket))

(defn start-vlc-server
  ;; returns a channel linked to the vlc server listening on localhost:port
  [port]
  (try (sh "vlc" "--help")(catch Exception e (prn "VLC is not installed") (throw (ex-info "no VLC here!" {}))))
  (let [r (future (sh "cvlc" "--intf" "rc" "--rc-host" (str "localhost:" port)))
        _ (Thread/sleep 300)]
   (get-channel port)))

(defn end-vlc-server
  ;; ends server associated to channel
  [channel]
  (if (= (list "Shutting down." nil) (run-vlc-cmds-tcp channel :shutdown :quit)) 
     true 
     false))  

(defn get-free-port
  ;; returns a free port
  []
  (let [fs (ServerSocket. 0)
        fp (. fs (getLocalPort))
        _ (. fs (close))]
    fp))

(defn available-commands
  ;; return all the VLC --intf rc commands as a keywords list
  [channel]
  (let [s (first (run-vlc-cmds-tcp channel :help))
        mf (memoize (fn [x] (map #(keyword %) (re-seq #"(?<=\| )[a-z][+[_]?[a-z]+]+" x))))]
    (mf s)))


(defn run-vlc-cmds
  ;; run valid vlc cmds (e.g., :add "yourfile" :play :pause) through the channel,
  ;; returns VLC replies as string list
  [channel & cmds]
  (let [fst-cmd? (keyword? (first cmds))
        are-cmds? (clojure.set/subset? (set (filter keyword? cmds)) (set (available-commands channel)))
        conds (and fst-cmd? are-cmds?)]
    (if conds
      (apply run-vlc-cmds-tcp channel cmds)
      (throw (ex-info "Input commands are invalid!" {:invalid cmds})))));; FIXME manage error better than this
