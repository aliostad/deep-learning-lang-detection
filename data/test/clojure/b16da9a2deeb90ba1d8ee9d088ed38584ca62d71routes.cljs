(ns mojo-score.routes
  (:require [re-frame.core :refer [dispatch]]
            [secretary.core :as secretary :refer-macros [defroute]]
            [mojo-score.portal.core :refer [portal-view]]
            [mojo-score.editor.core :refer [editor-view]]))

(defroute home-path "/" [] (dispatch [:set-route :portal]))
(defroute editor-path "/editor" [] (dispatch [:set-route :editor]))
(defroute editor-path2 "/editor/:id" [id] (dispatch [:set-route :editor id]))

(def routes {:portal portal-view
             :editor editor-view})
