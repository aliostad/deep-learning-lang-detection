(ns open-source.core
  (:require [reagent.core :as r]
            [re-frame.core :refer [dispatch-sync dispatch subscribe]]
            
            [open-source.utils :as u]
            [open-source.handlers]
            [open-source.subs]
            [open-source.utils :as u]
            [open-source.routes]

            [open-source.pub.projects.list  :as ppl]
            [open-source.pub.projects.view  :as ppv]

            [open-source.pub.projects.create :as ppc]
            [open-source.pub.projects.edit   :as ppe]))

(enable-console-print!)

(defn app
  []
  (let [nav          (subscribe [:key :nav])
        initialized  (subscribe [:key :initialized])]
    (fn []
      (let [nav @nav
            {:keys [l0 l1 l2]} nav]
        (dispatch [:set-title nav])
        [:div.app
         (when (= l0 :public)
           [:div.hero
            [:div.container
             [:div.banner
              [:a {:href "/"} "Open Source Clojure Projects"]]
             [:div.tagline
              [:a {:href "/"} "contribute code, live forever*"]]
             [:div.caveat "*maybe? you won't know until you try"]]])
         [:div.container {:class (if (= l0 :public) "pub" "manage")}
          (when @initialized
            [:div.panel
             (case [l0 l1 l2]                                                 
               [:public :projects :list]   [ppl/view]
               [:public :projects :view]   [ppv/view]
               [:public :projects :edit]    [ppe/view]
               [:public :projects :new]     [ppc/view]
               
               [nil nil nil] [:div])])]]))))

(defn -main []
  (dispatch-sync [:initialize])
  (r/render-component [app] (u/el-by-id "app")))

(-main)
