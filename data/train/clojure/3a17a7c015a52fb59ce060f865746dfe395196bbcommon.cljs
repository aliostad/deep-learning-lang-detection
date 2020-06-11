(ns rt.common
  (:require [rt.util :as util]
            [re-frame.core :refer [subscribe dispatch dispatch-sync]]
            [clojure.string :as string]))

(defn entity-link [id label]
  [:a {:href (str "#/edit/" (util/url-encode id))} label])

(defn driverfn-list-link [id label]
  [:a {:href (str "#/report/driverfn?q=" (util/url-encode id))} label])

(defn source-link [id label & [line]]
  (let [ns (some-> (namespace (keyword id))
                   (string/replace #"-" "_"))
        ns (or ns id)
        line (and line (str "?line=" line))]
    [:a {:href (str "#/source/" (util/url-encode ns) line)} label]))

(defn run-link [label suite-id & [test-id]]
  [:a {:href (str "#/run") :onClick #(dispatch [:create-testrun suite-id test-id])} label])

(defn save-and-run-link [id label]
  [:a.button {:href    (str "#/run")
              :onClick #(do (dispatch [:save-entity])
                            (dispatch [:create-testrun id]))}
   label])

(defn reset-server-button []
  [:button.button {:onClick #(dispatch [:reset-server])} "reset server"])