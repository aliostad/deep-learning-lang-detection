
(ns stack-workflow.comp.header
  (:require [respo.alias :refer [create-comp
                                 create-element
                                 div
                                 button
                                 h1]]
            [respo.comp.text :refer [comp-text]]
            [stack-workflow.measure :refer [start-measure
                                            stop-measure]]))

(defn on-run [e dispatch!] (start-measure "run") (dispatch! :run nil))

(defn on-add [e dispatch!] (start-measure "add") (dispatch! :add nil))

(defn on-run-lots [e dispatch!]
  (start-measure "runLots")
  (dispatch! :run-lots nil))

(defn on-update [e dispatch!]
  (start-measure "update")
  (dispatch! :update nil))

(defn on-swap-rows [e dispatch!]
  (start-measure "swapRows")
  (dispatch! :swap-rows nil))

(defn on-clear [e dispatch!]
  (start-measure "clear")
  (dispatch! :clear nil))

(defn div-class [class-name & children]
  (create-element :div {:attrs {:class-name class-name}} children))

(defn render-button [id-name text on-click]
  (div-class
    "col-sm-6 smallpad"
    (button
      {:event {:click on-click},
       :attrs
       {:inner-text text,
        :type "button",
        :id id-name,
        :class-name "btn btn-primary btn-block"}})))

(defn render []
  (fn [state mutate!]
    (div-class
      "jumbotron"
      (div-class
        "row"
        (div-class "col-md-6" (h1 {} (comp-text "Respo v0.2.25" nil)))
        (div-class
          "col-md-6"
          (div-class
            "row"
            (render-button "run" "Create 1,000 rows" on-run)
            (render-button "runlots" "Create 10,000 rows" on-run-lots)
            (render-button "add" "Append 1,000 rows" on-add)
            (render-button "update" "Update every 10th row" on-update)
            (render-button "clear" "Clear" on-clear)
            (render-button "swaprows" "Swap Rows" on-swap-rows)))))))

(def comp-header (create-comp :header render))
