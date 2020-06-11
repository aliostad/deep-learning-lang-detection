(ns scplay.performance
  (:use [overtone.core])
  (:require [clojure.string :as str]
            [overtone.osc.util :as osc-util]))

;; Config defs
(def port 44100)
(def staging-osc-path "/key/")
(def adjustment-osc-path "/params/")

(defonce active-performances (atom #{}))

;; Staging
(defn- buffered-staging? [staging]
  (boolean (:buffer-size staging)))

(defn seq-next-stage-to-buffer [staging]
  (if (buffered-staging? staging)
    (let [{:keys [buffer-size
                  buffer
                  stage
                  stages]} staging]
      (if-let [phraseq (get stages stage)]
        (-> staging
            (assoc :buffer (->> phraseq
                                (take buffer-size)
                                vec))
            (update-in [:stages stage]
                       #(drop buffer-size %)))
        (do (prn (str "WARGING: stage " stage " has no phraseq assigned"))
            staging)))
    staging))

(defn- staged-performance? [performance]
  (boolean (:staging performance)))

(defn stage-performance [performance stage-key]
  (when (staged-performance? performance)
    (swap! (:staging performance)
           (fn [staging]
             (let [{:keys [stages]} staging]
               (if (contains? stages stage-key)
                 (-> staging
                     (assoc :stage stage-key)
                     seq-next-stage-to-buffer)
                 staging))))))

(defn stage-performances [stage-key]
  (swap! active-performances
         (fn [performances]
           (doseq [performance performances]
             (stage-performance performance stage-key))
           performances)))

(defn lineup->staging [lineup]
  (let [{:keys [repeat-phrases
                stage
                stages]} lineup
        staging {:stage stage
                 :stages stages}]
    (if repeat-phrases
      (assoc staging
             :buffer-size repeat-phrases
             :buffer-pos 0
             :buffer [])
      staging)))

;; Adjustment
(defn adjust-performance [performance control-key val]
  (let [{:keys [instrument
                effect
                params
                controls
                mono-node]} performance]
    (doseq [param-key (->> controls
                           (filter #(= (second %) control-key))
                           (map first))]
      (swap! params
             (fn [params]
               (if-let [inst-param (some #(when (= (keyword (:name %)) param-key) %)
                                         (:params (or effect instrument)))]
                 ;; TODO: use step
                 (let [{:keys [name min max step]} inst-param
                       min (or min 0.0)
                       max (or max 1.0)
                       val (scale-range val 0.0 1.0 min max)]
                   (when mono-node
                     (ctl mono-node param-key val))
                   (assoc params param-key val))
                 params))))))

(defn adjust-performances [param-key val]
  (swap! active-performances
         (fn [performances]
           (doseq [performance performances]
             (adjust-performance performance param-key val))
           performances)))

;; OSC preparations
(defonce peer (osc-server port "osc-clj"))

(defn osc-path->key [path]
  (-> path
      osc-util/split-path
      last
      keyword))

(defonce staging-osc-listener
  (osc-listen peer
              (fn [{:keys [path args]}]
                (when (and (pos? (first args))
                           (str/starts-with? path staging-osc-path))
                  (stage-performances (osc-path->key path))))
              :staging))

(defonce adjustment-osc-listener
  (osc-listen peer
              (fn [{:keys [path args]}]
                (when (str/starts-with? path adjustment-osc-path)
                  (adjust-performances (osc-path->key path) (first args))))
              :adjusting))

;; Performing
(defn- play-tone [node monophonic? metro phrase-beat params tone]
  (let [tone->params #(->> % :params
                           (merge params)
                           seq
                           flatten)
        beat (+ phrase-beat (:beat tone))
        node (at (metro beat)
                 (apply (if monophonic?
                          (partial ctl node)
                          node)
                        (tone->params tone)))
        length (:length tone)]
    (when length
      (let [beat (+ beat length)]
        (at (metro beat) (ctl node :gate 0))))
    node))

(defn- get-phrase [staging]
  (let [{:keys [stage
                stages
                buffer
                buffer-pos]} staging]
    (if (buffered-staging? staging)
      (buffer buffer-pos)
      (first (get stages stage)))))

(defn- seq-next-phrase [staging]
  (let [{:keys [stage
                buffer-size]} staging]
    (if (buffered-staging? staging)
      (update staging
              :buffer-pos
              #(mod (inc %) buffer-size))
      (update-in staging
                 [:stages stage]
                 rest))))

(defn perform-staging [metro performance]
  (when (staged-performance? performance)
    (when-let [staging @(:staging performance)]
      (let [{:keys [play-fn
                    monophonic?
                    mono-node]} performance
            params @(:params performance)
            phrase (get-phrase staging)
            phrase-beat (metro)
            node (if mono-node
                   mono-node
                   play-fn)]
        (swap! (:staging performance) seq-next-phrase)
        (apply-by (metro (+ phrase-beat (:length phrase)))
                  #'perform-staging
                  [metro performance])
        (doseq [tone (:tones phrase)]
          (play-tone node
                     monophonic?
                     metro
                     phrase-beat
                     params
                     tone))
        nil))))

(defn- lineup->play-fn [{:keys [instrument effect]}]
  (if effect
    (fn [& params]
      (inst-fx! instrument
                (fn [& args]
                  (apply effect (concat args params)))))
    instrument))

(defn- lineup->params [lineup]
  (let [{:keys [instrument
                params
                effect]} lineup
        inst-params (:params (or effect instrument))]
    (-> (->> inst-params
             (map (fn [{:keys [name default]}]
                    (let [param-key (keyword name)]
                      [param-key (or (param-key params)
                                     default)])))
             (into {}))
        (dissoc :bus))))

(defn make-performance [lineup]
  (let [{:keys [stage
                controls]} lineup
        performance (assoc lineup
                           :play-fn (lineup->play-fn lineup)
                           :params (-> lineup
                                       lineup->params
                                       atom))]
    (if stage
      (-> performance
          (assoc :staging (-> lineup
                              lineup->staging
                              seq-next-stage-to-buffer
                              atom))
          (dissoc :stage :stages))
      performance)))

(defn begin-performance [metro performance]
  (let [{:keys [monophonic?
                play-fn
                params]} performance
        performance (if (or (not (staged-performance? performance)) monophonic?)
                      (assoc performance
                             :mono-node (at (metro (metro))
                                            (apply play-fn
                                                   (-> @params
                                                       seq
                                                       flatten))))
                      performance)]
    (perform-staging metro performance)
    (swap! active-performances conj performance)
    performance))

(defn end-performance [performance]
  (swap! active-performances
         (fn [performances]
           (->> performances
                (remove (-> performance list set))
                (set))))
  (when (staged-performance? performance)
    (reset! (:staging performance) nil))
  (when-let [mono-node (:mono-node performance)]
    (kill mono-node)))
