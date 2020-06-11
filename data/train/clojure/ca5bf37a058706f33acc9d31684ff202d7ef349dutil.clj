(ns clj-http-lite-doc-cn.util
  (:require [clojure.java.io :as io])
  (:import (java.io ByteArrayInputStream ByteArrayOutputStream InputStream)
           (java.net URLEncoder URLDecoder)
           (java.util.zip InflaterInputStream DeflaterInputStream
                          GZIPInputStream GZIPOutputStream)))

(defn utf8-bytes
  "返回utf8的字节码"
  [#^String s]
  (.getBytes s "UTF-8"))

(defn utf8-string
  "返回utf8的字符串"
  [#^"[B" b]
  (String. b "UTF-8"))

(defn url-decode
  "url解码"
  [encoded & [encoding]]
  ;; 默认是utf8
  (URLDecoder/decode encoded (or encoding "UTF-8")))

(defn url-encode
  "url编码"
  [unencoded]
  (URLEncoder/encode unencoded "UTF-8"))

(defn base64-encode
  "把数组字节编码成base64"
  [unencoded]
  ;; 将字节数组转换为一个字符串
  (javax.xml.bind.DatatypeConverter/printBase64Binary unencoded))

(defn to-byte-array
  "base64编码"
  [is]
  (let [chunk-size 8192
        baos (ByteArrayOutputStream.)
        ;; 创建一个byte数组
        buffer (byte-array chunk-size)]
    ;; is 读取到buffer块
    (loop [len (.read ^InputStream is buffer 0 chunk-size)]
      ;; 确保读取到值
      (when (not= -1 len)
        ;; 保存到buffer
        (.write baos buffer 0 len)
        ;; 重复
        (recur (.read ^InputStream is buffer 0 chunk-size))))
    (.toByteArray baos)))

(defn gunzip
  "返回一个gunzip版本的字节数组"
  [b]
  (when b
    (if (instance? InputStream b)
      (GZIPInputStream. b)
      (to-byte-array (GZIPInputStream. (ByteArrayOutputStream. b))))))

(defn gzip
  "返回一个gzip版本的字节数组"
  [b]
  (when b
    (let [baos (ByteArrayOutputStream.)
          gos (GZIPInputStream. baos)]
      (io/copy (ByteArrayOutputStream. b) gos)
      (.close gos)
      (.toByteArray baos))))

(defn inflate
  "返回一个zlib版本的压缩字节数组"
  [b]
  (when b
    (to-byte-array (InflaterInputStream. (ByteArrayOutputStream. b)))))

(defn deflate
  "返回一个zlib的解压缩版本"
  [b]
  (when b
    (to-byte-array (DeflaterInputStream. (ByteArrayOutputStream. b)))))
