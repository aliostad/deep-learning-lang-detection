(ns views.worker
  (:require [views.helpers :as helpers]
            [clojurewerkz.urly.core :as u]
            [clojure.data.json :as json]
            [ring.util.request :as ring-request]
            [hivewing-web.controller-core :as controller-core]
            [clj-time.coerce :as ctimec]
            [ring.util.codec :as ring-codec]
            [lib.paths :as lib-paths]
            [hivewing-web.paths :as paths])
  (:use hiccup.core
        hiccup.util
        hiccup.page
        hiccup.def))

(defn side-menu
  [req current-page can-manage?]
  (let [wu (:worker-uuid (:params req))
        hu (:hive-uuid (:params req))]

    (vector
      {:href (paths/worker-path hu wu)
        :active (= current-page :status)
        :text "Status"}
      {:href (paths/worker-manage-path hu wu)
        :active (= current-page :manage)
        :disabled (not can-manage?)
        :text "Manage"}
      {:href (paths/worker-config-path hu wu)
        :active (= current-page :config)
        :text "Config"}
      {:href (paths/worker-events-path hu wu)
        :active (= current-page :events)
        :text "Events"}
      {:href (paths/worker-data-path hu wu)
        :active (= current-page :data)
        :text "Data"}
      {:href (paths/worker-logs-path hu wu)
        :active (= current-page :logs)
        :text "Logs"}
      )))

(defn hive-image-ref [image-url]
  (if (empty? image-url)
    "unknown"
    (let [url (u/url-like image-url)
          path-str (or (and url (u/path-of url)) "unknown/unknown")
          ref (last (clojure.string/split path-str #"\/"))]
      ref)))

(defn worker-tasks-to-array
  [worker-config]
    (let [tasks-str (get ".tasks" worker-config)]
      (if (clojure.string/blank? tasks-str)
        []
        (json/read-str tasks-str))))

(defn status [req hive worker worker-config tasks system-worker-logs worker-task-tracing]
  [:div.container-fluid
    [:div.row
      [:h2 "Info"]
      [:dl.dl-horizontal
        [:dt "Connected"]
        [:dd (if (:connected worker) "Connected" "Disconnected")]
        [:dt "Last Seen"]
        [:dd (if (:last_seen worker) (:last_seen worker) "Never seen")]
        [:dt "Configured Image"]
        [:dd [:span (hive-image-ref (get worker-config ".hive-image" ))]]
        [:dt "Current Image"]
        [:dd [:span (hive-image-ref (get worker-config ".hive-image-current" ))]]
      ]
    ]
    [:div.row
      [:h2 "Tasks"]
      [:ul.list-item-group
        (if (empty? tasks)
          [:li.list-group-item.text-center  [:span "No Active Tasks"]])

          (map #(vector :li.list-group-item
                          [:span.pull-right.label {
                            :class (if (get worker-task-tracing (key %)) "label-success") }
                             (if (get worker-task-tracing (key %)) "Tracing")]
                          [:strong.col-sm-3  (key %)]
                          [:span (val %)])
               tasks)
       ]
    ]

    [:div.row
      [:h2 "System Logs"]
      [:ul.list-item-group
        (if (empty? system-worker-logs)
          [:li.list-group-item.text-center [:span "No system logs available"]])

        (map helpers/log-list-item system-worker-logs)
      ]
    ]
  ])

(defn manage [req hive worker tasks worker-task-tracing]
  [:div.container-fluid
    [:div.row
      [:h2 "Settings"]
      [:form.col-lg-8 {:method "post"}
        (helpers/anti-forgery-field)
        [:div.form-group
          [:label "Name"]
          [:input.form-control {:type :text :value (:name worker) :pattern "{1,120}" :name :worker-manage-name}]
        ]
        [:div.form-group.spaced
          [:input.btn.btn-primary {:value "Save" :type :submit}]
        ]
      ]
    ]
    [:div.row
      [:h2 "Worker Events"]
    ]
    [:div.row
      [:form {:method "post"}
        (helpers/anti-forgery-field)
        [:dl.dl-horizontal.extra-margin
          [:dt "Reboot worker" ]
          [:dd [:span "This will cause all the tasks on the worker to restart. Configuration is persisted"]]
          [:dd [:input.btn.btn-sm.btn-primary {:type :submit :name :worker-event-reboot :value "Reboot Worker"}]]

          [:dt "Reset worker"]
          [:dd [:span "This will cause the worker to delete all configuration, stop all tasks, and bootstrap itself again"]]
          [:dd [:input.btn.btn-sm.btn-primary  {:type :submit :name :worker-event-reset :value "Reset Worker"}]]
        ]
      ]
    ]

    [:div.row
      [:h2 "Task Logging"]
      [:ul.list-item-group
        (if (empty? tasks)
          [:li.list-group-item.text-center  "No tasks"])

        (map #(vector :li.list-group-item.clearfix
                        [:form.pull-right {:method "post"}
                                (helpers/anti-forgery-field)
                                [:input {:type :hidden :name :worker-task :value (key %)}]

                                (if (get worker-task-tracing (key %))
                                  [:div.btn-group
                                    [:input.btn {:class "btn-primary" :type :submit :disabled true :value "On"}]
                                    [:input.btn {:class "btn-default" :type :submit :name :worker-task-tracing :value "Off"}]]
                                  [:div.btn-group
                                    [:input.btn {:class "btn-default" :type :submit :name :worker-task-tracing :value "On"}]
                                    [:input.btn {:class "btn-primary" :type :submit :disabled true :value "Off"}]]
                                  )]

                      (key %))
                       tasks)
      ]
    ]
    [:div.row
      [:h2 "Delete Worker"]
      [:p "Deleting the worker will remove it from the hive and clear the data from the device.  The device will need to be re-initialized and connected back to hive-wing"]
    ]
    [:div.row
      [:form  {:method "post" :action (paths/worker-delete-path (:uuid hive) (:uuid worker))}
        (helpers/anti-forgery-field)
        [:div.form-group
          [:div.input-group
            [:input.form-control {:type :text :required :required :pattern "[pP][lL][eE][aA][sS][eE][ ]+[dD][eE][lL][eE][tT][eE]"
               :placeholder "To confirm type \"Please Delete\""
               :name :worker-delete-confirmation
               :title "To confirm type \"Please Delete\""}]
            [:span.input-group-btn
              [:input.btn.btn-danger {:type :submit :value "Delete Worker"}]
            ]
          ]
        ]
      ]
    ]
  ])

(defn split-config-name
  "Splits a config key into the task and config name."
  [config-key]
  (let [splits (clojure.string/split config-key #"\.")
        cfg-name   (last splits)
        task   (clojure.string/join "." (drop-last 1 splits))
        ]
    [task cfg-name]))

(defn render-config-row
  [[k v] hive worker can-manage?]

  (let [[task name] (split-config-name k)]
    (vector :li.list-group-item.clearfix
            [:div.col-md-2 [:input.form-control {:value task :readonly true}]]
            [:div.col-md-4 [:input.form-control {:value name :readonly true}]]
            [:form {:method "post" :action (paths/worker-config-update-path (:uuid hive) (:uuid worker))}
              [:div.col-md-4
                (helpers/anti-forgery-field)
                [:input {:type :hidden :name :worker-config-key :value k}]
                [:input.form-control {:type :text :name :worker-config-value :value v}]
              ]
              [:div.col-md-1
                [:input.btn.btn-primary {:type :submit :value "Update"}]
              ]
            ]
            [:div.col-md-1
              (if can-manage?
                (vector :form
                        {:method "post" :action (paths/worker-config-delete-path (:uuid hive) (:uuid worker))}
                        (helpers/anti-forgery-field)
                        [:input {:type :hidden :name :worker-config-key :value k}]
                        [:input.btn.btn-danger {:type :submit :onclick (str "confirm(\"Are you sure you want to delete " k "?\")") :value "Delete"}])
                "&nbsp;")
            ])))

(defn config
  [req hive worker tasks worker-config can-manage?]
  [:div.container-fluid
    [:div.row
      [:h2 "Config"]
      [:p "Configuration is worker-specific and persists across any reboot / restart
          software update"]
    ]
    [:div.row.margin-bottom-row
      (if can-manage?
        [:ul.list-item-group
          [:li.list-group-item.clearfix
            [:form  {:method "post" :action (paths/worker-config-path (:uuid hive) (:uuid worker))}
              (helpers/anti-forgery-field)
              [:div.col-md-2
                 [:select.form-control {:name "worker-config-task" :required :required}
                    (map #(vector :option {:value %} %) tasks)
                  ]
              ]
              [:div.col-md-4
                 [:input.form-control {:type :text :required :required :name "worker-config-key" :pattern "[a-zA-Z_\\-0-9]+" :title "Worker config key.  0-9A-Za-z _ - " :placeholder "New Worker Config"}] ]
              [:div.col-md-4
                 [:input.form-control {:type :text :required :required :name "worker-config-value" :placeholder "New Worker Value"}] ]
              [:div.col-md-2
                 [:input.btn.btn-primary {:type :submit :value "Create"}] ]
            ]
          ]
        ]
      )
    ]
    [:div.row
      [:ul.list-item-group
        (map #(render-config-row % hive worker can-manage?) (sort-by first (map identity worker-config)))

        (if (empty? worker-config)
          [:li.list-group-item.text-center "No configuration set"])
      ]

      [:tbody
        [:tr [:td "&nbsp;"] [:td "&nbsp;"] [:td "&nbsp;"] [:td "&nbsp;"] ]
      ]
    ]
  ])

(defn render-data-value-row
  [req hive worker data-name value]
    [:li.list-group-item.clearfix
      [:span.col-md-3 (:at value)]
      [:span.col-md-8 [:strong (:data value)]]])

(defn show-data-values
  [req hive worker data-name data-values]
    [:div.container-fluid
      [:div.row
        [:h2 (str data-name " Data")]
        [:p "A listing of the most recent data values received from this worker"]
      ]
      [:div.row
        [:ul.list-item-group
          (map #(render-data-value-row req hive worker data-name % )  (sort-by first (map identity data-values)))
        ]
      ]
    ]
  )


(defn render-data-row
  [req hive worker data-name]
    [:li.list-group-item.clearfix [:a {:href (paths/worker-data-value-path (:uuid hive) (:uuid worker) data-name)} data-name]])

(defn data [req hive worker data-keys]
  [:div.container-fluid
    [:div.row
      [:h2 "Worker Data"]
      [:p "Worker data is data that is received from the worker.  The most recent records are stored and accessible
          via the API.  Older data is either purged or using a processing stage can be stored in longer-term storage."]
    ]
    [:ul.list-item-group
      (if (empty? data-keys)
        [:li.list-group-item.text-center "No Data"])

      (map #(render-data-row req hive worker % )  (sort-by first (map identity data-keys)))
    ]
  ])

(defn render-worker-log
  [log]
    (vector :li.list-group-item.clearfix
            [:span.col-md-2 (str (:at log))]
            [:span.col-md-2 (or (:task log) "--system--")]
            [:span.col-md-8  (str (:message log))]))


(defn log-update-script
  [req hive-uuid worker-uuid last-log]

  (let [req-params (:params req)
        last-log (or last-log (java.util.Date.))
        worker-logs-after (.getTime last-log)
        all-params (assoc req-params :worker-logs-last-log worker-logs-after)
        stringd    (clojure.walk/stringify-keys all-params)
        ]

    (str  "\nvar log_update_request = function() {
              $.ajax({
                url: \"" (paths/worker-logs-delta-path hive-uuid worker-uuid) "\",
                data: " (json/write-str stringd)  ",
                success: function(data) {
                  $('.logs-insertion-point').prepend(data);
                }
              });
            };
            setTimeout(log_update_request, 5000);
            ")))

(defn logs-delta
  [req hive worker log-messages]
    (html
      (map render-worker-log log-messages)
      [:script (log-update-script req (:uuid hive) (:uuid worker) (:at (first log-messages)))]
     ))

(defn logs [req hive worker current-task start-at tasks log-messages]
  (let [current-url (ring-request/request-url req)
        rewind-link (if start-at (lib-paths/add-params-to-url current-url {:worker-logs-start nil}) nil)
        next-start-at (ctimec/to-long (:at (last log-messages)))
        next-link (lib-paths/add-params-to-url current-url {:worker-logs-start next-start-at})
        ]
    [:div.container-fluid
      [:div.row
        [:h2 "Worker Logs"]
        [:p "These are the log messages from all of the worker tasks.  If Tracing is enabled, you will get all the
            output from a worker task.  Otherwise only specifically \"logged\" output is recorded.
            Only the most recent logs are stored, once they expire, they are discarded"]
      ]

      [:div.row
        [:form.pull-right.col-md-2
          (helpers/anti-forgery-field)
          [:div.form-group
            [:div.input-group
              [:select.form-control {:name "worker-logs-task"}
                [:option {:selected (nil? current-task) :value "*ALL*"} "All Tasks"]
                (map #(vector :option {:selected (= current-task %1) :value %1} %1) tasks)
              ]
              [:span.input-group-btn
               [:input.btn.btn-primary {:type :submit :value "Filter"}]
              ]
            ]
          ]
        ]
        [:div.navigation.btn-group
          (if rewind-link
            [:a.btn.btn-primary {:href rewind-link} [:i.fa.fa-fast-backward] "&nbsp; Rewind"])
          [:a.btn.btn-primary {:href next-link} [:i.fa.fa-step-forward]   "&nbsp; More"]
        ]
      ]

      [:ul.list-item-group.logs-insertion-point
        (if (empty? log-messages)
           [:li.list-group-item.text-center "No Log Messages"])
        (map render-worker-log log-messages)
      ]

      [:script (log-update-script req (:uuid hive) (:uuid worker) (:at (first log-messages)))]
      ]))

(defn events
  [req hive worker tasks]
  [:div.container-fluid
    [:div.row
      [:h2 "Events"]
      [:p "Events are worker / task specific payloads delivered to the worker. It is temporal, and does not persist.
         Useful for direct, real-time control of a worker"]
    ]
    [:div.row.margin-bottom-row
      [:ul.list-item-group
        [:li.list-group-item.clearfix
          [:form  {:method "post" :action (paths/worker-events-path (:uuid hive) (:uuid worker))}
            (helpers/anti-forgery-field)
            [:div.col-md-2
               [:select.form-control {:name "event-task" :required :required}
                  (map #(vector :option {:value %} %) tasks)
                ]
            ]
            [:div.col-md-4
               [:input.form-control {:type :text :required :required :name "event-name" :pattern "[a-zA-Z_\\-0-9]+" :title "Worker config key.  0-9A-Za-z _ - " :placeholder "New Event Name "}] ]
            [:div.col-md-4
               [:input.form-control {:type :text :required :required :name "event-value" :placeholder "New Event Value"}] ]
            [:div.col-md-2
               [:input.btn.btn-primary {:type :submit :value "Send Event"}] ]
          ]
        ]
      ]
    ]
  ])
