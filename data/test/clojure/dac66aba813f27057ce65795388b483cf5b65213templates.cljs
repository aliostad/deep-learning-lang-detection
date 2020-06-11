(ns closeout-demos.apps.clock.templates
  (:require  
    [dsann.utils.x.core :as u]
    [closeout.core                 :as co]
    [closeout.dom.template-helpers :as th]
    
    [goog.dom :as gdom]
    
    ))

; This is the static html markup (hiccup syntax) for the main app.
; this template contains a placeholder
;  placeholders are replaced by looking up their template
;  in the templates config (see below)
;  In this case, the :clock template will be looked up and rendered
;  For data, the template will bind on the data path :time
;  The bound data path is relative to the data path of the parent template
;  In this case, the parent template will be bound to []
;    so the placeholder will get the datea in [:time]
(def main-template [:div.clock-app
                    [:div.title "Clock"]
                    [:div.placeholder {:data-template-name "clock"
                                       :data-template-bind-kw "time"}]])
  
; This is the static html for the clock
(def clock-template [:div.clock])

; This function will be called when the data on the path for the clock template
; changes. It can update the existing node or create a new one
;  In this case when called, the data path will be bound to [:time]
;   so t here, is a js/Date (as set in main.cljs for the app)
(defn clock-update! [clock-node data-path old-app-state new-app-state]
  (let [t (get-in new-app-state data-path)]
    (gdom/setTextContent clock-node t)
    clock-node
    ))
 

; This is the template config for the application
; each key names a template. 
; These keys can be referenced in placeholders to insert the template
; each template has
;  static-template - hiccup syntax static html
;  node-updater!   - a function that will manage node update
;  behaviour-fn!   - a function to attach behaviour to the node

; closeout implements several helper functions for node-updaters!
; In this case clock-update will be called when the bound path 
;   ([:time] for clock in this case)
;  or any sub path changes in the app-state. (i.e [:time :x :y: :z])
; You can also do 
;   exact path matches
;   exact path matches with specified sub paths
;   exact path matches with dynamically generated sub paths
; There is also a helper for list updates management (see todos)
(def templates
  {
   :main
   {:static-template main-template
    :node-updater!   nil; no updates
    :behaviour-fn!   nil; no behaviour
    }
   
   :clock
   {:static-template clock-template
    :node-updater!   (co/update-on-ANY-data-path-change clock-update!)
    :behaviour-fn!   nil; no behaviour
    }
   
   })
  
            
      