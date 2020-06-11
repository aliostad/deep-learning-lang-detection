(ns ^{:doc "Local Profiler, runs on the same machine as the actual profiled VM"}
  local-profiler
  (use [profiler-util])
  (:import 
   [java.net ServerSocket SocketException]
   [java.io File InputStream Closeable IOException]
   [java.util.concurrent ArrayBlockingQueue TimeUnit]))

(def allThreadCommonLog (atom '()))

;; as *out* for other threads are not bound to out http://stackoverflow.com/questions/15197914/output-is-sent-to-console-instead-of-repl-when-using-threads-in-eclipse-counterc
(defn- printA [message]
  (swap! allThreadCommonLog conj message))

(defn- on-thread [f]
  (doto (Thread. ^Runnable f)
    (.start)))

(defn- close-socket [^Closeable s]
  (try 
    (if-not (nil? s)
      (.close s))
    (catch Exception e (.stackTrace e))))

(defn- write-output [conn profiler]
  (do 
  (on-thread 
   #(
     (let [os (.getOutputStream conn)]
       (do
         (loop [command (.get-command profiler)]
           (if-not (nil? command)
             (do
               (printA (str "writing to stream " command))
               (.write os (.getBytes (str (clojure.string/replace command "\n" " ") " \n")))
               (.flush os)
               (recur (.get-command profiler)))
             (printA "noting to write")))))))))

(defn- read-input [is profiler f]
  (let [buffer (byte-array 4096)]
    (try 
      (loop [read (.read is buffer)]
        (when (> read 0)
          (do
            (printA (String. buffer 0 read))
            (f (String. buffer 0 read)))
          (recur (.read is buffer))))
      (catch SocketException e (print "Socket closed from other side, time to go")))))

(defn- accept-connection [socket profiler]
  (on-thread #(
               (try
                  (let [conn (.accept socket)]
                    (reset! (:connection profiler) conn)
                    (write-output conn profiler)
                    (read-input (.getInputStream conn) profiler (fn[x] (.set-response profiler x)))) 
               (catch NullPointerException e (print "something was closed making the other guys null here")))))
  (print "started work to accept connections"))


(defn- accept-profiler-connection [socket profiler]
  (on-thread #(
               (try
                  (let [conn (.accept socket)]
                    (read-input (.getInputStream conn) profiler (fn[x] (.set-profiler-response profiler x))))
               (catch NullPointerException e (print "something was closed making the data plane disappear")))))
  (print "started work to accept profiler data"))


(defn- load-agent [profiler profiledVm]
  (on-thread #(
               (try
                 (.loadAgent  profiledVm
                              (str (System/getProperty "user.dir") "/profiler/agent/target/custom-agent.jar")
                              (.toString (.get-port profiler)))
               (catch IOException e 
                 (print "Problems in the agent lifecycle, could be normal too in case there is an abnormal VM termination")
                 (.printStackTrace e))))))

(defn- start-control-server [profiler]
  "starts the profiler server and return the profiler"
  (print "server port opened at " (.get-port profiler) "\n")
  (accept-connection (:socket profiler) profiler)
  profiler)

(defn- stop-control-server [profiler]
  "stops the profiler server and return the profiler"
  (do
    (close-socket @(:connection profiler))
    (close-socket (:socket profiler))
    profiler))

(defn- combine-all[x] 
  (if-not (nil? (.peek x)) 
    (let [y (.poll x)]
      ( str y (combine-all x)))))

(defn clear-logs []
  (reset! allThreadCommonLog '()))

(defn show-logs [] allThreadCommonLog)

(defn- add-records
  ([]  
     (add-records 
      (filter 
       (fn[y](not (.startsWith y "writing to stream"))) 
       @allThreadCommonLog)))
  ([x] 
     (if-not (nil? x) 
       (str (last x) 
            (add-records (butlast x))) "")))

(defn- get-well-formed-response [response-str]
  (let [boundary "\n------------End---------\n"]
    (if (and (.startsWith response-str boundary) 
             (.endsWith response-str boundary)
             (> (.length response-str) (.length boundary)))
      (subs response-str (.length boundary) (- (.length response-str) (.length boundary)))
      nil)))

(defprotocol Profiler
  (start-agent [this profiledVM])
  (stop-agent [this])
  (run-command [this command])
  (get-result [this])
  (get-profiler-result [this])
  (get-port [this])
  (profile-locations [this locations])
  (set-profiler-response [this response])
  (unprofile [this]))

(defprotocol AsyncCommandRunner
  (set-response [this response])
  (get-response [this])
  (get-command [this])
  (set-command [this command]))

(defrecord LocalProfiler [socket connection commandQ responseQ dataPlaneQ lastIncompleteResponse dataPlaneSocket]

  AsyncCommandRunner
  (set-response [this response] (.offer (:responseQ this) response))
  (get-response [this] (.take (:responseQ this)))
  (set-command [this command] (.offer (:commandQ this) command))
  (get-command [this] (.take (:commandQ this)))

  Profiler
  (start-agent [this profiledVM] 
    (.set-command this (slurp (str (System/getProperty "user.dir") "/profiler/commands/basicInfo.js")))
    (.set-command this (slurp (str (System/getProperty "user.dir") "/profiler/commands/jmxInfo.js")))
    (start-control-server this)
    (load-agent this profiledVM))

  (stop-agent [this] 
    (do
      (.set-command this "bye")
      (stop-control-server this)))

  (profile-locations [this locations]
    (let [to-instrument (instrument-classes (find-classes locations))
          class-regex (:regex to-instrument)
          index-file (:indexFile to-instrument)
          class-file (:classFile to-instrument)
          ]
      (do
        (println locations class-regex index-file class-file)
        (let [dataPlaneSocket (ServerSocket.)]
          (do 
            (.bind dataPlaneSocket nil)
            (reset! (:dataPlaneSocket this) dataPlaneSocket)
            (accept-profiler-connection dataPlaneSocket this)
            (.set-command this 
                          (str 
                           "profile-classes " 
                           class-regex " "
                           index-file " "
                           class-file " "
                           (.getLocalPort @(:dataPlaneSocket this)))))))))

  (unprofile [this]
    (.set-command this "stop-profiling"))

  (run-command [this command]
    (if-not (.startsWith command "get-all-entries")
      (do 
        (.clear responseQ)
        (reset! lastIncompleteResponse "")))
      (.set-command this command))

  (set-profiler-response [this response] (.offer (:dataPlaneQ this) response))

  (get-result [this]
    (let [resultTillNow (str @lastIncompleteResponse (combine-all responseQ))]
      (if (nil? (get-well-formed-response resultTillNow))
        (do
          (reset! lastIncompleteResponse resultTillNow)
          nil)
        
        (do 
          (reset! lastIncompleteResponse "")
          (get-well-formed-response resultTillNow)))))

  (get-profiler-result [this]
    (let [resultTillNow (combine-all dataPlaneQ)]
      (if (nil? resultTillNow) nil 
          (clojure.string/replace resultTillNow #"\n" "~#"))))

  (get-port [this] (.getLocalPort socket)))


(defn create-profiler []
  (let [socket (ServerSocket. )]
    (.bind socket  nil)
    (LocalProfiler. socket (atom nil) (ArrayBlockingQueue. 10) (ArrayBlockingQueue. 100) (ArrayBlockingQueue. 300) (atom "") (atom nil))))

(comment
  regex is java regex like "org/eclipse/jetty/.*"
  (.set-command profiler "profile-classes <regex> <indexfile> <classfile>")
 (.set-command profiler "stop-profiling")
 (.set-command profiler "get-all-entries")
 (.clear (.responseQ (get-profiler "5127")))
)
