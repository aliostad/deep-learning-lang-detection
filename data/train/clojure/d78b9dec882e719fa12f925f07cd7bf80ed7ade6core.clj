(ns is-algo-proto.core
  (:gen-class)
  (:use [analemma.charts :only [emit-svg xy-plot add-points]]
    [analemma.svg]
    [analemma.xml]
    [clojure.java.io :only [file]]))

(require '[clojure.data.json :as json])
(use 'clj-time.format)
(require '[clj-time.coerce :as tc])

; MODIFY THESE FUNCTIONS TO CHANGE THE PRIORITY SCHEDULING
; -------------------------------------------------------
(defn priority-fn [priority]
  priority)

(defn time-til-due-fn [time-til-due]
  (if (= time-til-due 0)
    100000000000
    (* 4 (/ 172800 time-til-due))))

(defn time-to-finish-fn [time-to-finish]
  0)
; -------------------------------------------------------

(defn read-json-file [filename]
  (json/read-json (slurp filename)))

(defn write-json-file [m filename]
  (spit filename (json/write-str m)))

(defn to-time [m]
  ; divide by 1000 to convert to seconds
  (/ (tc/to-long (parse (formatters :date-hour-minute-second) m)) 1000))

(defn to-formatted [m]
  (unparse (formatters :date-hour-minute-second) (tc/from-long (* m 1000))))

(defn start-time [m]
  (m :start))

(defn end-time [m]
  (m :end))

(defn start-end-time-to-seconds [start-end-time]
  (-> start-end-time
    (assoc :start (to-time (start-end-time :start)))
    (assoc :end (to-time (start-end-time :end)))))

(defn start-end-time-to-formatted [start-end-time]
  (-> start-end-time
    (assoc :start (to-formatted (start-end-time :start)))
    (assoc :end (to-formatted (start-end-time :end)))))

(defn dispatch-times-to-seconds [dispatch]
  (-> (start-end-time-to-seconds dispatch) 
    (assoc :schedule (map start-end-time-to-seconds (dispatch :schedule)))
    (assoc :tasks (map #(assoc %1 :due (to-time (%1 :due))) (dispatch :tasks)))))

(defn dispatch-times-to-formatted [dispatch]
  (-> (start-end-time-to-formatted dispatch)
    (assoc :schedule (map start-end-time-to-formatted (dispatch :schedule)))
    (assoc :tasks (map #(assoc %1 :due (to-formatted (%1 :due))) (dispatch :tasks)))
    (assoc :failed (map #(assoc %1 :due (to-formatted (%1 :due))) (dispatch :failed)))))

(defn priority-factor [prio]
  (priority-fn prio))

(defn time-til-due-factor [due begin-time]
  (let [ttd (- due begin-time)]
    (time-til-due-fn ttd)))

(defn time-to-finish-factor [ttf]
  (time-to-finish-fn ttf))

(defn task-importance [task begin-time]
  (+ (priority-factor (task :priority))
     (time-til-due-factor (task :due) begin-time)
     (time-to-finish-factor (task :time))))

(defn sorted-schedule [schedule]
  (sort-by #(start-time %1) schedule))

; This function relies on schdeules not overlapping.
; In order to properly handle this it might be necessary
; to collapse down any overlapping schdeule events into
; one.  That, or we can modify this function.
(defn free-times [dispatch]
  (loop [s (sorted-schedule (dispatch :schedule)) t (start-time dispatch) free '[]]
    (if (empty? s)
      free
      (if (= t (start-time (first s)))
        (recur (rest s) (end-time (first s)) free)
        (recur
          (rest s)
          (end-time (first s))
          (conj free {
            :start t
            :end (start-time (first s))}))))))

(defn time-length [s]
  (- (end-time s) (start-time s)))

(defn sorted-tasks [dispatch]
  (reverse
    (sort-by #(task-importance %1 (dispatch :start)) (dispatch :tasks))))

(defn scheduled-dispatch-to-json-file [dispatch filename]
  (-> dispatch
    dispatch-times-to-formatted
    (write-json-file filename)))

(defn task-schedule [dispatch]
  (let [disp (dispatch-times-to-seconds dispatch)]
    (loop [dispatch (assoc disp :failed '[]) free (free-times disp) tasks (sorted-tasks disp)]
      (if (empty? tasks)
        dispatch
        (if (or
          ; if we've run out of empty blocks
          (empty? free)
          ; or if we've run past an allowable block for when a task is due (it's overdue)
          (> (+ ((first free) :start) ((first tasks) :time)) ((first tasks) :due)))
          (recur (assoc dispatch :failed (conj (dispatch :failed) (first tasks)))
            (free-times dispatch)
            (rest tasks))
          (if (<= ((first tasks) :time) (- ((first free) :end) ((first free) :start)))
            (let [new-disp
              (merge dispatch
                {:schedule (conj
                  (dispatch :schedule)
                  (merge (first tasks)
                    {:start ((first free) :start)
                     :end (+ ((first free) :start) ((first tasks) :time))
                     :task true}))})]
              (recur new-disp (free-times new-disp) (rest tasks)))
            (recur dispatch (rest free) tasks)))))))

(defn debug-priorities [dispatch]
  (assoc dispatch :tasks (map
    #(-> %1
      (assoc :priority-factor (priority-factor (%1 :priority)))
      (assoc :time-til-due-factor (time-til-due-factor (%1 :due) (dispatch :start)))
      (assoc :time-to-finish-factor (time-to-finish-factor (%1 :time)))
      (assoc :true-priority (task-importance %1 (dispatch :start)))
      (assoc :due (to-formatted (%1 :due))))
    (dispatch :tasks))))

(defn scaler [domain-min domain-max range-min range-max]
  (fn [val]
    (let [dom (- domain-max domain-min)
          ran (- range-max range-min)]
      (-> val 
        (- domain-min)
        (* ran)
        (/ dom)
        (+ range-min)
        float))))

(defn svg-schedule [dispatch]
  (let [entry-width 400
        box-height 1000
        s (scaler (start-time dispatch) (end-time dispatch) 0 box-height)]
    (emit
      (merge-attrs
        (svg
          (apply group
            (concat
              (map
                #(rect
                  0
                  (s (start-time %1))
                  (- (s (end-time %1)) (s (start-time %1)))
                  entry-width
                  :fill (if (contains? %1 :task) "#2E2EE6" "#FF0000"))
                (dispatch :schedule))
              (map
                #(-> (text {:x 0 :y (+ (s (start-time %1)) 8)} (%1 :name))
                   (style :fill "#000000"
                        :font-family "Garamond"
                        :font-size "15px"
                        :alignment-baseline :middle))
                (dispatch :schedule))))) {:width entry-width :height box-height}))))
