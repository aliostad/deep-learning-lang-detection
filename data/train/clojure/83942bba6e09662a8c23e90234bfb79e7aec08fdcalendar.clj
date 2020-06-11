(ns experiment.views.calendar
  (:require
   [clojure.tools.logging :as log]
   [experiment.models.user :as user]
   [experiment.infra.session :as session]
   [experiment.libs.datetime :as dt]
   [experiment.models.schedule :as sched]
   [experiment.models.events :as events]
   [experiment.models.eventlog :as eventlog]
   [clj-time.core :as time])
  (:use experiment.infra.models
	noir.core
	hiccup.core
	hiccup.page-helpers
	hiccup.form-helpers
	handlebars.templates))

;; ==================================
;; Calendar View
;; ==================================

(def ^{:dynamic true} *events* nil)
(def ^{:dynamic true} *month-dt* nil)

(defn today? [day]
  (when *month-dt*
    (let [month (.toDateTime *month-dt* (org.joda.time.LocalTime. 0 0))]
      (and (time/after? (dt/now) month)
           (time/before? (dt/now) (time/plus month (time/months 1)))
           (= day (.getDayOfMonth (dt/now)))))))

;; Event Computation

(defn events-for-day [day]
  (*events* day))

(defn treatment? [event]
  (nil? (:instrument event)))

(defn convert-event [event]
  (assoc (server->client event true)
    :instrument (:instrument event)))

(defn render-event [event]
  (if (:instrument event)
    (let [instrument (resolve-dbref (:instrument event))]
      [:div.event-view
       [:a.view-timeline {:href "#"}
        [:i.icon-eye-open]] "&nbsp;Track&nbsp;"
       (:variable instrument) " -- " (:service instrument) " at " (:local-time event)])
    [:div.event-view
     [:i.icon-comment] "&nbsp;Treament Reminder&nbsp; at " (:local-time event)]))

(defn- events-daily-map [events-map]
  (apply hash-map
         (mapcat (fn [[dt events]]
                   [(.getDayOfMonth dt)
                    (map convert-event events)])
                 events-map)))

;; Compute Day Entry

(defn day-class [day events]
  (if (nil? day)
    "padding"
    (clojure.string/join
     " "
     [(when day "day")
      (when (today? day) "today")
      (when events "date_has_event")
      (when (and events (some treatment? events)) "treat")])))

(defn day-popover-content [day events]
  (when events
    (html
     [:div {:class "events"}
      (doall (map render-event events))])))

(defn day-title [day]
  (when day
    (str "Events for "
         (dt/as-short-date
          (.withDayOfMonth *month-dt* day)))))

(defn day-date [day]
  (when day
    (dt/as-iso-8601-date (time/plus *month-dt* (time/days (- day 1))))))

(defpartial render-day [day]
  (let [events (events-for-day day)
        class (day-class day events)
        content (day-popover-content day events)
        table *events*]
    [:td {:class class
          :data-content content
          :data-original-title (day-title day)
          :data-date (day-date day)}
     (or day "")]))
  
;; Compute Week

(defpartial render-first-week [padding range]
  [:tr
   (map render-day (repeat padding nil))
   (map render-day range)])

(defpartial render-week [[padding range]]
  [:tr
   (map render-day range)
   (map render-day (repeat padding nil))])


;; Compute Month Layout

(defn- make-month [dt]
  (.toLocalDate dt))

(defn- month-padding [month-interval]
  (let [offset (.getDayOfWeek (make-month (.getStart month-interval)))]
    (if (> offset 6)
      (- offset 7)
      offset)))

(defn- month-end-day [month-interval]
  (+ 1 (.getDayOfMonth (make-month (.getEnd month-interval)))))

(defn- compute-weeks [interval]
  (let [start-pad (month-padding interval)
        last-day (month-end-day interval)]
    (letfn [(week [start]
              (let [next (+ start 7)]
                (cond (<= last-day start)
                      nil
                      (< last-day next)
                      (cons [(- next last-day) (range start last-day)] (week next))
                      true
                      (cons [0 (range start (+ start 7))] (week next)))))]
      [start-pad (week (- 8 start-pad))])))
		 
;; Render Calendar

(defpartial render-calendar-header []
  [:thead
   [:tr (map (fn [day] [:th day])
             ["Sun" "Mon" "Tue" "Wed" "Thu" "Fri" "Sat"])]])

(defpartial render-calendar-table [interval events-map]
  (let [[start-pad weeks] (compute-weeks interval)]
    (binding [*month-dt* (make-month (.getStart interval))
              *events* (doall (events-daily-map events-map))]
      [:div {:class "calendar"}
       [:table {:cellspacing 0}
        (render-calendar-header)
        [:tbody
         (doall
          (cons (render-first-week start-pad (range 1 (- 8 start-pad)))
                (map render-week weeks)))]]])))

;;
;; Calendar Client REST API
;;

(deftemplate small-calendar
  [:div.small-calendar
   [:div.cal-header
    (%if title [:h3 {:style "text-align: center;"} (% title)])
    [:ul.pager
     [:li.previous [:a {:href "#"} "&larr; Previous"]]
     [:li.now [:a {:href "#"} (% date)]]
     [:li.next [:a {:href "#"} "Next &rarr;"]]]]
   [:div.cal-body]])

(defpage trial-calendar [:get "/api/calendar/trial/:id"]
  {:keys [id year month start]}
  (let [trial (user/get-trial (session/current-user) id)
        start (or start (str (dt/as-utc (dt/now))))]
    (try 
      (render-calendar-table
       (when (and month (not (= month "now")))
         [(Integer/parseInt year)
          (Integer/parseInt month)
          (Long/parseLong start)])
       []))))

(defn interval-for-month [year month]
  (let [dt (if (and year month)
             (org.joda.time.DateTime. year month 1 0 0)
             (-> (dt/now)
                 (.withDayOfMonth 1)
                 (.withHourOfDay 0)
                 (.withMinuteOfHour 0)
                 (.withSecondOfMinute 0)))
        dt (cond (not year ) dt
                 (> year 2000) (.withYearOfCentury dt (- year 2000))
                 (> year 1900) (.minusYears (.withYearOfCentury dt (- year 2000)) 100))
        dt (if month (.withMonthOfYear dt month) dt)]
    (time/interval dt (.minusSeconds (.plusMonths dt 1) 1))))
        
(defpage user-calendar [:get "/api/calendar/user"]
  {:keys [year month]}
  (let [user (session/current-user)
        interval (interval-for-month (Integer/parseInt year) (Integer/parseInt month))
        events-map (eventlog/group-by-start-day
                    (eventlog/event-timeline
                     user (.getStart interval) (.getEnd interval)))]
    (try
      (render-calendar-table interval events-map))))

       
  
;;			     (mapcat #(sched/events % (filter (partial events/future-reminder? start)
;;                                                              (events/trial-reminders trial)))
;;      (catch java.lang.Throwable e
;;	"<b>Calendar Render Error</b>"))))))

;;(defpage experiment-calendar [:get "/api/calendar/experiment/:id"] {:keys [id]}
;;  (let [experiment (resolve-dbref "experiment" id)]
;;    (try
;;      (render-calendar-table nil (generate-reminders experiment (dt/now)
;;						     {:reminders? true}))
;;      (catch java.lang.Throwable e
;;	"<b>Calendar Render Error</b>"))))
