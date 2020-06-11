(ns thonix.ui.helpers
  (:require [om.dom :as dom]
            [om.next :as om :refer-macros [defui]]))

(defn header [& content]
  (dom/header #js {:key "header"}
              (dom/div #js {:className "content" :key "header-content"}
                       content)
              (dom/div #js {:className "filler" :key "header-filler"}
                       content)))

(defn footer [& content]
  (dom/footer #js {:key "footer"}
              (dom/div #js {:className "content" :key "footer-content"}
                       content)
              (dom/div #js {:className "filler" :key "footer-filler"}
                       content)))

(defn icon
  ([type]
   (icon type nil))
  ([type opts]
   (dom/i (clj->js (merge opts
                          {:className   (str "fa fa-" type)
                           :aria-hidden "true"
                           :key         (:key opts type)})))))

(defn back-button [label onClick]
  (dom/button #js {:className "back" :type "button"
                   :onClick   onClick
                   :key       "back"}
              (icon "chevron-left")
              (str " " label)))

(defn progress
  ([now] (progress now (str now "% completed") 0 100))
  ([now label min max]
   (dom/div #js{:className "progress"}
     (dom/div #js {:className            "progress-bar" :role "progressbar"
                          :aria-valuenow now
                          :aria-valuemin min
                          :aria-valuemax max
                          :style         #js {:width (str (* (/ (- now min) (- max min)) 100) "%")}}
       (dom/span #js {:className "sr-only"} label)))))


(defn button
  ([label onClick]
   (button label onClick {}))
  ([label onClick opts]
   (dom/button #js {:type      "button"
                    :className (str "btn " (:className opts "btn-default"))
                    :onClick   onClick
                    :key       (:key opts label)}
               label)))

(defui ^:once NotImplemented
       Object
       (back [this ev]
             (js/window.history.back))
       (render [this]
               (dom/div #js {:className "with-menu"}
                 (header
                   (dom/button #js {:className "back" :type "button"
                                    :onClick #(.back this %)}
                     (dom/span #js {:className "fa fa-chevron-left" :ariahidden true})
                     " Back")
                   (dom/h2 nil "Not Implemented"))
                 (dom/div nil
                   "This screen has not been implemented"))))

(defn factory
  ([class] (factory class nil))
  ([class {:keys [validator keyfn instrument? computed]
           :or   {instrument? true} :as opts}]
   {:pre [(fn? class)]}
   (let [f (om/factory class opts)]
     (fn self [props]
       (let [current (om/get-computed props)]
         (f (om/computed props (merge current computed))))))))