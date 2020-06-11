(ns laconic-cms.handlers
  (:require-macros [laconic-cms.macros :refer [log]])
  (:require [laconic-cms.db :as db]
            [laconic-cms.routes :refer [prefix]]
            [ajax.core :as ajax]
            [re-frame.core :refer [dispatch reg-event-db reg-event-fx]]
            [day8.re-frame.http-fx]))

; ----------------------------------------------------------------
; Helpers
; ----------------------------------------------------------------

(reg-event-db
 :assoc-db
 (fn [db [_ key val]]
   (assoc db key val)))

(reg-event-db
 :console-log
 (fn [db [_ msg]]
   (log msg)
   db))

(reg-event-db
 :navigate!
 (fn [db [_ url]]
   (.assign js/location (str prefix url))
   db))

; ----------------------------------------------------------------
; Main
; ----------------------------------------------------------------

(reg-event-db
 :initialize-db
 (fn [db _]
   db/default-db)) 

(reg-event-db
  :set-active-page
  (fn [db [_ page]]
    (assoc db :page page)))

(reg-event-db
  :set-docs
  (fn [db [_ docs]]
    (assoc db :docs docs)))

(reg-event-db
 :remove-modal
 (fn [db _]
   (assoc db :modal nil)))

(reg-event-db
 :modal
 (fn [db [_ modal]]
   (assoc db :modal modal)))

(reg-event-db
 :logout
 (fn [db _]
   (dissoc db :identity)))

; ----------------------------------------------------------------
; Posts
; ----------------------------------------------------------------

(reg-event-db
 :posts
 (fn [db _]
   (ajax/GET "/api/posts"
             {:handler #(dispatch [:assoc-db :posts %])
              :error-handler #(dispatch [:console-log %])})
   db))

; new
(reg-event-db
 :add-post
 (fn [db [_ post]]
   (update db :posts #(concat % [post]))))

(reg-event-db
 :create-post
 (fn [db [_ fields]]
   (ajax/POST "/api/posts"
              {:params @fields
               :handler #(do (dispatch [:add-post %])
                             (dispatch [:remove-modal]))
               :error-handler #(dispatch [:console-log %])})
   db))

; TODO: come up with a more effective function to update
(reg-event-db
 :update-in-posts
 (fn [db [_ new-post]]
   (update db :posts
           #(map (fn [post]
                   (if (= (:id post) (:id new-post))
                     new-post
                     post))
                 %))))

(reg-event-db
 :edit-post
 (fn [db [_ fields]]
   (ajax/PUT "/api/posts"
             {:params (select-keys fields [:id :title :body])
              :handler #(do (dispatch [:update-in-posts fields])
                            (dispatch [:set-post fields])
                            (dispatch [:remove-modal])
                            (dispatch [:navigate! "/admin/blog"]))
              :error-handler #(dispatch [:console-log %])})
   db))

(reg-event-db
 :set-post
 (fn [db [_ post]]
   (assoc db :post post)))


(reg-event-db
 :load-post
 (fn [db [_ id]]
   (ajax/GET (str "/api/posts/" id)
             {:handler #(dispatch [:set-post %])
              :error-handler #(dispatch [:console-log %])})
   db))

(reg-event-db
 :remove-from-posts
 (fn [db [_ id]]
   (let [remove-fn (fn [post]
                     (= (:id post) id))]
     (update db :posts
             #(remove remove-fn %)))))

(reg-event-db
 :delete-post
 (fn [db [_ id]]
   (ajax/DELETE "/api/posts"
                {:params {:id id}
                 :handler #(do (dispatch [:remove-from-posts id])
                               ; NOTE: There's no harm in removing the modal if
                               ; thre isn't the modal in the first place.
                               ; I still wonder if this is the correct thing to do.
                               ; Maybe stablish some functions to run the rome page
                               ; events, admin events, user events, front-end-blog-events
                               ;like in memory hole
                               (dispatch [:remove-modal])
                               (if (= (:page db) :admin)
                                 (dispatch [:navigate! "/admin/blog"])
                                 (dispatch [:navigate! "/"])))
                 :error-handler #(dispatch [:console-log %])})
   db))
