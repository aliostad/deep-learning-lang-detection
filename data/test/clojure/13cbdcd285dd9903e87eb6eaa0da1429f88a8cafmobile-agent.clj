;;;; Mobile Agent
;;;;
;;;; This is a default mobile agent. It moves over a predetermined port via TCP.

{:config {:id :mobile
          :communication-method "TCP"
          :port 8002}
 :data {}
 :do-next "do-next"}

(import java.net.Socket)
(import java.io.DataOutputStream)
(import java.io.BufferedOutputStream)

(defn move
  "Jumps to another executor"
  [ip port briefcase]
  (try
    (let [socket (Socket. ip port)
          out-stream (DataOutputStream. (BufferedOutputStream. (.getOutputStream socket)))]
      (.writeUTF out-stream (str briefcase))
      (.flush out-stream)
      (.close out-stream)
      (println " [ suc ] --> Move to" ip ":" port "was successful."))
    (catch Exception e (println "Error: " e))))

(defn do-next
  "This function will run when the agent reaches its destination."
  [briefcase]
  (println "Hello, World!")
  (move "127.0.0.1" (:port (:config briefcase)) briefcase))
