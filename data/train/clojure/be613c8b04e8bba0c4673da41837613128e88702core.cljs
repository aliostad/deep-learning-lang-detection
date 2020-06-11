(ns extracting-processes.core
  (:use [promise_stream.pstream :only [mapd* filter* concat* reductions*
                                       zip* promise fmap]]
        [jayq.core :only [$ on text]])
  (:require [clojure.string :as string]
            [promise_stream.pstream :as ps]
            [promise_stream.sources :as sources]
            [jayq.core :as jq]))

(defn log [clj-value]
  (js/console.log (clj->js clj-value))
  clj-value)

(defn log-stream [stream]
  (mapd* log stream))

; Pure data
(def keycode->key
  {38 :up
   40 :down
   74 :j
   75 :k
   13 :enter})

(def key->action
  {:up    :highlight/previous
   :down  :highlight/next
   :j     :highlight/next
   :k     :highlight/previous
   :enter :select/current})

(def highlight-actions
  #{:highlight/previous :highlight/next})

(def select-actions
  #{:select/current})

(def highlight-action->offset
  {:highlight/previous dec
   :highlight/next     inc})

(def ex0-ui
  ["   Alan Kay"
   "   J.C.R. Licklider"
   "   John McCarthy" ])

(def ex1-ui
  ["   Smalltalk"
   "   Lisp"
   "   Prolog"
   "   ML" ])

(def first-state
  {:highlight 0 :selection nil})

; Utility
(defn remember-selection
  "Stores current highlight as selection when select events occur. Otherwise
  updates remembered highlight."
  [{:keys [highlight selection] :as mem} event]
  (if (= event :select/current)
    (assoc mem :selection highlight)
    (assoc mem :highlight event)))

; Pure stream processing
(defn identify-key-actions [keydowns]
  (->> keydowns
       (mapd*   #(aget % "which"))
       (mapd*   keycode->key)
       (filter* (comp promise identity))
       (mapd*   key->action)))

(defn mouseover->highlight [mouseover]
  (.index (jq/$ (.-target mouseover))))

(defn set-char [s i c]
  (str (.substring s 0 i) c (.substring s (inc i))))

(defn render-highlight [ui {highlight :highlight}]
  (update-in ui [highlight] #(set-char % 0 ">")))

(defn render-selection [[ui {selection :selection}]]
  (if selection
    (update-in ui [selection] #(set-char % 1 "*"))
    ui))

(defn rendering-actions [element rendered-ui]
  [[:dom/set-text element rendered-ui]])

(defmulti execute first)

(defmethod execute :dom/set-text [[_ element content]]
  (text element content))

(defn execute-dom-transaction [transaction]
  (mapv execute transaction))

(defn of-type [desired-type]
  (fn [raw-event]
    (promise (= desired-type (aget raw-event "type")))))

(defn identify-events [raw-events]
  (let [keydowns                   (filter* (of-type "keydown")   raw-events)
        mouseovers                 (filter* (of-type "mouseover") raw-events)
        mouseouts                  (filter* (of-type "mouseout")  raw-events)
        clicks                     (filter* (of-type "click")     raw-events)

        key-actions                (identify-key-actions keydowns)

        key-selects                (filter* (comp promise select-actions) key-actions)
        mouse-selects              (mapd* (constantly :select/current) clicks)
        selects                    (concat* key-selects mouse-selects)

        highlight-moves            (filter* (comp promise highlight-actions) key-actions)

        mouse-highlight-indexes    (mapd* mouseover->highlight mouseovers)

        clears                     (mapd* (constantly :clear) mouseouts)]
    (concat* selects highlight-moves mouse-highlight-indexes  clears)))

(defn manage-state [number-of-rows identified-events]
  (let [highlight-moves            (filter* (comp promise highlight-actions)  identified-events)
        mouse-highlight-indexes    (filter* (comp promise number?)            identified-events)
        selects                    (filter* (comp promise #{:select/current}) identified-events)
        clears                     (filter* (comp promise #{:clear})          identified-events)
        
        highlight-index-offsets    (mapd* highlight-action->offset highlight-moves)
        highlight-index-resets     (mapd* constantly mouse-highlight-indexes)

        highlight-modifyers        (concat* highlight-index-offsets highlight-index-resets)
        raw-highlight-indexes      (reductions* (fmap (fn [v f] (f v))) (promise 0) highlight-modifyers)
        wrapped-highlight-indexes  (mapd* #(mod % number-of-rows) raw-highlight-indexes)

        highlights-and-selects     (concat* wrapped-highlight-indexes selects)]
    (reductions* (fmap remember-selection) (promise first-state) highlights-and-selects)))

(defn plan-changes [element ui ui-states]
  (let [highlighted-uis            (mapd* (partial render-highlight ui) ui-states)
        selected-uis               (mapd* render-selection (zip* highlighted-uis ui-states))
        rendered-uis               (mapd* (partial string/join "\n") selected-uis)]
    (mapd* (partial rendering-actions element) rendered-uis)))

(defn menu-logic [element ui events]
  (->> (manage-state (count ui) events)
       (plan-changes element ui)))

(defn connect-to-dom [menu-logic element ui]
  (let [keydowns                   (sources/callback->promise-stream on element "keydown")
        mouseovers                 (sources/callback->promise-stream on ($ "li" element) "mouseover")
        mouseouts                  (sources/callback->promise-stream on ($ element) "mouseout")
        clicks                     (sources/callback->promise-stream on ($ "li" element) "click")

        raw-events                 (concat* keydowns mouseovers mouseouts clicks)]
    (->> raw-events
         identify-events
         (menu-logic element ui)
         (mapd* execute-dom-transaction))))

(defn create-menu [element ui]
  (execute-dom-transaction [[:dom/set-text element (string/join "\n" ui)]])
  (connect-to-dom menu-logic element ui))

(create-menu ($ "#ex0") ex0-ui)

