(ns neptune.routes
  (:require [re-frame.core :refer [subscribe dispatch]]
            [secretary.core :as secretary :include-macros true]
            [neptune.common.views :refer [debug-box]]
            [neptune.components.debug-tree :refer [state-tree]]

            [neptune.navigation.views :refer [navbar]]
            [neptune.messaging.views :refer [messaging-panel]]
            [neptune.home.views :refer [home-page loading-page]]
            [neptune.setup.views :refer [setup-page]]
            [neptune.editor.views :refer [editor-page]]))


(def pages
  {:loading #'loading-page
   :home    #'home-page
   :setup   #'setup-page
   :editor  #'editor-page})

(defn page []
  (let [active-page (subscribe [:common/active-page])]
    (fn []
      [:div
       [navbar]
       [messaging-panel]
       (when (not-empty @state-tree) [debug-box])
       [(pages (or @active-page :loading))]])))

;; -------------------------
;; Routes
(secretary/set-config! :prefix "#")

(secretary/defroute "/" []
                    (dispatch [:cases/init-db])
                    (dispatch [:cases/get-cases])
                    (dispatch [:setup/get-case-types])
                    (dispatch [:common/set-active-page :home]))
(secretary/defroute "/setup" []
                    (dispatch [:setup/init-db])
                    (dispatch [:setup/get-case-types])
                    (dispatch [:common/set-active-page :setup]))
(secretary/defroute "/:id/editor" [id]
                    (dispatch [:editor/init-db])
                    (dispatch [:editor/get-case id])
                    (dispatch [:editor/get-sections id])
                    (dispatch [:editor/get-case-sections id])
                    (dispatch [:editor/get-fields id])
                    (dispatch [:editor/get-case-data id])
                    (dispatch [:common/set-active-page :editor]))