;;; An I/O is an identifying symbol for an input or output instrument
;;; connected to a PortMidi device, along with the PM device name and a
;;; display name.

(ns pmtest.io
  (:use [pmtest.portmidi :as portmidi]))

(defn make-io
  [input-or-output sym port-name display-name]
  {:type input-or-output :sym sym :port-name port-name :display-name display-name})

(defn open-io
  "Given an input IO, open a PortMidi stream and return an updated IO
  with :stream set."
  [io]
  (assoc io :stream
         (if (= :input (:type io))
           (portmidi/open-input-named (:port-name io))
           (portmidi/open-output-named (:port-name io)))))

(defn close-io
  [io]
  (when-let [stream (:stream io)]
    (portmidi/close stream))
  (assoc io :stream nil))
