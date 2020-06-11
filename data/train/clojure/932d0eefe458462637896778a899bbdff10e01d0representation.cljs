(ns app.player.representation
  (:require [re-frame.core :refer [dispatch-sync]]))


(defn fade-items [items amount]
  (map #(assoc % :opacity (- (:opacity %) amount)) items))

(defn fade-screen [items amount]
  "Fade items, remove invisisible ones."
  (letfn [(update-items []
            (filter #(< 0 (:opacity %)) (fade-items items amount)))]
    (update-items)))

(defn item->div [{:keys [text color x y size opacity key] :as item} ]
  "Convert internal representation to hiccup html"
  [:div {:class "item-container"
         :key key
         :style {:left x
                 :top y
                 :overflow "hidden"}
         :on-mouse-over (fn [e]                         
                          (.addClass 
                           (.closest (js/jQuery (.. e -target)) 
                                     ".item-container") 
                           "active")
                          (dispatch-sync [:stop]))
         :on-mouse-out (fn [e] 
                         (.remove (.. e -target -classList) "active")
                         (dispatch-sync [:start]))}
   [:div {:class "item"           
          :style {:color color 
                  :opacity opacity
                  :font-size (str size "px")}         
          
          } text]
   [:div {:class "meta"}
    [:div {:class "delete-item glyphicon glyphicon-remove"
           :on-click (fn [e] 
                       (dispatch-sync [:delete text nil])
                       (dispatch-sync [:screen-rm text])
                       (dispatch-sync [:start]) ;; mouse-out not triggered anymore
                       (.stopPropagation e))}] 
    ""
    ]   
   ])
