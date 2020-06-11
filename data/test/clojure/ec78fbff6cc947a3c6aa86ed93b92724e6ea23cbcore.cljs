(ns test.core
  (:require [om.core :as om :include-macros true]
            [om.dom :as dom :include-macros true]
            [test.raf :as raf]
            [test.salp :as salp]))

(defonce app-state (atom {
                          :text "Hello Chestnut!!!!"
                          :style {
                                  :backgroundColor "blue"
                                  :position "absolute"
                                  :width "100px"
                                  :height "100px"
                                  :border-radius "100px"
                                  :left "200px"
                                  :top "100px"
                                  }
                          }))

(defn main []
    (om/root
     (fn [app owner]
       (reify
         om/IWillMount
         (will-mount [_]
           (let [key-down-stream (.asEventStream (js/$ js/document) "keydown")
                 key-code-stream (.map key-down-stream (fn [e] (.-keyCode e)))
                 initial-velocity [0, 0]
                 initial-position [0, 0]
                 velocity-atom (atom {})
                 resistance #(* (/ % 100) -1)
                 add-vectors #(map + %1 %2)
                 keycode-to-direction #(case %
                                         37 [-1 0]
                                         38 [0 -1]
                                         39 [1 0]
                                         40 [0 1]
                                         [0 0])
                 keyboard-acceleration-stream (.map key-code-stream keycode-to-direction)
                 resistance-acceleration-stream (.flatMapFirst
                                                 (.once js/Bacon 0)
                                                 (fn []
                                                   (.sampledBy (.map @velocity-atom #(map resistance %))
                                                               (.interval js/Bacon 10))))
                 acceleration-stream (.merge keyboard-acceleration-stream resistance-acceleration-stream)
                 velocity-stream (.scan acceleration-stream initial-velocity add-vectors)
                 position-stream (.scan velocity-stream initial-position add-vectors)
                 ui-update-stream (.sampledBy position-stream (raf/raf-sequence))]
             (swap! velocity-atom (fn [] velocity-stream))
             (.onValue ui-update-stream (fn [[x y]]
                                         ;; (.log js/console (clj->js [x y]))
                                         (.css (js/$ "h1") (clj->js {"left" (str x "px") "top" (str y "px")}))
                                         ;; (om/transact! app :style
                                         ;;               (fn [style]
                                         ;;                 (.log js/console (assoc style
                                         ;;                                   "left" (str x "px")
                                         ;;                                   "top" (str y "px")))
                                         ;;                 (assoc style
                                         ;;               ;; #(assoc %
                                         ;;                                   "left" (str x "px")
                                         ;;                                   "top" (str y "px"))))
                                         )
                       )
             )
           )
           om/IRender
           (render [_]
           ;; (salp/blah)
             (.log js/console "render")
           (dom/h1 #js {:className "blah" :style (clj->js (:style app))} (:text app)))))
     app-state
     {:target (. js/document (getElementById "app"))})

  (let [click-stream (.asEventStream (js/$ "h1") "click")]
    (.onValue click-stream (fn [] (.log js/console "here"))))
  )
