(ns http_server.static.file)

(defprotocol File
  (in-stream [this])
  (out-stream [this])
  (content-type [this])
  (length [this]))

(defn content-range [file start end]
  (let [length   (inc (- end start))
        contents (byte-array length)
        stream   (in-stream file)]
    (.skip stream start)
    (.read stream contents 0 length)
    (.close stream)
    contents))

(defn contents [file]
  (with-open [stream (in-stream file)]
    (let [contents (byte-array (length file))]
      (.read stream contents)
      contents)))

(defn replace-contents [file new-contents]
  (with-open [stream (out-stream file)]
    (.write stream (.getBytes new-contents))
    stream))
