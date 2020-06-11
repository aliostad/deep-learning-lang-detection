(ns chat-app.util
  (:import [java.io ObjectInputStream ObjectOutputStream IOException]))

(defn get-io-streams
  "Opens up the input and output streams on a network socket and wraps them in an
   ObjectInputStream and ObjectOutputStream respectively.

   The return from this function will be a map where :out is the output stream and :in is the
   input stream. If the function fails, nil will be returned"
  [socket]
  (try
    {:out (ObjectOutputStream.  (.getOutputStream socket))
     :in  (ObjectInputStream.   (.getInputStream socket))}
    (catch IOException e nil)))

(defn uuid
  "Generates a unique identifier"
  []
  (java.util.UUID/randomUUID))

(defmacro to-err
  "Executes all print statements where stdout has been redirected to stderr"
  [& forms]
  `(binding [*out* *err*]
    ~@forms))
