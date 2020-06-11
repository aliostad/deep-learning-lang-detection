(ns portfolio.input
  "Search input form Om component. This one uses om-tools' defcomponentk"
  (:require
    [cljs.core.async :as async
      :refer [>! put! sub chan]]
    [om.core :as om :include-macros true]
    [om-bootstrap.input :as i]
    [om-tools.core :refer-macros [defcomponentk]])

  (:require-macros [cljs.core.async.macros :refer [go-loop]]))

(defn handle-change
  "Grab the input element via the `input` reference."
  [owner state]
  (let [node   (om/get-node owner "input")
        value  (.trim (.-value node))
        search-chan   (:search-chan  (om/get-shared owner))]
    (swap! state assoc :text value)
    (put! search-chan
          {:topic :search
           :value value})
    false))

(defcomponentk input-view
  "Portfolio search input om component."
  [owner state]
  (init-state [_] {:text ""})

  (will-mount
   [this]
   (let [click-chan (sub (:notif-chan (om/get-shared owner)) :search-click (chan) false)]
     (go-loop []
              (let [search-elem      (<! click-chan)]
                (swap! state assoc :text ""))
              (recur))))

  (render [_]
          (i/input
           {:feedback? true
            :autoComplete "off"
            :type "text"
            :data-hint "Start typing instrument name"
            :placeholder "Enter instrument"
            :group-classname "group-class"
            :wrapper-classname "wrapper-class"
            :label-classname "label-class"
            :value (:text @state)
            :on-change #(handle-change owner state)})))

