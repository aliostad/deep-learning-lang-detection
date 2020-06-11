(ns apm.udp
    (:require [clojure.string :as s]
              [apm.dispatch :as dispatch])
    (:use aleph.udp aleph.formats lamina.core))

(defn listen
    [port]
    @(udp-socket {:port port}))

(defn- remove-empty
    [uri-parts]
    (remove empty? uri-parts))

(defn- remove-newlines
    [uri-parts]
    (map #(s/replace %1 "\n" "") uri-parts))

(defn- try-dispatch
    [uri-parts]
    (when-not (empty? uri-parts)
        (dispatch/dispatch :post uri-parts)))

(defn recv-and-dispatch
    [usock]
    (-> @(read-channel us)
        (:message)
        (bytes->string)
        (s/split #"/")
        (remove-empty)
        (remove-newlines)
        (try-dispatch)))

