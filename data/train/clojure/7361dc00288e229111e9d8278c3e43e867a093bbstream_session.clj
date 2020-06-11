(ns efreports.helpers.stream-session
  (:use   [ring.middleware.session.store]
          [monger.ring.session-store :only [session-store]])
  (:require [clj-time.core :as clj-time]
            [clojure.string :as clj-string]
            [efreports.models.streams-model :as stream-model]
            [efreports.helpers.stream-manipulations :as stream-manip]
            [monger.joda-time]
            [monger.json]))


(def ^:const dflt-col-display 6)


;; tenative session data layout
; {:streams ({:filter-keys [:fk_use_1 :fk_rooms_type], :name "rooms 3613"} {:filter-keys ["why" "now"], :name "no"}), :some "other"}

(defn stream-list
  "A list of streams that have been accessed a given user"
  [user]
  (let [sess (read-session (session-store "sessions") user)]
    (get sess :streams)))

(defn stream-attributes
  "All of the attributes associated with a given stream"
  [user stream]
  (first (filter #(= (% :name) stream) (stream-list user))))

(defn column-map-ordering
  [user stream]
    (let [str-attr (stream-attributes user stream)]
      (when-not (nil? str-attr) (str-attr :column-map-ordering))))

(defn pivot-totals
  [user stream]
    (let [str-attr (stream-attributes user stream)]
      (when-not (nil? str-attr) (str-attr :pivot-totals))))


(defn write-stream [user stream data-map]

  (let [str-list (filter #(not (= (% :name) stream)) (stream-list user))
        str-inst (filter #(= (% :name) stream) (stream-list user))]
    (when (empty? str-inst)
      (write-session (session-store "sessions") user (assoc {} :streams (seq [(assoc {} :name stream)]))))
    (write-session (session-store "sessions") user (assoc {} :streams
          (conj str-list (merge (stream-attributes user stream) data-map))))))


(defn write-stream-keys
  "Update a stream attribute whose value is a vector of keys"
  [user stream main-key key-data]
  (write-stream user stream (assoc {} main-key key-data)))


(defn remove-stream [user stream]
  "Remove a stream from a user's session"
  (let [streams (stream-list user)
        mod-streams (remove #(= (% :name) stream) streams)]
      (write-session (session-store "sessions") user (assoc {} :streams mod-streams))

    ))

(defn insert-column-into-column-map-ordering
  [user stream column-map-ordering-instance column-map-ordering position]

   (write-stream-keys user stream :column-map-ordering
                      (stream-manip/insert-column-into-column-map-ordering column-map-ordering-instance
                                                              column-map-ordering
                                                              position))
  ((stream-attributes user stream) :column-map-ordering))


(defn concat-column-map-ordering
  [user existing-stream mapped-cols]
  (write-stream-keys user existing-stream :column-map-ordering
                     (stream-manip/concat-column-map-ordering
                        (column-map-ordering user existing-stream) mapped-cols)))


(defn move-column-to-back [user stream column-map-ordering column-name]
  (let [colmap-inst (first (filter #(= (% :name) column-name) column-map-ordering))]
    (when-not (empty? colmap-inst)
      (let [col-index (colmap-inst :order)]
        (when-not (= (- (count column-map-ordering) 1) (colmap-inst :order))
          (write-stream-keys user stream :column-map-ordering
            (concat
                  (cons
                     (merge  (dissoc colmap-inst :order) {:order (- (count column-map-ordering) 1)})
                     (filter #(< (% :order) col-index) column-map-ordering))
              (for [m (filter #(> (% :order) col-index) column-map-ordering)] (update-in m [:order] dec)))))))))


(defn move-column-to-position [user stream column-map-ordering column-name position]
   (println (str "move-column-to-position " (first (filter #(= (% :name) column-name) column-map-ordering))))
   (insert-column-into-column-map-ordering user stream
                                           (first (filter #(= (% :name) column-name) column-map-ordering))
                                           column-map-ordering
                                           position))


(defn stream-empty? [user stream]
  (let [sa (dissoc (stream-attributes user stream) :last-refresh)]
    (and (nil? (sa :filter-cols)) (nil? (sa :total-cols))
         (nil? (sa :mapped-streams)) (nil? (sa :sort-map))
         (or (nil? (sa :pivot-totals)) (empty? (sa :pivot-totals)))
         )))

(defn stream-last-refresh
  [user stream]
  ((stream-attributes user stream) :last-refresh))



(defn column-display-count
  [user stream]
  (let [str-attr (stream-attributes user stream)]
    (when-not (nil? str-attr) (str-attr :column-display-count))))

(defn copy-check-params-to-session
  "Copy http request params who have a value set to true into the session by the stream name and keycol"
  [stream-name stream-params user keycol]
  (let [cols (keys (select-keys stream-params (for [[k,v] stream-params :when (= v "true")] k)))]
    (write-stream-keys user stream-name keycol cols) cols))


(defn create-and-write-pivot-cmo [user stream column-map ]
  (let [new-cmo (stream-manip/init-column-map-ordering column-map 0)]
    (write-stream-keys user stream :column-map-ordering new-cmo)
    new-cmo))


(defn init-stream-session
  "Initialize an empty stream session to make it easier for us to update later"
  [user stream]

  (println "why no init?")
  
  (when (empty? (filter #(= (% :name) stream)
                 ((read-session (session-store "sessions") user) :streams)))
    (println "initting session...")
    (write-stream
                   user stream {:column-display-count dflt-col-display
                                         :filter-cols nil :total-cols nil :mapped-streams nil
                                         :sort-map nil :last-refresh (clj-time/now)
                                         :column-map-ordering (stream-manip/init-column-map-ordering ((stream-model/find-stream-map stream) :column-map) 0)})
    ))


