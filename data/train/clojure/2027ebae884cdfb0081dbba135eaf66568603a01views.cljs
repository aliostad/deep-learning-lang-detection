(ns reframetodos.views
  (:require [re-frame.core :refer [subscribe dispatch]]
            [reagent.core :as r]
            [reframetodos.functions :as f]))

(def click-value (r/atom 0))

(defn List-Todo []
  (let [todos (subscribe [:temptodos])] 
    (fn []
      [:div
       [:table
        [:tbody
         (for [i (range 0 (count @todos))]
           ^{:key i}
           [:tr
            [:td (get-in @todos [i :task])]
            (if (get-in @todos [i :active])
              [:td "P"]
              [:td "D"])
            [:td            
             (if (= (get-in @todos [i :active]) true)
               
               [:button {:on-click #(do (dispatch [:change-active-state i])
                                        (dispatch [:change-temp-active-state i]))} 
                "Mark Done"]
               [:button {:on-click #(do (dispatch [:change-active-state i])
                                        (dispatch [:change-temp-active-state i]))} 
                "Mark Pending"])]
            [:td 
             [:button {:on-click #(do (dispatch [:delete (get-in @todos [i :id])])
                                      (dispatch [:delete-temp (get-in @todos [i :id])]))} 
              "X"]]])]]
       [:p (str @todos)]
       [:div (str "click-value: " @click-value)]])))


 (defn Add-Todo-List []
   (let [text (atom "")]
     (fn []
       [:div
        [:span
         [:input {:type "text"
                  :placeholder "Enter todo"
                  :on-change #(reset! text (-> % .-target .-value))}]
         [:button {:on-click #(do
                                (dispatch [:add @text])
                                (if (= @click-value 1)
                                  (do
                                    (dispatch [:add-to-alltodos @text])
                                    (dispatch [:all-to-temp])))
                                (if (= @click-value 2)
                                  (do
                                    (dispatch [:add-to-activetodos @text])
                                    (dispatch [:active-to-temp]))))} "Add"]]])))


(defn footer []
  (let [alltodos (subscribe [:alltodos])
        activetodos (subscribe [:activetodos])
        completetodos (subscribe [:completetodos])]
    (fn []
      [:div
       [:span
        [:span "Items Left: " (f/ActiveTodosCount (subscribe [:todos]))]
        [:button {:value @click-value
                  :on-click #(do 
                              (reset! click-value 1)
                              (dispatch [:all])
                              (dispatch [:all-to-temp]))} "All"]
        
        [:button {:value @click-value
                  :on-click #(do 
                                 (reset! click-value 2)
                                 (dispatch [:active])
                                 (dispatch [:active-to-temp]))} "Active"]
        
        [:button {:value @click-value
                  :on-click #(do 
                                 (reset! click-value 3)
                                 (dispatch [:complete])
                                 (dispatch [:complete-to-temp]))} "Complete"]
        
        [:button {:on-click #(do 
                               (dispatch [:clear-complete])
                               (dispatch [:clear-complete-temp]))} 
          "ClearComplete"]]])))

 
