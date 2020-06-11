(ns multimux.connection
  (:require [taoensso.timbre :as log]
            [clojure.core.async :as async])
  (:import [com.jcraft.jsch JSch JSchException Session Channel]
           [java.net Socket]
           [java.io OutputStream InputStream BufferedReader InputStreamReader]
           [java.lang Process ProcessBuilder ProcessBuilder$Redirect]))

(defprotocol ConnectionProtocol
  (open [c] "Open the connection")
  (close [c] "Close the connection")
  (input-stream [c] "Get the input stream")
  (output-stream [c] "Get the output stream"))

;; Connection over a tcp socket
(defrecord SocketConnection [^String server ^int port ^Socket socket])

(defn create-socket-connection [server port]
  (->SocketConnection server port nil))

(defn open-socket-connection [conn]
  (try
    (assoc conn :socket (Socket. (:host conn) (:port conn)))
    (catch java.net.ConnectException e
      (log/warn "Connection failure" e)
      nil)))

(defn close-socket-connection [conn]
  (when (:socket conn)
    (.close (:socket conn))
    conn))

(defn get-socket-connection-input-stream [conn]
  (.getInputStream (:socket conn)))

(defn get-socket-connection-output-stream [conn]
  (.getOutputStream (:socket conn)))

(extend SocketConnection
  ConnectionProtocol
  {:open open-socket-connection
   :close close-socket-connection
   :input-stream get-socket-connection-input-stream
   :output-stream get-socket-connection-output-stream})


;; Connection over ssh to a unix socket
(defrecord SSHUnixConnection [^String username ^String password ^String host ^Session session
                              ^Channel channel ^OutputStream output-stream ^InputStream input-stream
                              ^InputStream error-stream])

(def jsch (JSch.))
(def unix-socket-path "/tmp/mm.sock")
(def socat-command (str "socat STDIO UNIX-CONNECT:" unix-socket-path))

(defn create-ssh-session [username password host & {:keys [host-key user-info]}]
  (let [session (.getSession jsch username host)
        known-host-repository (.getHostKeyRepository session)]
    (when host-key
      (log/warn "Adding ssh host key for" (.getHost session))
      (.add known-host-repository host-key user-info))
    (.setPassword session password)
    (try
      (.connect session 20000)
      session
      (catch JSchException e
        (if (and (.startsWith (.getMessage e) "UnknownHostKey") (not host-key) (not user-info))
          (create-ssh-session username password host :host-key (.getHostKey session)
                              :user-info (.getUserInfo session))
          (log/error e))))))

(defn ssh-exec-channel [session command]
  (let [channel (.openChannel session "exec")
        input-stream (.getInputStream channel)
        output-stream (.getOutputStream channel)
        error-stream (.getErrStream channel)]
    (async/thread
      (let [reader (BufferedReader. (InputStreamReader. error-stream))]
        (loop []
          (when-let [line (.readLine reader)]
            (log/warn "SSH stderr:" line)
            (recur)))))
    (.setCommand channel command)
    (.connect channel)
    [channel input-stream output-stream error-stream]))

(defn create-ssh-unix-connection [username password host]
  (->SSHUnixConnection username password host nil nil nil nil nil))

(defn open-ssh-unix-connection [conn]
  (if-let [session (create-ssh-session (:username conn) (:password conn) (:host conn))]
    (let [[channel input output error] (ssh-exec-channel session socat-command)]
      ;; TODO: add protocol message to check for connection
      (assoc conn :session session :channel channel :input-stream input :output-stream output :error-stream error))))

(defn close-ssh-unix-connection [conn]
  (.disconnect (:channel conn))
  (.disconnect (:session conn)))

(defn get-ssh-unix-connection-input-stream [conn]
  (:input-stream conn))

(defn get-ssh-unix-connection-output-stream [conn]
  (:output-stream conn))

(extend SSHUnixConnection
  ConnectionProtocol
  {:open open-ssh-unix-connection
   :close close-ssh-unix-connection
   :input-stream get-ssh-unix-connection-input-stream
   :output-stream get-ssh-unix-connection-output-stream})
