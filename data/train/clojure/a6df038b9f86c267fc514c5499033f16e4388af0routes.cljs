(ns ataru.virkailija.routes
  (:require-macros [secretary.core :refer [defroute]])
  (:import [goog Uri])
  (:require [ataru.cljs-util :refer [dispatch-after-state]]
            [secretary.core :as secretary]
            [re-frame.core :refer [dispatch]]
            [accountant.core :as accountant]))

(accountant/configure-navigation! {:nav-handler  (fn [path]
                                                   (secretary/dispatch! path))
                                   :path-exists? (fn [path]
                                                   (secretary/locate-route path))})

(defn set-history!
  [path]
  (accountant/navigate! path))

(defn navigate-to-click-handler
  [path & _]
  (when (secretary/locate-route path)
    (set-history! path)))

(defn- select-editor-form-if-not-deleted
  [form]
  (if (:deleted form)
    (do
      (.replaceState js/history nil nil "/lomake-editori/editor")
      (secretary/dispatch! "/lomake-editori/editor"))
    (dispatch [:editor/select-form (:key form)])))

(defn common-actions-for-applications-route []
  (dispatch [:application/refresh-haut])
  (dispatch [:application/clear-applications-haku-and-form-selections])
  (dispatch [:set-active-panel :application]))

(defn app-routes []
  (defroute "/lomake-editori/" []
    (secretary/dispatch! "/lomake-editori/editor"))

  (defroute "/lomake-editori/editor" []
    (dispatch [:set-active-panel :editor])
    (dispatch [:editor/select-form nil])
    (dispatch [:editor/refresh-forms-for-editor])
    (dispatch [:editor/refresh-forms-in-use]))

  (defroute #"^/lomake-editori/editor/(.*)" [key]
    (dispatch [:set-active-panel :editor])
    (dispatch [:editor/refresh-forms-if-empty key])
    (dispatch [:editor/refresh-forms-in-use])
    (dispatch-after-state
     :predicate
     (fn [db]
       (not-empty (get-in db [:editor :forms key])))
     :handler select-editor-form-if-not-deleted))

  (defroute #"^/lomake-editori/applications/" []
    (secretary/dispatch! "/lomake-editori/applications/incomplete"))

  (defroute #"^/lomake-editori/applications/incomplete/" []
    (secretary/dispatch! "/lomake-editori/applications/incomplete"))

  (defroute #"^/lomake-editori/applications/incomplete" []
    (common-actions-for-applications-route)
    (dispatch [:application/show-incomplete-haut-list]))

  (defroute #"^/lomake-editori/applications/complete/" []
    (secretary/dispatch! "/lomake-editori/applications/complete"))

  (defroute #"^/lomake-editori/applications/complete" []
    (common-actions-for-applications-route)
    (dispatch [:application/show-complete-haut-list]))

  (defroute #"^/lomake-editori/applications/search/" []
    (secretary/dispatch! "/lomake-editori/applications/search"))

  (defroute #"^/lomake-editori/applications/search" [_ params]
    (dispatch [:set-active-panel :application])
    (dispatch [:application/show-search-term])
    (if-let [term (:term (:query-params params))]
      (dispatch [:application/search-by-term term])
      (dispatch [:application/clear-applications-haku-and-form-selections])))

  (defroute #"^/lomake-editori/applications/hakukohde/(.*)" [hakukohde-oid]
    (common-actions-for-applications-route)
    (dispatch [:application/close-search-control])
    (dispatch-after-state
     :predicate
     (fn [db]
       (some #(when (= hakukohde-oid (:oid %)) %)
             (get-in db [:application :hakukohteet])))
     :handler
     (fn [hakukohde]
       (dispatch [:application/select-hakukohde hakukohde])
       (dispatch [:application/fetch-applications-by-hakukohde hakukohde-oid]))))

  (defroute #"^/lomake-editori/applications/haku/(.*)" [haku-oid query-params]
    (common-actions-for-applications-route)
    (dispatch [:application/close-search-control])
    (dispatch-after-state
      :predicate
      (fn [db]
        (some #(when (= haku-oid (:oid %)) %)
          (get-in db [:application :haut :tarjonta-haut])))
      :handler
      (fn [haku]
        (dispatch [:application/select-haku haku])
        (dispatch [:application/fetch-applications-by-haku haku-oid]))))

  (defroute #"^/lomake-editori/applications/(.*)" [key]
    (common-actions-for-applications-route)
    (dispatch [:application/close-search-control])
    (dispatch-after-state
     :predicate
     (fn [db] (not-empty (get-in db [:application :forms key])))
     :handler
     (fn [form]
       (dispatch [:application/select-form (:key form)])
       (dispatch [:application/fetch-applications (:key form)]))))

  (accountant/dispatch-current!))
