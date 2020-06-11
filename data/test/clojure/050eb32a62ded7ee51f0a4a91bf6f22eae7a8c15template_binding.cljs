(ns closeout.dom.protocols.template-binding
  (:refer-clojure :exclude [name])
  
  (:require 
    [dsann.utils.x.core :as u]
    
    
    [dsann.cljs-utils.dom.dom  :as udom]
    [dsann.cljs-utils.dom.find :as udfind]
    
    [piccup.html :as ph]

    [goog.dom :as gdom]
    [goog.dom.dataset :as gdata]
    [goog.dom.classes :as gcls]
    [goog.events :as gevents]
    
    [closeout.state.mirror :as usm]
    [closeout.protocols.template-binding :as t]
    )
  )

(defn get-template-name [n]  
  (if-let [n (gdata/get n "templateName")]
    (keyword n)))

(defn set-template-name! [n v]
  (do 
    (gcls/add  n "template")
    (gdata/set n "templateName" (clojure.core/name v))))

(defn render-placeholder [placeholder-node application]
  (let [template-name  (get-template-name placeholder-node)
        templates      (:templates application)
        template       (templates template-name)
        hiccup         (or (:static-template template) [:div])
        n              (first (ph/html hiccup))]
    ; add class and name for update and behaviour
    (gcls/add  n "template")
    (gdata/set n "templateName" template-name)
    n))

(defn get-bound-path [n parent-data-path]
  (if-let [t-bind (gdata/get n "templateBindKw")]
    (conj parent-data-path (keyword t-bind))
    (if-let [t-bind (gdata/get n "templateBindInt")]
      (conj parent-data-path (js/parseInt t-bind 10))
      (if-let [t-bind (gdata/get n "templateBindStr")]
        (conj parent-data-path t-bind)
        (if-let [t-bind (gdata/get n "templateBindSeq")]
          (apply (partial conj parent-data-path) (reader/read t-bind))
          parent-data-path)))))


  
(defn apply-behaviour! [node application]
  (if-let [template-name (get-template-name node)]
    (let [templates  (:templates application)]
      (when-let [behaviour-fn! (:behaviour-fn! (templates template-name))]
        (behaviour-fn! application node)
        (gdata/set node "behaviourActive" "true")))))

(defn activate-templates! [node application]
  (doseq [n (udfind/by-class-inclusive "template" node)]
    (when-not (gdata/get n "behaviourActive")
      (apply-behaviour! n application))))
  
(defn deactivate-node! [mirror-state n]
  (gevents/removeAll n)                   ; remove events
  (gdata/remove n "behaviourActive")
  (usm/remove-update-paths! mirror-state n)   ; remove updates                 
  )

(defn deactivate-and-remove! [node application]
    (let [mirror-state (:mirror-state application)]
      ; this will be a problem for large trees - need to manage better
      ; probably by limiting where listeners are placed
      (udom/doto-node-and-children 
        node 
        (partial deactivate-node! mirror-state))
      (gdom/removeNode node)
      ))


(extend-protocol t/TemplateBinding
  js/Node
  (name  [n]   (get-template-name n))
  (name! [n v] (set-template-name! n v))
  (bound-path [n parent-data-path] (get-bound-path n parent-data-path))
  (placeholder?      [node] (gcls/has node "placeholder"))
  (find-placeholders [node] (udfind/by-class "placeholder" node))
  
  (render [placeholder-node application] 
          (render-placeholder placeholder-node application))
  
  (find-templates [node] 
                  (udfind/by-class-inclusive "template" node)) 
  
  (activate! [node application] (activate-templates! node application))
             
  (deactivate! [node application] (deactivate-and-remove! node application))
  
  (updated! [old-node new-node application]
            (when (not= old-node new-node)
              ;; if replaced ensure that the new node can be activated
              (set-template-name! new-node (get-template-name old-node))
              
              (gdom/replaceNode       new-node old-node   )
              (deactivate-and-remove! old-node application)
              (activate-templates!    new-node application)
              ))
  
  
  )
