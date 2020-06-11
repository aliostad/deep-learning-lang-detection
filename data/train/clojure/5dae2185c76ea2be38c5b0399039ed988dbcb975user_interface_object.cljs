(ns calculator.user-interface-object
  (:require [calculator.control-object :as control-object]
            [calculator.statemachine.state-tag :as state-tag]
            [calculator.statemachine.event :as event]
            [rum.core :as rum]))


(enable-console-print!)


(rum/defc main-screen < rum/reactive [*app-state]
  (let [{:keys [state result num1 num2] :as st} (rum/react *app-state)]
    [:div
     [:h1 "Calculator"]
     [:table
      [:tbody
       [:tr
        [:td {:colSpan "5"} (condp = state
                              state-tag/start result
                              state-tag/operand2 num2
                              num1)]]
       [:tr
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 7))} "7"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 8))} "8"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 9))} "9"]]
        [:td [:button "C"]]
        [:td [:button "CE"]]]
       [:tr
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 4))} "4"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 5))} "5"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 6))} "6"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/operator-event +))} "+"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/operator-event -))} "-"]]]
       [:tr
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 1))} "1"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 2))} "2"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/num-event 3))} "3"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/operator-event *))} "x"]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/operator-event /))} "/"]]]
       [:tr
        [:td {:colSpan 2} [:button {:on-click #(control-object/dispatch *app-state (event/num-event 0))} "0"]]
        [:td [:button "."]]
        [:td [:button {:on-click #(control-object/dispatch *app-state (event/equal-event))} "="]]
        [:td [:button "%"]]]]]
     [:h4 "state"]
     [:div (print-str st)]]))


(defn render [*app-state]
  (control-object/init-state *app-state)
  (rum/mount (main-screen *app-state) (. js/document (getElementById "app"))))

