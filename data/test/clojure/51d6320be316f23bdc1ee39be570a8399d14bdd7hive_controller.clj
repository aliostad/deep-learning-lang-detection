(ns hivewing-web.hive-controller
  (:require [hivewing-web.session :as session]
            [hivewing-web.controller-core :refer :all]
            [hivewing-web.paths :as paths]
            [hivewing-core.beekeeper :as bk]
            [hivewing-core.hive-manager :as hm]
            [hivewing-core.hive-logs :as hive-logs]
            [hivewing-core.hive-data :as hive-data]
            [hivewing-core.hive-data-stages :as hds]
            [hivewing-core.worker :as worker]
            [hivewing-core.hive :as hive]
            [hivewing-core.apiary :as apiary]
            [ring.util.response :as r]
            [views.hive :as views]
            [views.layout :as layout]
     ))
(comment
  (def bk "2599052e-903d-11e4-854c-0242ac110027")
  (def hive-uuid "25c56a10-903d-11e4-a644-0242ac110027")
  (hive/hive-can-modify? bk hive-uuid )
  (hm/hive-managers-managing bk)
  )

(defn sub-menu [req current-page can-manage?]
  "Determine the submenu listing for the apiary-controller!"
  (let [hu (:hive-uuid (:params req))]
    [
    {:href (paths/hive-path hu)
     :active (= current-page :status)
     :text "Status"}
    {:href (paths/hive-manage-path hu)
     :active (= current-page :manage)
     :text "Manage"
     :disabled (not can-manage?)}
    {:href (paths/hive-data-path hu)
     :active (= current-page :data)
     :text "Data"
     :disabled (not can-manage?)}
    {:href (paths/hive-processing-path hu)
     :active (= current-page :processing)
     :text "Processing"
     :disabled (not can-manage?)}
  ]))

(defn back-link [req]
  "Determine the breadcrumbs for the apiary controller"
  {:href (paths/apiary-path)
    :text "Apiary"}
  )

(defn status
  [req & args]
  (with-beekeeper req bk
    (with-required-parameters req [hive-uuid]
      (with-preconditions req [
            hive          (hive/hive-get hive-uuid)
            access?       (hive/hive-can-read? (:uuid bk) hive-uuid)
            worker-uuids  (worker/worker-list hive-uuid :page 1 :per-page 500)
            workers       (map #(worker/worker-get (:uuid %)) worker-uuids)
            system-worker-logs    (hive-logs/hive-logs-read hive-uuid :worker-uuid nil :task nil)
          ]
        (let [can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)]
          (render (layout/render req (views/status req hive workers can-manage? system-worker-logs)
                                        :style :default
                                        :sub-menu (sub-menu req :status can-manage?)
                                        :current-name (:name hive)
                                        :back-link (back-link req)
                                        :body-class :hive
                                    )))))))
(defn show-data-values
  [req & args]

  (with-beekeeper req bk
    (with-required-parameters req [hive-uuid data-name]
      (with-preconditions req [
            hive          (hive/hive-get hive-uuid)
            access?       (hive/hive-can-read? (:uuid bk) hive-uuid)
            data-values   (hive-data/hive-data-read hive-uuid nil data-name)
          ]
        (let [can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)]
          (render (layout/render req (views/show-data-values req hive data-name data-values)
                                        :style :default
                                        :sub-menu (sub-menu req :data can-manage?)
                                        :current-name (:name hive)
                                        :back-link (back-link req)
                                        :body-class :hive
                                    )))))))

(defn data
  [req & args]
  (with-beekeeper req bk
    (with-required-parameters req [hive-uuid]
      (with-preconditions req [
            hive          (hive/hive-get hive-uuid)
            access?       (hive/hive-can-read? (:uuid bk) hive-uuid)
            data-keys     (hive-data/hive-data-get-keys hive-uuid)
          ]
        (let [can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)]
          (render (layout/render req (views/data req hive data-keys)
                                        :style :default
                                        :sub-menu (sub-menu req :data can-manage?)
                                        :current-name (:name hive)
                                        :back-link (back-link req)
                                        :body-class :hive
                                    )))))))


(defn update-manage
  [req & args]
  (with-beekeeper req bk
    (with-required-parameters req [hive-uuid]
      (with-preconditions req [hive (hive/hive-get hive-uuid)
                               can-manage?  (hive/hive-can-modify? (:uuid bk) hive-uuid)
                               ]
        (let [new-name (:hive-manage-name (:params req))
              new-branch (:hive-manage-image-branch (:params req))
              ]
              (if new-branch (hive/hive-set-image-branch hive-uuid new-branch))
              ;; Updating to a new name
              (if new-name (hive/hive-set-name hive-uuid new-name))
            (->
              (r/redirect (paths/hive-manage-path hive-uuid))
              (assoc :flash "Updated hive")))))))
(defn manage
  [req & args]
  (with-required-parameters req [hive-uuid]
    (with-preconditions req [
          bk   (session/current-user req)
          can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)
          hive    (hive/hive-get hive-uuid)
          ]
      (render (layout/render req (views/manage req hive)
                                        :style :default
                                        :sub-menu (sub-menu req :manage can-manage?)
                                        :current-name (:name hive)
                                        :back-link (back-link req)
                                        :body-class :hive
                                  )))))

(defn processing-new-choose-stage
  [req & args]
  (with-required-parameters req [hive-uuid]
    (with-preconditions req [
          bk   (session/current-user req)
          can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)
          hive    (hive/hive-get hive-uuid)
          hive-stage-specs  (remove :hidden (map :spec  (vals (hds/hive-data-stages-specs))))
          ]
      (render (layout/render req (views/processing-new-choose-stage req hive hive-stage-specs)
                                        :style :default
                                        :sub-menu (sub-menu req :processing can-manage?)
                                        :current-name (:name hive)
                                        :back-link (back-link req)
                                        :body-class :hive
                                    )))))
(defn processing-new-stage
  [req & args]
  (with-required-parameters req [hive-uuid stage-name]
    (with-preconditions req [
          bk   (session/current-user req)
          can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)
          hive    (hive/hive-get hive-uuid)
          hive-stages  (hds/hive-data-stages-specs)
          hive-stage-spec (get-in hive-stages [(keyword stage-name) :spec])
          ]
      (render (layout/render req (views/processing-new-stage req hive hive-stage-spec)
                                        :style :default
                                        :sub-menu (sub-menu req :processing can-manage?)
                                        :current-name (:name hive)
                                        :back-link (back-link req)
                                        :body-class :hive
                                    )))))

(defn clean-stage-param
  [stage-spec [field-name field-val]]
  (let [field-spec (get stage-spec field-name)
        [field-type field-desc field-details]  field-spec ]

    (vector
      (keyword field-name)
      (case field-type
        :data-stream (apply hash-map (vals field-val))
        :url field-val
        :string field-val
        :integer field-val
        :email field-val
        :enum (keyword field-val)))))

(comment
  (do
    (def hive-uuid "12345678-1234-1234-1234-1234566789012")
    (def stage-name "alert-email")
    (def hive-stages  (hds/hive-data-stages-specs))
    (def hive-stage-spec (get-in hive-stages [(keyword stage-name) :spec]))
    (def stage-params
      {:in {:source "worker", :data-key "test"}, :email "apple@pair.com",
       :test "gt", :value 23})
  ))

(defn processing-create-stage
  [req & args]
  (with-required-parameters req [hive-uuid stage-name]
    (with-preconditions req [
          bk   (session/current-user req)
          can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)
          hive    (hive/hive-get hive-uuid)
          hive-stages  (hds/hive-data-stages-specs)
          hive-stage-spec (get-in hive-stages [(keyword stage-name) :spec :params])
          ]

    (let [stage-params (:stage (:params req))
          clean-stage-params (concat
                               (list hive-uuid (keyword stage-name))
                               (apply concat (map #(clean-stage-param hive-stage-spec %) stage-params)))
          stage (apply hds/hive-data-stages-create clean-stage-params)
          ]
      (->
        (r/redirect (paths/hive-processing-path hive-uuid))
        (assoc :flash "Created processing stage"))))))

(defn processing-delete-stage
  [req & args]
  (with-required-parameters req [hive-uuid stage-uuid]
    (with-preconditions req [
          bk   (session/current-user req)
          can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)
          hive-stage  (hds/hive-data-stages-get hive-uuid stage-uuid)
          ]
      (hds/hive-data-stages-delete stage-uuid)
      (->
        (r/redirect (paths/hive-processing-path hive-uuid))
        (assoc :flash "Deleted processing stage")))))

(defn processing
  [req & args]
  (with-required-parameters req [hive-uuid]
    (with-preconditions req [
          bk   (session/current-user req)
          can-manage? (hive/hive-can-modify? (:uuid bk) hive-uuid)
          hive    (hive/hive-get hive-uuid)
          hive-stages (hds/hive-data-stages-index hive-uuid)
          ]
      (render (layout/render req (views/processing req hive hive-stages)
                                        :style :default
                                        :sub-menu (sub-menu req :processing can-manage?)
                                        :current-name (:name hive)
                                        :back-link (back-link req)
                                        :body-class :hive
                                    )))))
