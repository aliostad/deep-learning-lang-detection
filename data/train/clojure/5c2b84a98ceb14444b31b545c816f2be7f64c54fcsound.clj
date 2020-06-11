(ns interprocessing.csound
  (:import (csnd6 csnd6 Csound))
  (:require [clojure.core.matrix :as m]
            [clojure.core.matrix.stats :as stats]
            [clojure.java.io :as io]
            [clojure.string :as str]))

(defn init-csound []
  ; Turn off Csound's atexit and signal handlers.
  (csnd6/csoundInitialize (bit-or csnd6/CSOUNDINIT_NO_ATEXIT
                                  csnd6/CSOUNDINIT_NO_SIGNAL_HANDLER))
  (let [csound-instance (Csound.)
        orchestra (slurp (io/resource "csound/interprocessing.orc"))]
    (doto csound-instance
      (.SetOption "-o/dev/null")
      (.SetOption "-d")
      (.SetOption "-m0")
      (.CompileOrc orchestra)
      (.Start))))

(defn stop-csound [csound-instance]
  (doto csound-instance
    (.Cleanup)
    (.Stop)))

(defn set-channel-value [^Csound csound-instance channel-name value]
  (if (number? value)  ; Csound.SetChannel can't handle integers or ratios.
    (.SetChannel csound-instance channel-name (double value))
    (.SetChannel csound-instance channel-name value)))

(defn get-channel-value [^Csound csound-instance channel-name]
  (.GetChannel csound-instance channel-name))

(defn instr-event-str
  "Creates an instrument event string to be passed to Csound.InputMessage.

  Takes the instrument id (p1) and optionally:

    :duration   -- the instrument's p3 argument; if unspecified, the instrument
                   is given a magic number and is expected to set the duration
                   itself.
    :skip-time  -- the number of seconds to skip when opening the input file;
                   defaults to zero.
    :other-args -- other arguments to be appended to the string, typically input
                   and output files."
  [instr-id & {:keys [duration skip-time other-args]
               :or {duration 0xDEADBEEF
                    skip-time 0
                    other-args []}}]
  (let [start-time 0
        args (str/join \space
                       (map #(if (string? %) (str \" % \") %) other-args))]
    (str/join \space [\i instr-id start-time duration skip-time args])))

(defn analyze [^Csound csound-instance file & {:keys [skip-time duration]
                                               :or {skip-time 0}}]
  (if duration
    (.InputMessage csound-instance (instr-event-str 1
                                                    :skip-time skip-time
                                                    :duration duration
                                                    :other-args [file]))
    (.InputMessage csound-instance (instr-event-str 1
                                                    :skip-time skip-time
                                                    :other-args [file])))

  (loop [done? (get-channel-value csound-instance "analysis-done")
         values []]
    (if (not= done? 0.0)
      (do
        (set-channel-value csound-instance "analysis-done" 0.0)
        (zipmap [:centroid :cps :rms] (m/array (stats/mean values))))
      (let [centroid (get-channel-value csound-instance "centroid")
            cps (get-channel-value csound-instance "cps")
            rms (get-channel-value csound-instance "rms")]
        (.PerformKsmps csound-instance)
        (recur (get-channel-value csound-instance "analysis-done")
               (conj values [centroid cps rms]))))))

(defn process [^Csound csound-instance instr-id input-file output-file
               & {:keys [skip-time duration callback interval]
                  :or {skip-time 0}}]
  (if duration
    (.InputMessage
      csound-instance (instr-event-str instr-id
                                       :skip-time skip-time
                                       :duration duration
                                       :other-args [input-file output-file]))
    (.InputMessage
      csound-instance (instr-event-str instr-id
                                       :skip-time skip-time
                                       :other-args [input-file output-file])))
  (loop [last-callback (.GetScoreTime csound-instance)
         callback-index 1
         done? (get-channel-value csound-instance "processing-done")]
    (cond
      (not= done? 0.0)
      (set-channel-value csound-instance "processing-done" 0.0)

      callback
      (if (>= (- (.GetScoreTime csound-instance) last-callback) interval)
        (do
          (callback csound-instance callback-index)
          (.PerformKsmps csound-instance)
          (recur (.GetScoreTime csound-instance)
                 (inc callback-index)
                 (get-channel-value csound-instance "processing-done")))
        (do
          (.PerformKsmps csound-instance)
          (recur last-callback
                 callback-index
                 (get-channel-value csound-instance "processing-done"))))

      :else
      (do
        (.PerformKsmps csound-instance)
        (recur last-callback
               callback-index
               (get-channel-value csound-instance "processing-done"))))))
