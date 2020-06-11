(ns efreports.views.streams.streams-view
  (:use [hiccup.def]
        [hiccup.core]
        [hiccup.form :only (form-to check-box label text-area
                            text-field hidden-field submit-button)]
        [hiccup.page :only [include-js]]
        [ring.middleware.session.store]
        [ring.util.codec :only [form-encode]]
        [monger.ring.session-store :only [session-store]]
        [efreports.helpers.data :only [sort-column-map]])
  (:require [efreports.views.layout :as layout]
            [efreports.models.reports-model :as report-model]
            [efreports.views.streams.streams-markup :as sm]
            [efreports.helpers.html-components :as hc]
            [clojure.string :as clj-string]
            [efreports.helpers.stream-session :as stream-sess])
  (:import  [java.lang String]))


(defn new-stream [stream]
    (println "stream map in view " stream)
    (layout/common "New Stream" (stream :username)

                   (concat
                     (if (stream :flash)
                         (html [:div {:class "alert alert-danger alert-dismissable"}
                                [:button {:type "button" :class "close" :data-dismiss "alert" :aria-hidden "true"} "&times;"]
                                [:strong (stream :flash)]])
                          "")
                   (sm/stream-form {:action "create"}))))

(defn display-all [streams reports]
  (concat (hc/panel-container (html [:i {:class "icon-th-large"}] "&nbsp;Collections")
                                         (sm/streams-container streams))
          (hc/panel-container (html [:i {:class "icon-list-alt"}] "&nbsp;Reports")
                              (sm/reports-container reports))))


(defn query-string-suffix [stream-params]
  (let [stripped-params (select-keys stream-params (for [[k,v] stream-params :when (not (= k ""))] k))] ;; we are getting a param that is "" nil; so for now strip it out.
    (clj-string/replace (clj-string/replace (form-encode stripped-params) #"\+" "%20") #"\*=" "?")))    ;; todo: figure out why this is happening and fix the root cause

(defn stream-data-body [stream-params rs per page rs-total related-streams colmap manip-fn]
  (concat

         (html [:div {:class "row"}
                  [:div {:class "col-md-3"} [:h4 (str "Returned " rs-total " items")]]
                                          [:div {:class "col-md-9"} (sm/download-formats-button
                                           (str "/streams/data-body/" (stream-params :stream)))]])
         (sm/filter-pills ((stream-sess/stream-attributes (stream-params :username) (stream-params :stream)) :filter-map) colmap)
         (sm/rs-to-report-table (stream-params :stream)
                                  (if (contains? stream-params :to-stream)(stream-params :to-stream) (str ""))
                                  rs
                                  (map name ((stream-sess/stream-attributes (stream-params :username)
                                                                            (stream-params :stream)) :filter-cols))
;;                                       (sort-column-map colmap
;;                                                        (stream-sess/column-map-ordering :actual-username
;;                                                                                         (stream-params :stream)))
                                  colmap
                                  manip-fn (query-string-suffix stream-params) rs-total
                                   (stream-sess/column-display-count (stream-params :username) (stream-params :stream))
                                  "stream"

                                )

          (hc/pagination-bar (stream-params :stream) per page rs-total)
          ;;(hc/pagination-js (stream-params :stream) per page rs-total)
   ))


;part of the async stream retrieval functionality
;todo: add data elements to markup with stream info for ajax call
(defn data-stream-header [stream-params related-streams jsfile manip-fn]

  (let [title (stream-params :stream-name)
        latest-report (report-model/find-latest-report-map-by-user-and-stream
                         (stream-params :username) (stream-params :stream-name))
        base-column-map (stream-params :column-map)
        alpha-sorted-column-map (into (sorted-map-by (fn [key1 key2]
                                    (compare [(get base-column-map key1) key1]
                                             [(get base-column-map key2) key2])))
                                       base-column-map) ;;right from clojuredocs - pretty dirty
        ]
    (layout/common title (stream-params :username)
      (concat (html [:h2 (str "Collection - " (stream-params :description))])

              (sm/stream-manip-nav-tabs alpha-sorted-column-map
                                        title related-streams
                                        (stream-sess/stream-attributes (stream-params :username) (stream-params :stream-name))
                                        (if (nil? latest-report) {} (let [ipp (latest-report :items-per-page)]
                                                                      (merge (dissoc latest-report :items-per-page) {:report_items_per ipp}))))

              (sm/report-table (if (contains? stream-params :from-stream)(stream-params :from-stream)(stream-params :stream-name))
                               (if (contains? stream-params :to-stream)(stream-params :to-stream) (str ""))
                                "" "" manip-fn "" "" "stream")
              (include-js jsfile) ;blank report table
      ))))



(defn edit-stream [stream user]
  (let [title (stream :stream-name)]
    (layout/common title user
      (concat
                                  (if (stream :flash)


                                   (html [:div {:class "alert alert-danger alert-dismissable"}
                                          [:button {:type "button" :class "close" :data-dismiss "alert" :aria-hidden "true"} "&times;"]
                                          [:strong (stream :flash)]])
                                    "")
                                  (sm/stream-form (merge stream {:action "update"}))
                                  (html [:br])
                                  (sm/column-map-form (stream :column-map) title (stream :key-columns))

       ))))

(defn index [streams reports user]

  (let [title "Streams"]
  (layout/common title user
      (display-all streams reports))))
