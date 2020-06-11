(ns ring-core-cn.util.io
  "处理IO的工具函数"
  (:require [clojure.java.io :as io])
  (:import [java.io
            PipedInputStream
            PipedOutputStream
            ByteArrayInputStream
            File
            Closeable
            IOException]))

(defn piped-input-stream
  "
  例子
  (piped-input-stream
    (fn [ostream]
      (spit ostream \"Hello\")))
  "
  {:added "1.1"}
  [func]
  (let [input (PipedInputStream.)
        output (PipedOutputStream.)]
    (.connect input output)
    (future
      (try
        ;; 用函数处理输出
        (func output)
        (finally (.close output))))
    input))

(defn string-input-stream
  "字符串转化成ByteArrayInputStream"
  {:added "1.1"}
  ([^String s]
     (ByteArrayInputStream. (.getBytes s)))
  ;; 带自定义编码
  ([^String s ^String encoding]
     (ByteArrayInputStream. (.getBytes s encoding))))

(defn close!
  "确保流被关闭 处理任何异常"
  {:added "1.2"}
  [stream]
  (when (instance? java.io.Closeable stream)
    (try
      (.close ^java.io.Closeable stream)
      (catch IOException _ nil))))

(defn last-modified-date
  "返回文件最后修改日期"
  {:added "1.2"}
  [^File file]
  (-> (.lastModified file)
      (/ 1000)
      (long)
      (* 1000)
      (java.util.Date.)))
