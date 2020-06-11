(ns appengy.socket_test
  (:import [java.io ByteArrayInputStream ByteArrayOutputStream OutputStreamWriter
            PushbackReader InputStreamReader PrintWriter])
  (:require [clojure.tools.reader.edn :as edn])
  (:use clojure.test
        [clojure.tools.reader.reader-types :only [input-stream-push-back-reader input-stream-reader string-reader]]
        [clojure.string :only [join]]
        clojure.tools.logging
        appengy.socket
        appengy.util
        [clojure.java.io :only [output-stream input-stream delete-file output-stream]]))

(defn data-input-stream [& s]
  (input-stream (.getBytes (join " " (map pr-str s)) "UTF-8")))

(defn data-output-stream []
  (ByteArrayOutputStream.))

(deftest test-utf8 []
  (let [v "Helloñ"
        os (data-output-stream)
        out (PrintWriter. (OutputStreamWriter. os "UTF-8") true)]
    (write out v)
    (is (= v (edn/read (PushbackReader. (InputStreamReader. (input-stream (.toByteArray os)))))))))

(defprotocol IsSocket
  (getOutputStream [this])
  (getInputStream [this])
  (isClosed [this])
  (getRemoteSocketAddress [this]))

(deftest edn-stream []
  (let [d0 12
        d1 [1 2 3]
        d2 {:a 1 :b 2 :c 3}]
    (with-open [iss (data-input-stream d0 d1 d2)]
      (let [isr (input-stream-push-back-reader iss)]
        (is (= d0 (edn/read isr)))
        (is (= d1 (edn/read isr)))
        (is (= d2 (edn/read isr)))))))

(deftest test-init-socket []
  (let [m1 [1 2 3]
        m2 {:cmd "Helloñ"}
        in (data-input-stream m1 m2)
        out (data-output-stream)
        closed (atom false)]
    (init-socket
     (reify IsSocket
       (getInputStream [this] in)
       (getOutputStream [this] out)
       (isClosed [this] @closed)
       (getRemoteSocketAddress [this] (java.net.InetSocketAddress. "127.0.0.1" 9090)))
     (reify Handler
       (on-open [this info sendfn sess] (when-not (= (:host info) "localhost")
                                          :close))
       (on-close [this info sendfn sess] )
       (on-message [this info sendfn sess data] (sendfn data))
       (on-error [this info sendfn sess ex] )))
    (Thread/sleep 300)
    (is (= (str (pr-str m1) "\n" (pr-str m2) "\n")
           (str out)))))

(defn make-handler [c out]
  (reify Handler
    (on-open [this info sendfn sess] (reset! c sendfn))
    (on-close [this info sendfn sess] )
    (on-message [this info sendfn sess data] (swap! out conj data))
    (on-error [this info sendfn sess ex] (.printStackTrace ex))))

(deftest test-server-client []
  (let [sh (atom nil)
        ch (atom nil)
        s-out (atom [])
        c-out (atom [])
        server-handler (make-handler sh s-out)
        client-handler (make-handler ch c-out)
        s (make-server 9090 server-handler)
        c (make-client "127.0.0.1" 9090 client-handler)]
    (Thread/sleep 50)
    (@sh [1 2 3])
    (@ch [3 2 1])
    (Thread/sleep 50)
    (is (= [[1 2 3]] @c-out))
    (is (= [[3 2 1]] @s-out))
    (c)
    (s)))