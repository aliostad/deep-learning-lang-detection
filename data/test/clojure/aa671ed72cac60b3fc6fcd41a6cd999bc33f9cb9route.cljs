(ns ohucode.route
  (:require [secretary.core :as secretary :refer-macros [defroute]]
            [re-frame.core :refer [dispatch]]))

(defroute "/" []
  (js/console.log "route / called")
  (dispatch [:페이지 :첫화면]))

(defroute "/tos" []
  (dispatch [:페이지 :이용약관]))

(defroute "/policy" []
  (dispatch [:페이지 :개인정보취급방침]))

(defroute "/credits" []
  (dispatch [:페이지 :감사의말]))

(defroute "/:ns" [ns]
  (js/console.log "공간 첫페이지 보입시다. " ns)
  (dispatch [:공간선택 ns])
  (dispatch [:페이지 :공간첫페이지]))
