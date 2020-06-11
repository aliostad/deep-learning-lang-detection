(ns webui-aria.core
  (:require [reagent.core :as reagent]
            [re-frame.core :as re-frame]
            [webui-aria.handlers]
            [webui-aria.subs]
            [webui-aria.routes :as routes]
            [webui-aria.views :as views]
            [webui-aria.api :as api]))


(defn mount-root []
  (reagent/render [views/main-panel]
                  (.getElementById js/document "app")))

(defn ^:export init [] 
  (routes/app-routes)
  (re-frame/dispatch-sync [:initialize-db])
  (re-frame/dispatch [:tell-active])
  (re-frame/dispatch [:tell-waiting {:offset 0 :num 100}])
  (re-frame/dispatch [:tell-stopped {:offset 0 :num 100}])
  (mount-root))

