(ns illusioniste
  "Wrapper over im4java, a Java ImageMagick wrapper."
  (:import [org.im4java.core IMOperation ConvertCmd]
           [org.im4java.process Pipe]
           [java.io ByteArrayOutputStream ByteArrayInputStream]
           [javax.imageio ImageIO]))

(defn- piped-operation [fn]
  (-> (IMOperation.)
      (.addImage (into-array String ["-"]))
      fn
      (.addImage (into-array String ["-"]))))

(defn- piped-command [input output]
  (let [pipe-in (Pipe. input nil)
        pipe-out (Pipe. nil output)
        cmd (ConvertCmd.)]
    (.setInputProvider cmd pipe-in)
    (.setOutputConsumer cmd pipe-out)
    cmd))

(defn image-operation [input fn]
  (let [output-stream (ByteArrayOutputStream.)
        input-stream (ByteArrayInputStream. input)
        cmd (piped-command input-stream output-stream)
        op (piped-operation fn)]
    (try
      (.run cmd op (into-array []))
      (.toByteArray output-stream)
      (finally
       (.close input-stream)
       (.close output-stream)))))

(defmacro transform-image
  "Perform a series of transformations on the given image."
  [image & body]
  `(image-operation ~image
                    (fn [op#]
                      (-> op#
                          ~@(map (fn [expr] (cons '. expr))
                                 body)))))
