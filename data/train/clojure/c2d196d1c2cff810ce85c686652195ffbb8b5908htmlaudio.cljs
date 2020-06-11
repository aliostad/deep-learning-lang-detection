(ns cloj.experimental.html.audio
  )

;; =============================================================================
;; {{{ Web Audio
(defprotocol IAudio
  (sq [_ ])
  (tri [_ ])
  (saw [_ ]))

(defprotocol ISFX
  (instrument [_])
  (type! [_ t])
  (freq! [_ v])
  (start! [_])
  (stop! [_])
  (vol! [_ v]))

(defn mk-ins
  ([ctx osc-type]
   (let [ins (mk-ins ctx)]
     (do
       (type! ins osc-type))
     ins))

  ([ctx]
   (let [vco (.createOscillator ctx)
         vca (.createGain ctx)
         ret (reify
               ISFX
               (instrument [_] {:vco vco :vca vca})
               (start! [_] (.start vco))
               (stop!  [_] (.stop vco))
               (type!  [_ osc-type] (set! (.-type vco) osc-type))
               (vol!   [_ volume] (set! (.-value (.-gain vca)) volume))
               (freq!  [_ freq] (set! (.-value  (.-frequency vco)) freq))) ]
     (do
       (.connect vco vca)
       (.connect vca (.-destination ctx)))
     ret))
  )

(defonce audio-html 
  (let [constructor (or js/window.AudioContext
                        js/window.webkitAudioContext)
        ctx (constructor.) ]
    (reify
      IAudio
      (sq [_]
        (mk-ins ctx "square")))))

(defonce sq-1 (sq audio-html))
(defonce sq-2 (sq audio-html))

#_(do
    (freq! sq-1 30)
    (freq! sq-2 30.13721)
    (vol! sq-1 5)
    (vol! sq-2 5)
    (start! sq-1 )
    (start! sq-2 )
    )

;; }}}


