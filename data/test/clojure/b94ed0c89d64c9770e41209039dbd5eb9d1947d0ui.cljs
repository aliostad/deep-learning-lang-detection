(ns githubpage2html-spa.ui
  (:require [re-frame.core :as re-frame]
            [reagent.core :as reagent]))

(defn dispatch
  "Re-frame dispatch enhanced for UI. On top of re-frame-dispatching args, it:
  * stops the default handling from happening, so links and forms don't get submitted.
  * it dispatches ui-interaction, currently used to hide old alerts
  * passes the target of the event (the form or link) as the last argument to the re-frame-dispatch."
  [js-event event]
  (.preventDefault js-event)
  ;(re-frame/dispatch [:ui-interaction])
  (re-frame/dispatch (conj event (.-target js-event))))