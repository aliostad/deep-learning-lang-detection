(ns omodoro.components.clock
  (:require-macros [cljs.core.async.macros :refer [go]])
  (:require [om.core :as om :include-macros true]
            [om.dom :as dom :include-macros true]
            [cljs.core.async :refer [chan <! >! put! timeout]]))

;; Next Steps:
;; Done: Control ticking of the clock - start, pause, reset
;; Done: When clock is finished, set state to :finished, then inc completed pomodoro
;; Done: Add hover play/pause interaction
;; Add ability to one off override duration of a cycle
;; If the pomodoro is paused for more than 3 minutes then auto reset

(defn set-cycle-duration! [pobk {:keys [clock day settings] :as state}]
  "Reset the clock to the appropriate amount of time according to whether you need a long break, short break, or pomodoro."
  (let [scd! (fn [time pob-k] ;; pob-k ->> pom-or-break key from app state
               (do
                 (om/update! clock :seconds time)
                 (om/update! clock :pom-or-break pob-k)))]
    (cond
     (= pobk :lbreak) (scd! (* 60 (:long-break @settings)) :lbreak)
     (= pobk :sbreak) (scd! (* 60 (:short-break @settings)) :sbreak)
     :else   (scd! (* 60 (:pom-length @settings)) :pom))))

(defn do-after-pom! [{:keys [clock day] :as state}]
  "Perform these actions post pomodoro timer and pre break timer"
  (do
    (om/transact! day :completed inc)
    (om/transact! day :until-break dec)
    (let [break-type (if (= 0 (:until-break @day)) :lbreak :sbreak)]
      (set-cycle-duration! break-type state))
    (om/update! clock :current-timer-state :finished)))

(defn do-after-break! [{:keys [clock day settings] :as state}]
  "Perform these actions after a break and before a pomodoro"
  (do
    (set-cycle-duration! :pom state)
    (om/update! clock :current-timer-state :finished)))

(defn tick! [{:keys [clock settings day] :as state}]
  (let [tick-once! (fn []
                     (when (and
                            (= :ticking (:current-timer-state @clock))
                            (< 0 (:seconds @clock)))
                       (om/transact! clock :seconds dec)))
        check-finished! (fn []
                          "when the timer is exhausted, set the time to the duration of the next cycle"
                          (when (and
                                 (= 0 (:seconds @clock))
                                 (= :ticking (:current-timer-state @clock)))
                            (let [pob (:pom-or-break @clock)
                                  next (cond
                                        (and (= pob :pom) (= 0 (:until-break @day))) :lbreak
                                        (and (= pob :pom) (not= 0 (:until-break @day))) :sbreak
                                        :else :pom)]
                              (cond
                               (= pob :pom) (do-after-pom! state)
                               :else (do-after-break! state)))))
        reset-time! (fn []
                      "If the clock is set to :new this updates it with the right amount of time.  If it is :finished then it will auto start depending on user settings."
                      (let [cts (:current-timer-state @clock)
                            auto (:auto-start @settings)]
                        (when (= :new cts)
                          (set-cycle-duration! (:pom-or-break @clock) state))
                        (when (= :finished cts)
                          (when (some #{(:pom-or-break @clock)} (:auto-start @settings))
                            (om/update! clock :current-timer-state :ticking)))))
        manage-clock! (fn []
                        (do
                          #_(js/console.log "managing clock!!")
                          (tick-once!)
                          (check-finished!)
                          (reset-time!)))]
    (js/setInterval manage-clock! 1000)))

(defn pad [n]
  (if (<= 0 n 9)
    (str "0" n)
    (str n)))

;; store in app state status of clock
;; if clock is new, then show overlay with play button
;; if clock is ticking, then hide overlay with pause button
;; if clock is paused, then show overlay with play button
;; if clock is finished, then show overlay with reset button

(defn overlay [cts]
  (let [overlay-markup
        (fn [overlay-class icon-class]
          (dom/div #js {:className (str "overlay " overlay-class)}
                   (dom/i #js {:className (str "fa " icon-class)})))]
    (condp = cts
      :new (overlay-markup "show" "fa-play-circle")
      :ticking (overlay-markup "hide" "fa-pause")
      :paused (overlay-markup "show" "fa-play-circle")
      :finished (overlay-markup "show" "fa-history")
      (js/console.log "Default class: " cts))))

(defn click-clock! [cts]
  "Transition the state of the timer when the clock is clicked.
If the state on the left gets clicked, it should become the state on the right."
  (condp = cts
    :new :ticking
    :ticking :paused
    :paused :ticking
    :finished :new
    (js/console.log "Click-clock cts: " cts)))

(defn display-clock [{:keys [seconds current-timer-state] :as app}]
  (let [minutes (int (/ seconds 60))
        seconds (rem seconds 60)]
    (dom/div #js {:id "clock-container"}
      (dom/div #js {:id "clock"
                    :onClick #(om/transact! app :current-timer-state click-clock!)}
        (overlay current-timer-state)
        (str (pad minutes) ":" (pad seconds))))))

(defn task-info [app]
  (let [display-task? (if (= nil (:task-id app)) "none" "block")]
    (dom/div #js {:style #js {:display display-task?}}
             "This is task info")))

(defn start-pause-resume-reset-btns [app]
  (let [cts (:current-timer-state app)
        classname (condp = cts
                    :new "timerNew"
                    :ticking "timerTicking"
                    :paused "timerPaused"
                    :finished "timerFinished")
        change-cts-to #(om/update! app :current-timer-state %)]
    (dom/div #js {:className (str "timerBtnContainer " classname)}
             (dom/div #js {:className "timerBtn" :id "start-btn"
                           :onClick #(change-cts-to :ticking)} "START")
             (dom/div #js {:className "timerBtn" :id "pause-btn"
                           :onClick #(change-cts-to :paused)} "PAUSE")
             (dom/div #js {:className "timerBtn" :id "resume-btn"
                           :onClick #(change-cts-to :ticking)} "RESUME")
             (dom/div #js {:className "timerBtn" :id "reset-btn"
                           :onClick #(change-cts-to :new)} "RESET"))))

(defn clock-widget [{:keys [clock settings day] :as app} owner opts]
  (reify
    om/IDidMount
    (did-mount [_]
      (when (= nil (:interval clock))
        (om/update! clock :interval (tick! app))))
    om/IRender
    (render [_]
      (dom/div nil
        (display-clock clock)
        (dom/div #js {:className "taskInfo" })
        (start-pause-resume-reset-btns clock)))))

