
(ns clouditor.component.expression-toolbar
  (:require [respo.alias :refer [create-comp div]]
            [clouditor.style.layout :as layout]
            [clouditor.style.widget :as widget]
            [respo.component.text :refer [comp-text]]
            [respo.component.space :refer [comp-space]]))

(declare comp-expression)

(defn on-prepend [e dispatch! mutate!]
  (dispatch! :tree/expr-prepend nil))

(defn on-append [e dispatch! mutate!] (dispatch! :tree/expr-append nil))

(defn on-before [e dispatch! mutate!] (dispatch! :tree/before nil))

(defn on-after [e dispatch! mutate!] (dispatch! :tree/after nil))

(defn on-rm [e dispatch! mutate!] (dispatch! :tree/rm nil))

(defn on-fold [e dispatch! mutate!] (dispatch! :tree/fold nil))

(defn on-unfold [e dispatch! mutate!] (dispatch! :tree/expr-unfold nil))

(defn render []
  (fn [state mutate!]
    (div
      {:style (merge layout/row widget/float-toolbar)}
      (div
        {:style widget/tool-button, :event {:click on-prepend}}
        (comp-text "prepend" nil))
      (comp-space 8 nil)
      (div
        {:style widget/tool-button, :event {:click on-append}}
        (comp-text "append" nil))
      (comp-space 8 nil)
      (div
        {:style widget/tool-button, :event {:click on-before}}
        (comp-text "before" nil))
      (comp-space 8 nil)
      (div
        {:style widget/tool-button, :event {:click on-after}}
        (comp-text "after" nil))
      (comp-space 8 nil)
      (div
        {:style widget/tool-button, :event {:click on-rm}}
        (comp-text "rm" nil))
      (comp-space 8 nil)
      (div
        {:style widget/tool-button, :event {:click on-fold}}
        (comp-text "fold" nil))
      (comp-space 8 nil)
      (div
        {:style widget/tool-button, :event {:click on-unfold}}
        (comp-text "unfold" nil)))))

(def comp-expression-toolbar (create-comp :expression-toolbar render))
