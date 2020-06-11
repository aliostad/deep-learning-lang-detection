(ns download-via-xhrio-example.xhrio
  (:require [clojure.browser.event :as event]
            [clojure.browser.net :as net]
            [cljs.reader :refer [read-string]])
  (:import [goog.net.XhrIo ResponseType]))

(defn request
  "Send Asynchronous request via Xhrio"
  [url method handler & {:keys [body headers]}]
  (let [xhrio (net/xhr-connection)]
    ;; you have to set response type if you want to manage response as binary.
    (.setResponseType xhrio ResponseType.ARRAY_BUFFER)
    (event/listen xhrio
                  :success
                  (fn [event]
                    ;; you have to use #getResponse when you set response type.
                    ;; see: https://google.github.io/closure-library/api/goog.net.XhrIo.html
                    (handler (.getResponse (.-target event)))))
    (net/transmit xhrio
           url
           (.toLowerCase (name method))
           body
           (clj->js (merge headers {})))))
