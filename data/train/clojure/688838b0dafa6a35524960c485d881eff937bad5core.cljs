(ns scribe.core
  (:require-macros [reagent.ratom :refer [run!]])
  (:require [scribe.view :as view]
            [scribe.handler :as handler]
            [scribe.subscription :as subscription]
            [scribe.js-util :refer [convert-js-tree]]
            [reagent.core :as r]
            [re-frame.core :refer [dispatch dispatch-sync subscribe]]))

(enable-console-print!)

(defonce runs
  (let [tree (subscribe [:tree])
        sele-cont (subscribe [:selected-content])
        sele-id   (subscribe [:selected-id])]
    (run!
      (when-not @sele-cont
        (dispatch [:fetch @sele-id])))))

(defn ^:export run []
  (if js/StartingContent
    (dispatch-sync [:initialize (convert-js-tree js/StartingTree)
                                (convert-js-tree js/StartingContent)])
    (dispatch-sync [:initialize (convert-js-tree js/StartingTree)]))
  (r/render-component [view/main-view] (js/document.getElementById "app")))
;
