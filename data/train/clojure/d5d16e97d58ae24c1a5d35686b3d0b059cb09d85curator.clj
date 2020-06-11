(ns embellir.curator
  (:gen-class)
  (:require [clj-time.local]
            [clj-time.core]
            [clj-time.coerce])
  )

; collection is a map of maps
; name is the main map key
; :atom
; :function
; :time-to-live
; :receiver-function TODO: need to add this to the curate function
;
; { "weather" {:atom <data for the curio>
;              :function update-weather
;              :time-to-live (* 1000 60 60)
;              :receiver-function nil}
;   "nowplaying" {...}}
;   
(defonce collection (atom {}))

;remember: .put .take .peek
(def updateq-comparator (comparator (fn [a b] (clj-time.core/before? (:time a) (:time b)))))
(def updateq
  "A list of maps with :time to be executed and :collection-key of item to be executed"
  (java.util.concurrent.PriorityBlockingQueue. 5 updateq-comparator))

(defn queue-item [itemname]
    (.put updateq {:collection-key itemname
                   :time (clj-time.coerce/to-date-time
                           (+ 
                             (get-in @collection [itemname :time-to-live])
                             (clj-time.coerce/to-long (clj-time.local/local-now))))}))

(defn find-curio [itemname]
  (let [home (System/getProperty "user.home")
        exts [".clj"]
        path ["src/embellir/curios" 
              "embellir/curios"
              (clojure.java.io/file home ".embellir/embellir/curios")]
        candidates (for [ e exts p path ] 
                     (let [f (clojure.java.io/file p (str itemname e))
                           r (clojure.java.io/resource (str  p "/" itemname e))
                           ]
                       (or (if (.exists f) [f e] ) 
                           (if-not (nil? r) [r e])) 
                       ))
        ]
      (first (drop-while nil? candidates))))

(defn get-curation-map [itemname]
  "try to find function that looks like embellir.curios.<itemname>/curation-map"
  "or else the fully-qualified function name, such as drh.datasupplier.curio/curation-map"
  (let [fqi (str "embellir.curios." itemname)]
      (load-reader (clojure.java.io/reader (first (find-curio itemname))))
    (when (find-ns (symbol fqi))
      (if-let [func (resolve (symbol fqi "curation-map"))] (func) (println "could not find" itemname)))))

(defn curate 
  "Define an item that the curator will watch over:
  itemname - handy string holding a human-friendly item name
  itemdata - the data you wish to curate; if it is a function, curate the result of that fn
  function - a function the curator will use to update the item
  note: swap! will be called on the itemdata and function
  time-to-live - the curator will update the atom after this amount of time passes
  note: milliseconds
  function - a function called when the bit dock receives a map for this curio"
  ([itemname]
   (when-let [cmap (get-curation-map itemname)] (curate itemname cmap)))
  ([itemname curation-map]
   (swap! collection #(assoc % itemname curation-map)) 
   (when-let [ttl (:time-to-live curation-map)] (queue-item itemname)))
  ([itemname itemdata function time-to-live]
   (curate itemname itemdata function time-to-live nil))
  ([itemname itemdata function time-to-live receiver-function]
   (assert (string? itemname))
   (assert (or (fn? function) (nil? function)))
   (assert (or (fn? receiver-function) (nil? receiver-function)))
   (assert (or (nil? time-to-live) (> time-to-live 0)))
   (swap! collection #(assoc % itemname
                             {:atom (atom itemdata)
                              :function function
                              :time-to-live time-to-live
                              :receiver-function receiver-function}))
   (when time-to-live (queue-item itemname)))
  )

(defn get-curio [itemname]
  (let [curio (get @collection itemname)]
    (when curio @(:atom curio))))

(defn receive-data-for-curio [itemname datamap]
  (let [item (get @collection itemname) 
        itematom (:atom item)
        itemfunc (:receiver-function item)]
    (when itemfunc (swap! itematom itemfunc datamap))))

(defn trash-curio [itemname]
  (swap! collection #(dissoc % itemname)))

(defn list-curios [] (keys @collection))

(defn run-item [itemname]
  "Fetch the item from @collection 
  Then apply the item's :function to the item's :atom"
  (let [item (get @collection itemname)
        itematom (:atom item)
        itemfunc (:function item)]
    (swap! itematom itemfunc)))

(defn manage-queue []
  (loop [item (.take ^java.util.concurrent.PriorityBlockingQueue updateq)]
    ;    (println "found item: " item (get item :collection-key))
    (try
      (let [itemtime (:time item)
            itemtimelong (clj-time.coerce/to-long (:time item))
            now (clj-time.coerce/to-long (clj-time.local/local-now))
            timedifference (- itemtimelong now)] ;negative when item time is in the past
        (if (< timedifference 0)
          (do (run-item (get item :collection-key))
            (queue-item (get item :collection-key)))
          (do (Thread/sleep (min timedifference 1000))
            (.put updateq item))))
      (catch Exception e (str "Exception in manage-queue: " (.getMessage e))))
    (recur (.take ^java.util.concurrent.PriorityBlockingQueue updateq))))

(defn start-curator []
  "Starts the curator in a separate thread"
  (.start (Thread. manage-queue)))

