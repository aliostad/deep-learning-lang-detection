(ns clr-socketrepl.client
  (:use [clr-socketrepl.common]))

(defn create-repl [port]
  {:stream (.GetStream (System.Net.Sockets.TcpClient. "127.0.0.1" port))
   :buf-len 256
   :buf (|System.Byte[]|. 256)
   })

(defn send-repl [{:keys [stream buf-len buf]} msg]
  (send-msg stream (str msg "\r\n"))
   (recv-msg stream buf buf-len))

(defn start-repl
  [port]
  (let [repl (create-repl port)]
    (loop []
      (let [res (send-repl repl (.ReadLine *in*))] (println res) (recur)))))

(defn start-client-repl
  [port]
  (with-open [client (System.Net.Sockets.TcpClient. "127.0.0.1" port)
              stream (.GetStream client)
              writer (System.IO.StreamWriter. stream)
              reader (System.IO.StreamReader. stream)]
    (set! (.AutoFlush writer) true)
    (let [write-fn #(.WriteLine *out* %)]
                  (read-eval-print-loop
                   {:reader #(.ReadLine *in*)
                    :writer write-fn
                    :err write-fn
                    :evalfn #(do (.WriteLine writer %) (.ReadLine reader))
                    }))))