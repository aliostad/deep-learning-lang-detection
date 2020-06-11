(ns scplay.mixer
  (:use [overtone.core]
        [scplay.performance]))

(def mixer-buses {:master 0})

(defn target->bus [target]
  (cond (keyword? target) (target mixer-buses)
        (inst? target) (:bus target)
        :else (:master mixer-buses)))

(defn mixer-osc-handler [instrument mixer-control]
  (let [control ({:vol inst-volume!
                  :pan inst-pan!} mixer-control)]
    (fn [{:keys [args]}]
      (control instrument (first args)))))

(defn handle-instrument [instrument n]
  (let [unit-path (str "/mixer/" n)]
    (prn "registering osc-handler for mixer-unit with path:" unit-path)
    (osc-handle peer
                (str unit-path "/vol")
                (mixer-osc-handler instrument :vol))
    (osc-handle peer
                (str unit-path "/pan")
                (mixer-osc-handler instrument :pan))
    nil))

(defn handle-master []
  (osc-handle server
              "/mixer/master/vol"
              (fn [{:keys [args]}]
                (volume (first args)))))

(defn wire-mixer [layout]
  (handle-master)
  (mapv (fn [[input-inst output-inst] n]
          (let [bus (if (keyword? output-inst)
                      (mixer-buses output-inst)
                      (:bus output-inst))]
            (ctl (:mixer input-inst) :out-bus bus)
            (handle-instrument input-inst n))
          input-inst)
        layout (range)))

(defn unwire-mixer [mixer]
  (osc-rm-all-handlers server "/mixer")
  (doseq [instrument mixer]
    (ctl (:mixer instrument) :out-bus (:master mixer-buses)))
  nil)
