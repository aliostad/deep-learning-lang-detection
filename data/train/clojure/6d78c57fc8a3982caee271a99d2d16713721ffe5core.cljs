(ns examples.instrument.core
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [om.core :as om :include-macros true]
            [om.dom :as dom :include-macros true]
            [cljs.reader :as reader]
            [sablono.core :as html :refer-macros [html]]
            [examples.instrument.editor :as editor]
            [cljs.core.async :refer [<! chan put! sliding-buffer]]))

(enable-console-print!)

;; =============================================================================
;; Declarations

(def app-state
  (atom {:children
         [{:open? true :label "Foo" :id 1
           :children
           [{:open? false :label "Foo" :id 11}
            {:open? true :label "Bar" :id 12
             :children
             [{:open? false :label "Foo" :id 21
               :children
               [{:open? false :label "Foo" :id 2110}
                {:open? false :label "Bar" :id 2120}
                {:open? false :label "Baz" :id 2130}]}
              {:open? false :label "Bar" :id 22
               :children
               [{:open? false :label "Foo" :id 2111}
                {:open? false :label "Bar" :id 2121}
                {:open? false :label "Baz" :id 2131}]}
              {:open? true :label "Baz" :id 23
               :children
               [{:open? false :label "Foo" :id 2112}
                {:open? false :label "Bar" :id 2122}
                {:open? false :label "Baz" :id 2132}]}]}
            {:open? false :label "Baz" :id 13}]}
          {:open? false :label "Bar" :id 2}
          {:open? false :label "Baz" :id 3}]}))

;; =============================================================================
;; Application

(declare branch)

(defn process-children [f children]
  (map (fn [{:keys [children] :as child}]
         (if children
           (assoc child :children (f children))
           child))
       children))

(defn deselect-children [latest-selected children]
  (->> children
       (map (fn [child]
              (if (and (-> child :id (not= latest-selected)) (:selected? child))
                (assoc child :selected? false)
                child)))
       (process-children (partial deselect-children latest-selected))
       vec))

(defn close-children [children]
  (->> children
       (map (fn [child]
              (if (:open? child)
                (assoc child :open? false)
                child)))
       (process-children close-children)
       vec))

(defn leaf [{:keys [children open? selected? label id] :as data} owner]
  (reify
    om/IDisplayName (display-name [_] "Leaf")
    om/IRenderState
    (render-state [_ {:keys [control] :as state}]
      (html
       [:div.radio {:key id}
        (if children
          [:label (when open? {:style {:text-decoration "underline"}})
           [:input {:type "checkbox"
                    :checked open?
                    :onChange #(do (when open?
                                     (om/transact! data :children close-children))
                                   (om/transact! data :open? not))}]
           id ": " label]
          [:div.leaf {:onClick #(do (put! control [:select id])
                                    (om/transact! data :selected? (constantly true)))}
           [:div (when selected? {:style {:background "#179CD1"}})
            id ": " label]])
        (when (and children open?)
          (om/build branch data {:init-state state}))]))))

(defn branch [data owner]
  (reify
    om/IDisplayName (display-name [_] "Branch")
    om/IRenderState
    (render-state [_ state]
      (apply dom/div nil
        (om/build-all leaf (:children data) {:init-state state})))))

(defn tree [data owner]
  (reify
    om/IDisplayName (display-name [_] "Tree")
    om/IWillMount
    (will-mount [_]
      (let [control (om/get-state owner :control)]
        (go (while true
              (when-let [[op args] (<! control)]
                (prn op ": " args)
                (condp = op
                  :select
                  (om/transact! data :children (partial deselect-children args))))))))
    om/IInitState
    (init-state [_]
      {:control (chan)})
    om/IRenderState
    (render-state [_ state]
      (om/build branch data {:init-state state}))))

;; =============================================================================
;; Init

(om/root tree app-state
         {:target (.getElementById js/document "ex0")})

(om/root tree app-state
           {:target (.getElementById js/document "ex1")
            :instrument
            (fn [f cursor m]
              (if (= f leaf)
                (om/build* editor/editor (om/graft [f cursor m] cursor))
                ::om/pass))})
