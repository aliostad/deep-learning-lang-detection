(ns klangmeister.processing
  (:require
    [klangmeister.compile.eval :as eval]
    [klangmeister.ui.reference :as reference]
    [klangmeister.sound.music :as music]
    [klangmeister.sound.instruments :as instrument]
    [klangmeister.actions :as action]
;;    [klangmeister.framework :as framework]
    [ajax.core :as ajax]
    [leipzig.melody :as melody]))

(defn too-many? [value]
  (when (and (seq? value) (->> value (drop 1000) first))
    "Too many notes - Klangmeister can't handle more than 1000."))

(defn well-formed? [value]
  (letfn [(ok? [{:keys [time duration]}] (and time duration))]
    (when (and (seq? value) (not-every? ok? value))
      "All notes must have a time and a duration.")))

(defn check [{:keys [value error] :as return} ok?]
  (if error
    return
    (assoc return :error (ok? value))))


(def gist-uri (partial str "https://api.github.com/gists/"))


; action/Refresh
(defn refresh [state {expr-str :text pane :target}]
  (let [{:keys [value error]} (-> expr-str
                                  eval/uate
                                  (check too-many?)
                                  (check well-formed?))]
    (if error
      (-> state
          (assoc-in [pane :error] error)
          (assoc-in [pane :text] expr-str))
      (-> state
          (assoc-in [pane :error] nil)
          (assoc-in [pane :value] value)
          (assoc-in [pane :text] expr-str)))))



;  action/Gist
(defn gist [{gist :gist pane :target} handle! state]
    (let [refresh #(handle! (action/->Refresh % pane))
          handler #(-> % :files vals first :content refresh)]
      (ajax/GET (gist-uri gist) {:handler handler :response-format :json :keywords? true})
      state))

;  action/Import
(defn import [{uri :uri pane :target} handle! state]
    (let [refresh #(handle! (action/->Refresh % pane))]
      (ajax/GET uri {:handler refresh})
      state))

;  action/Stop
(defn stop [{pane :target} state]
    (assoc-in state [pane :looping?] false))

;  action/Play
;(defn play [{pane :target :as this} handle! state]
;    (if-not (< (Date.now) (get-in state [pane :sync]))
;      (framework/process (action/->Loop pane) handle! (assoc-in state [pane :looping?] true))
;      state))

;  action/PlayOnce
(defn play-once [{:keys [audiocontext] :as state} {pane :target :as this} ]
    (let [{:keys [value text]} (pane state)]

      (->> value
           (melody/wherever (comp not :instrument), :instrument (melody/is instrument/bell))
           (music/play! audiocontext))
      state))

;  action/Doc
(defn doc [{pane :target doc :string} state]
    (-> state
        (assoc-in [pane :doc]
                  (when-let [documentation (reference/all doc)]
                    (cons doc documentation)))))

;  action/Test
;(defn test [{pane :target :as this} handle! {:keys [audiocontext] :as state}]
;    (let [{:keys [value]} (pane state)]
;      (music/play! audiocontext [{:time 0 :duration 1 :instrument (constantly value)}])
;      state))

 ; action/Loop
;(defn loop [{pane :target :as this} handle! {:keys [audiocontext] :as state}]
;    (let [{:keys [value looping?]} (pane state)
;          duration (* 1000 (melody/duration value))
;          finish (+ (Date.now) duration)]
;      (if looping?
;        (do (music/play! audiocontext value)
;            (js/setTimeout #(handle! this) duration)
;            (assoc-in state [pane :sync] finish))
;        (assoc-in state [pane :sync] nil))))
