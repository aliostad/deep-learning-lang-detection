(ns tattle.client
  (:import [java.net Socket]
           [java.io  InputStream PrintWriter InputStreamReader BufferedReader]))

(defn- read-stream [^InputStream ins]
  (let [br (clojure.java.io/reader ins)]
    (clojure.string/join "\n" (line-seq br))))

(defn connect [{:keys [host port]}]
  (let [socket (Socket. host port)
        in (BufferedReader. (InputStreamReader. (.getInputStream socket)))
        out (PrintWriter. (.getOutputStream socket))
        conn (ref {:in in :out out :socket socket})]
    conn))

(defn write [conn msg]
  (doto (:out @conn)
    (.write (str msg "\r\n"))
    (.flush))
  (when-not (.isClosed (:socket @conn))
    (.readLine (:in @conn))))
