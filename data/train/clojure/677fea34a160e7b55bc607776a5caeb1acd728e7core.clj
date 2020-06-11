(ns netcat.core
   (:import (java.io BufferedReader InputStream InputStreamReader OutputStream PrintWriter)
            (java.net ServerSocket Socket))
   (:use [netcat.streamtransferer]
         [clojure.tools.cli :only [cli]])
   (:gen-class))

(defn transfer-streams
   [socket & {:keys [inbound-stream]
              :or {inbound-stream true}}]
   (if inbound-stream
      (let [input (new BufferedReader (new InputStreamReader (.getInputStream socket)))
            output (System/out)]
         (stream-transferer input output))
      (let [input (new BufferedReader (new InputStreamReader (System/in)))
            output (new PrintWriter (.getOutputStream socket))]
         (stream-transferer input output))))

(defn connect
   "Start communication to host 'host' and port 'port'."
   [host port & {:keys [verbose]
                 :or {verbose false}}]
   (let [socket (new Socket host port)]
      (when verbose (println (str "Connecting to " host " port " port)))
      (transfer-streams socket :inbound-stream false)))

(defn listen
   "Listen to communication on port 'port'."
   [port & {:keys [verbose]
            :or {verbose false}}]
   (let [server (new ServerSocket port)]
      (try (when verbose (println (str "Listening at port " port)))
           (let [socket (.accept server)]
              (when verbose (println "Accepted"))
              (transfer-streams socket :inbound-stream true))
           (finally (.close server)))))

(defn -main
   "I don't do a whole lot ... yet."
   [& args]
   (let [[options args banner]
         (cli args 
              ["--help" "Show Help" :flag true :default false]
              ["-h" "--host" "Hostnaime" :default "localhost"]
              ["-p" "--port" "Port" :default 1234 :parse-fn #(Integer. %)]
              ["-v" "--verbose" "Verbose" :flag true :default false]
              ["-l" "--listen" :flag true :default false])]
      (when (:help options)
         (println banner)
         (System/exit 0))
      (if (:listen options)
         (listen (:port options) :verbose (:verbose options))
         (connect (:host options) (:port options) :verbose (:verbose options)))))

