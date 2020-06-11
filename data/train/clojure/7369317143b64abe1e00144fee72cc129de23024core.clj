(ns placestart.core
  (:gen-class)
  (:require [seesaw.forms :as forms])
  (:use [seesaw.core]
        [seesaw.graphics]
        [placestart.place]))

; The world-rendering part of the content view
(def world-renderer
  (label :icon (pixmap-to-image @cur-board)))

; The system status display
(def system-status
  (vertical-panel :items
                  [(label :id :errors :text "Mismatching Pixels: N/A")
                   (label :id :wait :text "Wait Time: N/A")
                   (label :id :last :text "Last Action: N/A")]))

; The main UI content view
(def main-panel
  (vertical-panel :items [world-renderer
                          system-status]))

; The root panel of the UI
(def root-frame
  (frame
    :title "PlaceStartJVM Automated Maintenance"
    :size [800 :by 600]
    :content main-panel))

(def login-prompt-dialog
  (vertical-panel
    :items ["Please enter your Reddit username and password."
            "This data will not be stored, saved, or transmitted to anyone other than Reddit."
            (grid-bag-panel
              :items [["Username" :weightx 0]
                      [(text :id :user) :weightx 1 :fill :horizontal]])
            (grid-bag-panel
              :items [["Password" :weightx 0]
                      [(password :id :passwd) :weightx 1 :fill :horizontal]])]))

(defn- run-dialog
  "Construct and run a given dialog"
  [& opts]
  (-> (apply dialog opts)
      pack!
      show!))

(defn- get-login-info
  "Read login data from the user and return authentication data. User/password
  doesn't leave this function."
  []
  (loop []
    (let [creds (run-dialog
                  :content login-prompt-dialog
                  :title "Reddit Authentication"
                  :type :question
                  :option-type :ok-cancel
                  :success-fn (fn [pane]
                                {:user (value (select pane [:#user]))
                                 :passwd (value (select pane [:#passwd]))})
                  :cancel-fn (fn [p] nil))
          auth (try (login (:user creds) (:passwd creds))
                    (catch Exception e nil))]
      (if (nil? creds) nil
        (if (some? (:modhash auth)) auth
          (do
            (run-dialog :content "Error: Could not authenticate to Reddit")
            (recur)))))))

(defn- daemonize
  "Start a function running as a daemon thread"
  [f]
  (let [t (Thread. f)]
    (do (.setDaemon t true)
        (.start t)
        t)))

(defn- run-ui
  "Initialize and manage the user interface"
  [stop-atom]
  (-> root-frame
      pack!
      show!))

(defn- template-updater
  "Background thread to keep the template image up to date"
  [should-stop]
  (loop [since-update 0]
    (when-not @should-stop
      (if (> since-update (* 60 10)) ; update if it's been 10 minutes already
        (do (update-template) (recur 0))
        (do (Thread/sleep 1000) ; otherwise wait a second and check again
            (recur (inc since-update)))
      ))))

(def color-names {:white      "white"
                  :lightgray  "light gray"
                  :darkgray   "dark gray"
                  :black      "black"
                  :lightpink  "light pink"
                  :red        "red"
                  :orange     "orange"
                  :brown      "brown"
                  :yellow     "yellow"
                  :lightgreen "light green"
                  :green      "green"
                  :cyan       "cyan"
                  :grayblue   "gray blue"
                  :blue       "blue"
                  :pink       "pink"
                  :purple     "purple"})

(defn- show-action!
  "Update the Last Action label with the given label"
  [act]
  (let [act-color (get color-names (get-in act [:color]))
        act-old-color (get color-names (get-in act [:old-color]))
        act-x (get-in act [:pos 0]) act-y (get-in act [:pos 1])
        act-time (get act :wait_seconds)
        lbl-text (str "Last Action: "
                      (if (nil? act)
                        "None"
                        (str "Replace " act-old-color " at (" act-x
                            ", " act-y ") with " act-color)))]
    (do
      (invoke-later (text! (select system-status [:#last]) lbl-text)))))

(defn- active-delay
  "Wait for the given instant, and update the UI's wait timer while doing so"
  [should-stop instant]
  (loop []
    (let [now (java.time.Instant/now)
          until (java.time.Duration/between now instant)]
      (when-not (or @should-stop (.isAfter now instant))
        (invoke-later (text! (select system-status [:#wait])
                             (str "Wait Time: " (/ 1000 (.toMillis until)) "s")))
        (Thread/sleep 1)))))


(defn- main-loop
  "Background thread responsible for triggering updates and managing the timer"
  [auth should-stop]
  (while true (let [result (fix-one auth)
                    wait-time (java.time.Duration/ofSeconds (:wait_seconds result))
                    wait-end (.addTo wait-time (java.time.Instant/now))]
                (do
                  (show-action! result)
                  (active-delay should-stop wait-end)
                  ))))

(defn- app-main
  [auth]
  (let [stop-atom (atom false)
        updater (daemonize #(template-updater stop-atom))
        main (daemonize #(main-loop auth stop-atom))]
    (do
      (native!)
      (run-ui stop-atom)
      (println "Waiting for updater")
      (.join updater)
      (println "Waiting for main thread")
      (.join main))))

(defn -main
  [& args]
  (let [auth (do (native!) (get-login-info))] ; get username/password
    (if-not (nil? auth) (app-main auth))))
