(ns condense.performance
  (:require-macros [cljs.core.async.macros :refer [go alt!]])
  (:require [om.core :as om]
            [cljs.core.async :refer [put! chan dropping-buffer timeout]]))


; Globals
(def perf-counters (atom {}))


; Internal use.  We watch the atom and use a dropping channel to
; feed into the state machine.
(def counter-ch (chan (dropping-buffer 1)))
(add-watch perf-counters :counter-listener #(put! counter-ch :changed))


(defn debug-view
  "Wrapper view for counting render events.  Answers the question:
  how many components are being rerendered."
  [[f cursor opts] owner]
  (reify
    om/IDisplayName
    (display-name [_] "PerformanceDebugWrapper")
    om/IRender
    (render [c]
      (let [fname (.. c -f -name)]
        (swap! perf-counters update-in [fname] inc))
      (om/build* f cursor opts))))


(defn performance-instrument
  "Instrument function for use counting :instrument (build) and render calls"
  [f cursor opts]
  (swap! perf-counters update-in ["instrument"] inc)
  (om/build* debug-view [f cursor opts]))


(defn enable-performance-reporting
  "Sets up a core async loop to report on counters.  Waits for 1 second of
  silence before reporting aggregates since last report."
  []
  (go (loop [state :idle
             before @perf-counters]
        (case state
          :idle (alt! counter-ch (recur :active before))
          :active (let [timeout-ch (timeout 1000)
                        after @perf-counters]
                    (alt! timeout-ch (do (println :timeout (str (->> (merge-with - after before)
                                                                     (filter (comp pos? second))
                                                                     (sort-by (comp - second)))))
                                         (recur :idle after))
                          counter-ch (do (recur :active before))))))))