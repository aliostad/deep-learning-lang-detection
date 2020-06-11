(ns reval.net
  (:import (java.io PrintWriter InputStreamReader PushbackReader)
           (java.net Socket ServerSocket)))

(defn input-stream
  "Returns the (Clojure-friendly) input stream of socket"
  [socket]
  (-> socket (.getInputStream) (InputStreamReader.) (PushbackReader.)))

(defn output-stream
  "Returns the (Clojure-friendly) output stream of socket"
  [socket]
  (-> socket (.getOutputStream) (PrintWriter.)))

(defmacro io-to-socket
  "Execute body with *in* and *out* bound to the socket input/output streams"
  [socket & body]
  (let [in (gensym), out (gensym)]
    `(with-open [~in  (input-stream ~socket)
                 ~out (output-stream ~socket)]
       (binding [*in*  ~in
                 *out* ~out]
         ~@body))))

(defn streams
  "Return a map (keys -> :in :out) with the input/output streams of the socket"
  [socket]
  {:in  (input-stream socket)
   :out (output-stream socket)})

(defn str-socket
  "Return a string representation of the socket, in the form:
  \"[ip_address:port]\""
  [socket]
  (str "[" (.getInetAddress socket) ":"
       (if (instance? Socket socket) (.getPort socket) (.getLocalPort socket))
       "]"))
