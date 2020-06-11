(ns job-streamer.console.api
  (:require-macros [cljs.core.async.macros :refer [go go-loop]])
  (:require [cljs.core.async :refer [put! <! chan pub sub unsub-all]]
            [clojure.browser.net :as net]
            [goog.events :as events]
            [goog.string :as gstring]
            [goog.ui.Component]
            [goog.net.ErrorCode]
            [goog.net.EventType])
  (:use [cljs.reader :only [read-string]])
  (:import [goog.events KeyCodes]
           [goog.net EventType]))

(def control-bus-url (.. js/document
                         (querySelector "meta[name=control-bus-url]")
                         (getAttribute "content")))

(defn url-for [path]
  (if (gstring/startsWith path "/")
    (str control-bus-url path)
    path))

(defn handle-each-type [handler response xhrio]
  (if (fn? handler)
    (handler response)
    (.error js/console
            (str (goog.net.ErrorCode/getDebugMessage (.getLastErrorCode xhrio))
                 " from "
                 (.getLastUri xhrio)))))

(defn download [path]
  (set! (.-href js/location) (url-for path)))

(defn request
  ([path]
   (request path :GET nil {}))
  ([path options]
   (request path :GET nil options))
  ([path method options]
   (request path method nil options))
  ([path method body {:keys [handler error-handler format forbidden-handler unauthorized-handler]}]
   (let [xhrio (net/xhr-connection)]

     (when handler
       (events/listen xhrio EventType.SUCCESS
                      (fn [e]
                        (let [res (read-string (.getResponseText xhrio))]
                          (handler res)))))
     (events/listen xhrio EventType.ERROR
                    (fn [e]
                      (let [res (read-string (.getResponseText xhrio))]
                        (cond
                          ;; Unahthorized
                          (= (.getStatus xhrio) 401)
                          ;; TODO: Manage application name.
                          (if (fn? unauthorized-handler)
                            (unauthorized-handler res (.getLastErrorCode xhrio))
                            (set! (.-pathname js/window.location) "/login"))

                          ;; Forbidden
                          (and (= (.getStatus xhrio) 403) (fn? forbidden-handler))
                          (forbidden-handler res (.getLastErrorCode xhrio))

                          :else
                          (cond
                            (fn? error-handler)
                            (error-handler res (.getLastErrorCode xhrio))

                            (map? error-handler)
                            (condp = (.getLastErrorCode xhrio)
                              goog.net.ErrorCode/ACCESS_DENIED  (handle-each-type (:access-denied error-handler) res xhrio)
                              goog.net.ErrorCode/FILE_NOT_FOUND (handle-each-type (:file-not-found error-handler) res xhrio)
                              goog.net.ErrorCode/CUSTOM_ERROR   (handle-each-type (:custom-error error-handler) res xhrio)
                              goog.net.ErrorCode/EXCEPTION      (handle-each-type (:exception error-handler) res xhrio)
                              goog.net.ErrorCode/HTTP_ERROR     (handle-each-type (:http-error error-handler) res xhrio)
                              goog.net.ErrorCode/ABORT          (handle-each-type (:abort error-handler) res xhrio)
                              goog.net.ErrorCode/TIMEOUT        (handle-each-type (:timeout error-handler) res xhrio)))))))
     (.setWithCredentials xhrio true)
     (.send xhrio (url-for path) (.toLowerCase (name method))
            body
            (case format
              :xml (clj->js {:content-type "application/xml"})
              (clj->js {:content-type "application/edn"}))))))

