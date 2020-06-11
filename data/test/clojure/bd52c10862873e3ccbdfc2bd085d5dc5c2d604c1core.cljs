(ns klangmeister.core
  (:require
    [goog.dom :as gdom]
    [om.next :as om :refer-macros [defui]]
    [om.dom :as dom]
    [klangmeister.processing] ; Import action defs.
    [klangmeister.actions :as action]
;;    [klangmeister.ui.reference :as ref]
;;    [klangmeister.ui.view :as view]
    [klangmeister.framework :as framework]
    [klangmeister.ui.about :as ab]
;;    [klangmeister.ui.composition :as comp]
;;    [klangmeister.ui.jam :as jam]
    [cljs-bach.synthesis :as synth]
;;    [klangmeister.ui.editor :as ed]
;;    [compassus.core :as compassus]
;;    [bidi.bidi :as bidi]
;;    [pushy.core :as pushy]
    ))


(enable-console-print!)

(println "This text is printed from src/klangmeister/core.cljs. Go ahead and edit it and see reloading in action.")

(defn on-js-reload []
  ;; optionally touch your app-state to force rerendering depending on
  ;; your application
  ;; (swap! app-state update-in [:__figwheel_counter] inc)
)


;; define your app data so that it doesn't get over-written on reload
(def init-data (merge {:audiocontext   (synth/audio-context)}
                       ab/init-data
                       ))

(def state-atom (atom init-data))


(defui App-ui
  Object
  (render [this]
          (ab/about-ui)))


(def reconciler
  (om/reconciler {:state state-atom
                  :parser (om/parser {:read framework/read :mutate framework/mutate})
                  }))

(om/add-root! reconciler
              App-ui (gdom/getElement "app"))



(comment


  (def handle!
    "An handler that components can use to raise events."
    (framework/handler-for state-atom))


  (def jam-demo "; A synthesiser we can play our piece on.\n(defn synth [note]\n  (connect->\n    (add (square (* 1.01 (:pitch note))) (sawtooth (:pitch note)))\n    (low-pass 600)\n    (adsr 0.001 0.4 0.5 0.1)\n    (gain 0.15)))\n\n(def melody\n       ; The durations and pitches of the notes. Try changing them.\n  (->> (phrase [1 1/2 1/2 1 1 2 2] [0 1 0 2 -3 1 -1])\n       (all :instrument synth))) ; Here we choose the instrument.\n\n(def harmony\n       ; The durations and pitches of the harmony's notes.\n  (->> (phrase [1 1/2 1/2 1 1 1/2 1/2 1/2 1/2 2] [4 4 5 4 7 6 7 6 5 4])\n       (all :instrument synth))) ; bell, wah, organ and marimba are also instruments.\n\n(def bass\n       ; The durations and pitches of the bass.\n  (->> (phrase (cycle [3 0.75 0.25]) [-14 -15 -16 -17 -16 -15])\n       (all :instrument wah)))\n\n(def variation\n       ; The durations and pitches of the bass.\n  (->> (phrase [3 1 3/2 5/2] [9 11 8 10])\n       (all :instrument marimba)))\n\n(def beat\n  (->> (phrase [1 1/2 1/2 1 1] (repeat 0))\n       (having :instrument [kick closed-hat kick kick closed-hat])\n       (times 2)))\n\n(->> melody\n     ;(with harmony)   ; Uncomment to include the harmony.\n     ;(with bass)      ; Uncomment to include the bass.\n     ;(with variation) ; Uncomment to include the harmony.\n     ;(with beat)      ; Uncomment to include the beat.\n     (tempo (bpm 90))  ; Try changing the number.\n     (where :pitch (comp C major))) ; Try D or minor.")
  (handle! (action/->Refresh jam-demo :main)) ; Add demo code for jam session to global state-atom



  (def bidi-routes  ["/klangmeister/" view/bidi-routes])

  (declare app)

  (defn update-route!
    [{:keys [handler] :as route}]
    (let [current-route (compassus/current-route app)]
      (when (not= handler current-route)
        (compassus/set-route! app handler))))

  (def history
    (pushy/pushy update-route!
      (partial bidi/match-route bidi-routes)))


  ;;(defn read
  ;;  [env k params]
  ;;  {:value :none})


  (def app
    (compassus/application
      {:routes      view/routes
       :index-route view/index-route
       :mixins      [(compassus/did-mount (fn [_] (pushy/start! history)))
                     (compassus/will-unmount (fn [_] (pushy/stop! history)))]
        :reconciler (om/reconciler
                     {:state {:state state-atom}
                      ;;:parser (compassus/parser {:read read})
                      })}))


  (compassus/mount! app (gdom/getElement "app"))
)
