(ns prais2.components.video-player
  (:require [rum.core :as rum :include-macros true]))

;(defn video-js-debug [s] (prn s))
(defn video-js-debug [s] nil)

(def use-video-js
  {:did-mount      (fn [state]
                     #?(:cljs (assoc state
                                ::player (.videojs js/window (:video-id (first (:rum/args state)))
                                                   (clj->js {})
                                                   #(video-js-debug (str (:video-id (first (:rum/args state)))
                                                                         " initialised"))))
                        :clj  state))

   :transfer-state (fn [old-state state]
                     #?(:cljs (assoc state ::player (::player old-state))
                        :clj  identity))

   :will-unmount   #?(:cljs (fn [state]
                              ;; :todo cross-browser test this sequence
                              (.pause (::player state))
                              (.dispose (::player state))
                              (dissoc state ::player))
                      :clj  identity)

   :should-update  (fn [_ _] false)                         ; prevent react from updating after render
   })
;;
;; Note that video-js wraps the <video> tag in a parent tag and needs to manage the
;; whole thing. After noticing this, I now create the whole video tag in HTML and inject
;; it using dangerouslySetInnerHTML. This prevents react from attempting to manage it.
;;
(rum.core/defc video-js < use-video-js
               [{:keys [video-id src controls preload poster track-src]
                 :or   {controls true preload "auto" poster "" track-src nil}}]
               [:.video-container
                {:dangerouslySetInnerHTML
                 {:__html
                  (str "<video "
                       "id=\"" video-id "\" "
                       "class=\"video-js vjs-default-skin vjs-big-play-centered\" "
                       "controls=\"" controls "\" "
                       "preload=\"" preload "\" "
                       "poster=\"" poster "\" "
                       "data-setup='{ \"aspectRatio\": \"480:270\" }'"
                       " >"
                       "<source src=\"" src "\" type=\"video/mp4\" >"
                       (when track-src (str "<track src=\"" track-src "\"
                                        label=\"captions-on\"
                                        kind=\"captions\" >"))
                       "</video>")}}])

;;
;; original unwrapped code. This causes react to complain on finding the div and the nested video
;; that video-js recreates, both having the same data-reactid.
;;
#_(rum.core/defc video-js  < use-video-js
  [{:keys [video-id src controls preload poster track-src]
    :or   {controls true preload "auto" poster "" track-src nil}}]

               [:video.video-js.vjs-default-skin.vjs-big-play-centered
                {:key                     2
                 :id                      video-id
                 :poster                  poster
                 :controls                controls
                 :preload                 preload
                 :width                   "100%"            ;; :todo
                 :dangerouslySetInnerHTML {:__html
                                           (str "<source src=\"" src "\" type=\"video/mp4\">"
                                                (when track-src (str "<track src=\"" track-src "\"
                                        label=\"captions-on\"
                                        kind=\"captions\">")))}}
                ])


