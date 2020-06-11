
(ns clouditor.component.token-toolbar
  (:require [respo.alias :refer [create-comp div]]
            [respo.component.text :refer [comp-text]]
            [respo.component.space :refer [comp-space]]
            [clouditor.style.widget :as widget]
            [clouditor.style.layout :as layout]))

(defn on-rm [e dispatch! mutate!] (dispatch! :tree/rm nil))

(defn on-after [e dispatch! mutate!] (dispatch! :tree/after nil))

(defn on-before [e dispatch! mutate!] (dispatch! :tree/before nil))

(defn on-fold [e dispatch! mutate!] (dispatch! :tree/fold nil))

(defn on-define [token]
  (fn [e dispatch! mutate!] (dispatch! :stack/define token)))

(defn render [token]
  (fn [state mutate!]
    (let [has-ns? (clojure.string/includes? token "/")]
      (div
        {:style (merge layout/row widget/float-toolbar)}
        (div
          {:style widget/tool-button, :event {:click on-rm}}
          (comp-text "rm" nil))
        (comp-space 8 nil)
        (div
          {:style widget/tool-button, :event {:click on-after}}
          (comp-text "after" nil))
        (comp-space 8 nil)
        (div
          {:style widget/tool-button, :event {:click on-before}}
          (comp-text "before" nil))
        (comp-space 8 nil)
        (div
          {:style widget/tool-button, :event {:click on-fold}}
          (comp-text "fold" nil))
        (if has-ns? (comp-space 8 nil))
        (if has-ns?
          (div
            {:style widget/tool-button,
             :event {:click (on-define token)}}
            (comp-text "define" nil)))))))

(def comp-token-toolbar (create-comp :token-toolbar render))
