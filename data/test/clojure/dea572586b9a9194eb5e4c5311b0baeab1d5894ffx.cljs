(ns starcity.fx
  (:require [re-frame.core :refer [reg-fx]]
            [re-frame.router :as router]
            [re-frame.fx :refer [register]]
            [re-frame.interop :refer [set-timeout!]]
            [re-frame.loggers :refer [console]]
            [starcity.utils :refer [find-by]]
            [accountant.core :as accountant]))

;; =============================================================================
;; Routing
;; =============================================================================

(reg-fx
 :route
 (fn [new-route]
   (if (vector? new-route)
     (let [[route query] new-route]
       (accountant/navigate! route query))
     (accountant/navigate! new-route))))

;; =============================================================================
;; Search Throttling
;; =============================================================================

;; See https://github.com/Day8/re-frame/pull/258
;; Can remove when PR is merged

(defn clear-timeout! [id]
  (js/clearTimeout id))

;; :dispatch-throttle
;;
;; This will only dispatch the event at most once per every 'window-duration' milliseconds.
;; The throttled function can be configured to dispatch on the leading, trailing or both edges of this window.

;; Note: When both leading and trailing flags are enabled the event will be dispatched on trailing edge only if there are more than one event.
;;
;; usage
;;
;; Expects either a single map, or a sequence of maps.
;;
;; {:dispatch-throttle {:id       ::re-render-markdown
;;                      :window-duration  250
;;                      :leading? true
;;                      :trailing? false
;;                      :dispatch [:re-render :main-section]}}
;;
;; Cancel throttled events
;;
;; {:dispatch-throttle {:id       ::re-render-markdown
;;                      :action :cancel}}
;;
;; Flush latest throttled event
;;
;; {:dispatch-throttle {:id ::re-render-markdown
;;                      :action :flush}}
(def throttled-events (atom {}))

(defn- on-leading-edge
  [id]
  (if-let [{:keys [leading? deferred-dispatch]} (id @throttled-events)]
    (if leading?
      (do
        (router/dispatch deferred-dispatch)
        (swap! throttled-events update-in [id] dissoc :deferred-dispatch)))))

(defn- on-trailing-edge
  [id]
  (if-let [{:keys [trailing? deferred-dispatch]} (id @throttled-events)]
    (do
      (if (and trailing? deferred-dispatch)
        (router/dispatch deferred-dispatch))
      (swap! throttled-events dissoc id))))

(register
 :dispatch-throttle
 (fn [dispatches]
   (let [dispatches (if (sequential? dispatches) dispatches [dispatches])]
     (doseq [{:keys [id action dispatch window-duration leading? trailing?] :as effect
              :or   {action :dispatch
                     leading? true}}
             dispatches]
       (case action

         :dispatch (if (or (empty? dispatch) (not (number? window-duration)))
                     (console :error "re-frame: ignoring bad :dispatch-throttle value:" effect)
                     (let [new-event? (nil? (id @throttled-events))]
                       (swap! throttled-events #(-> %
                                                    (assoc-in [id :deferred-dispatch] dispatch)
                                                    (assoc-in [id :leading?] leading?)
                                                    (assoc-in [id :trailing?] trailing?)))
                       (if new-event?
                         (do
                           (swap! throttled-events assoc-in [id :timeout] (set-timeout! #(on-trailing-edge id) window-duration))
                           (on-leading-edge id)))))

         :cancel (do
                   (clear-timeout! (get-in [id :timeout] @throttled-events))
                   (swap! throttled-events dissoc id))

         :flush (on-trailing-edge id)

         (console :error "re-frame: bad dispatch-throttle action:" action "id: " id))))))

;; =============================================================================
;; Load Scripts
;; =============================================================================

;; Given a script src, asynchronously loads the remote script if it doesn't
;; already exist in the DOM.

(extend-type js/NodeList
  ISeqable
  (-seq [array] (array-seq array 0)))

(defn- script-loaded? [src]
  (let [scripts (js->clj (.querySelectorAll js/document "script"))]
    (find-by #(= (.-src %) src) scripts)))

(reg-fx
 :load-scripts
 (fn [scripts]
   (doall
    (for [src scripts]
      (when-not (script-loaded? src)
        (let [script (.createElement js/document "script")]
          (aset script "src" src)
          (aset script "async" true)
          (.appendChild js/document.body script)))))))
