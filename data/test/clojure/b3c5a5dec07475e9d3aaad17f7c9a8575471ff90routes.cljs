(ns apply.routes
  (:require [accountant.core :as accountant]
            [re-frame.core :refer [dispatch]]
            [secretary.core :as secretary])
  (:require-macros [secretary.core :refer [defroute]]))

;; NOTE: See https://gist.github.com/city41/aab464ae6c112acecfe1
;; NOTE: See http://www.lispcast.com/mastering-client-side-routing-with-secretary-and-goog-history

;; =============================================================================
;; Helpers

(defn- hook-browser-navigation! []
  (accountant/configure-navigation!
   {:nav-handler  #(secretary/dispatch! %)
    :path-exists? #(secretary/locate-route %)}))

;; =============================================================================
;; API

(defn navigate!
  "Trigger HTML5 History navigation to `route`."
  [route]
  (accountant/navigate! route))

(declare prompt)

(defn prompt-uri
  "Produce the URI for a given `prompt-key`."
  [prompt-key]
  (let [s (namespace prompt-key)
        p (name prompt-key)]
    (cond
      ;; special case
      (= prompt-key :overview/welcome) "/"
      ;; not a prompt
      (nil? s)                         (str "/" p)
      ;; normal case
      :otherwise                       (prompt {:section s :prompt p}))))

(defn app-routes []

  (defroute overview "/" []
    (dispatch [:prompt/nav :overview/welcome]))

  (defroute complete "/complete" []
    (dispatch [:complete/nav]))

  (defroute prompt "/:section/:prompt" [section prompt]
    (dispatch [:prompt/nav (keyword section prompt)]))

  (hook-browser-navigation!)

  (accountant/dispatch-current!))
