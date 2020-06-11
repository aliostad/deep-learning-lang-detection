(ns improject.friend_search
  (:require [reagent.core :as r]
            [re-frame.core :refer [subscribe dispatch-sync dispatch]]
            [improject.formtools :refer [value-of]]))

(defn friend-search []
  (let [filtered-users (subscribe [:filtered-users])]
    (fn []
      [:div
       [:input {:type "text"
                :placeholder "Search for friends"
                :on-change #(dispatch [:search-friends (value-of %)])}]
       [:ul#friend-results
       (if (nil? @filtered-users)
         [:li]
         (->> @filtered-users
              (map (fn [u]
                     [:div.flex
                      [:img {:style {:width "60px"
                                     :height "60px"}
                             :src (:img_location u)}]
                      [:div (:displayname u)
                       ;;TODO Add already friend? - check
                       [:button {:style {:display :block}
                                 :on-click #(dispatch [:send-friend-request (:username u)])} "Send friend request"]]]))
              (into [:li])))]])))
