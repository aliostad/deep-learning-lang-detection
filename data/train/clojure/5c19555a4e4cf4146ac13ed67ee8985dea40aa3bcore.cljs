(ns test6.android.core
  (:require [reagent.core :as r]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [test6.handlers]
            [test6.subs]
            [test6.shared.ui :as ui]
            [test6.android.ui :as android-ui]
            [test6.android.styles :as s]
            [test6.android.scenes.root :refer [root-scene]]))

(defn app-root []
  [android-ui/navigator {:initial-route   {:name "main" :index 1}
                         :style           (get-in s/styles [:app])
                         :configure-scene (fn [_ _]
                                            js/React.Navigator.SceneConfigs.FloatFromBottomAndroid)
                         :render-scene    (fn [_ navigator]
                                            (r/as-element [root-scene {:navigator navigator}]))}])

(defn init []
  (dispatch-sync [:initialize-schema])
  (dispatch [:load-from-db :city])
  (.registerComponent ui/app-registry "test6" #(r/reactify-component app-root)))
