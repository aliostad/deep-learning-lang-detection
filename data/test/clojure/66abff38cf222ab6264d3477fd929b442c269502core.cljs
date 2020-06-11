(ns ref-cursor.core
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [om.core :as om :include-macros true]
            [om.dom :as dom :include-macros true]
            [cljs.core.async :refer [<! chan timeout]]))

(enable-console-print!)

(def message-source ["Across the Universe" "Act Naturally" "Ask Me Why" "Back in the U.S.S.R"
                     "Because" "Blackbird" "Carry That Weight" "A Day in the Life" "Day Tripper"
                     "Don't Let Me Down" "Drive My Car" "Eleanor Rigby" "The End" "Fixing a Hole"
                     "Get Back" "Help!" "Helter Skelter" "Her Majesty" "Hey Jude" "I Am the Walrus"
                     "I Saw Her Standing There" "I Should Have Known Better" "It Won't Be Long"
                     "I've Just Seen a Face" "Let It Be" "Maxwell's Silver Hammer" "Money"
                     "Norwegian Wood" "Paperback Writer" "Polythene Pam" "Revolution"
                     "She Came In Through the Bathroom Window" "Taxman" "Tell Me Why"
                     "Ticket to Ride" "We Can Work It Out" "When I'm Sixty-Four"
                     "With a Little Help from My Friends" "Yellow Submarine" "Yesterday"
                     "You Won't See Me" "You've Got to Hide Your Love Away"])

(defonce app-state (atom {:messages []
                          :members [{:name "John" :instrument :guitar}
                                    {:name "George" :instrument :guitar}
                                    {:name "Paul" :instrument :bass}
                                    {:name "Ringo" :instrument :drums}
                                    {:name "Clarence" :instrument :saxophone}]}))

(defn messages []
  (om/ref-cursor (:messages (om/root-cursor app-state))))

(defn build-message []
  {:sender (-> @app-state :members rand-nth :name)
   :text (rand-nth message-source)})

(defn format-msg [{:keys [sender text]}] (str sender ": " text))

(defn user-panel [app owner]
  (reify
    om/IRender
    (render [_]
      (let [xs (->> (om/observe owner (messages))
                    (filter #(= (:sender %) (:name app)))
                    reverse)]
        (dom/div #js {:className "col-xs-3 panel panel-warning msg-log"}
                 (dom/h4 #js {:className "panel-heading"}
                         (str (:name app) " " (:instrument app)))
                 (dom/div #js {:className "panel-body"}
                          (apply dom/ul #js {:className "list-group"}
                                 (map #(dom/li #js {:className "list-group-item"}
                                               (:text %))
                                      (take 3 xs)))))))))

(defn msgs-panel [app owner]
  (om/component
   (dom/div #js {:className "panel panel-primary"}
            (dom/div #js {:className "panel-heading"}
                     "Last message")
            (dom/div #js {:className "panel-body"}
                     (dom/h2 nil (format-msg (first (reverse app))))))))

(defn main-panel [app owner]
  (reify
    om/IWillMount
    (will-mount [_]
      (go (loop []
            (om/transact! app :messages #(conj % (build-message)))
            (<! (timeout 3000))
            (recur))))
    om/IRender
    (render [this]
      (dom/div nil
               (dom/div #js {:className "row"}
                        (om/build msgs-panel (:messages app)))
               (dom/div #js {:className "row"}
                        (om/build user-panel (nth (:members app) 0))
                        (om/build user-panel (nth (:members app) 1))
                        (om/build user-panel (nth (:members app) 2))
                        (om/build user-panel (nth (:members app) 3)))))))

(om/root
 main-panel
 app-state
 {:target (. js/document (getElementById "app"))})
