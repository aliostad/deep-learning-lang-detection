(ns test7.android.core
  (:require [reagent.core :as r]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [test7.handlers]
            [test7.subs]
            [test7.shared.ui :as ui]
            [test7.android.ui :as android-ui]
            [test7.android.styles :as s]
            [test7.android.scenes.root :refer [root-scene]]))

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
  (.registerComponent ui/app-registry "test7" #(r/reactify-component app-root)))
