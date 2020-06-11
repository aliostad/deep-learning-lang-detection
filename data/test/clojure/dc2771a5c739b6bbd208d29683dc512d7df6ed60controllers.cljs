(ns re2.controllers
    (:require [re-frame.core :as re-frame]

              [secretary.core :as secretary :include-macros true]
              [accountant.core :as accountant]
              [re2.events]
              [re2.subs]
              [re2.utils :as utils]
              [re2.views :as views]
             ))



(defn main-page []

  (let [login? (re-frame/subscribe [:login])
        page (re-frame/subscribe [:active-panel])]
    (if @login?
      (do (re-frame/dispatch [:set-panel :main-panel])
          (re-frame/dispatch [:http-get-documents]))
      (accountant/navigate! "/login")
 )))


(defn login-page []

  (let [login? (re-frame/subscribe [:login])]
    (if @login?
      (accountant/navigate! "/")
      (re-frame/dispatch [:set-panel :login-panel] ))))

(defn cladr-page []

      (re-frame/dispatch [:set-panel :cladr-panel] ))
