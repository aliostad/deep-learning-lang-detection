(ns spectodo.addtodo.view
  (:require [rum.core :as rum]
            [scrum.core :as scrum]))


(rum/defc View < rum/reactive [r]
  (let [input (rum/react (scrum/subscription r [:addtodo]))]
    [:header.header
    [:h1 "todos"]
    [:input.new-todo {:on-change #(scrum/dispatch! r :addtodo :update (-> % .-target .-value))
                      :placeholder "What needs to be done?"
                      :name "newTodo"
                      :value input
                      :on-key-up (fn [e]
                                   (if (= 13 (.-keyCode e)) (#(scrum/dispatch! r :todolist :add input)
                                                             (scrum/dispatch! r :addtodo :clear))))}]]))
