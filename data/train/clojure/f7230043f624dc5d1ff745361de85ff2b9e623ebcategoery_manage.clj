(ns pdf-online.routes.categoery-manage
  (:require [compojure.core :refer [defroutes GET POST]]
            [pdf-online.views.layout :as layout]
            [pdf-online.util :as util]
            [pdf-online.models.db :as db]
            [noir.session :as session]
            [noir.util.route :refer [restricted]]
            [noir.response :as resp]
            [clojure.string :refer [blank? trim]])
  (:import [java.io File]))

(defn handle-categoery-manage []
  (layout/my-render "categoery_manage.html" 
                    {:categoeries (db/get-user-categoeries (session/get :user))}))

(defn handle-categoery-add [new-categoery]
  (if (db/valid-user-categoeries (session/get :user) new-categoery)
    (resp/json {:status "repeat"})
    (if (blank? new-categoery)
      (resp/json {:status "null"})
      (try 
		    (db/create-categoery-record {:userid (session/get :user)
		                                 :categoery new-categoery})
		      (resp/json {:status "ok"})
		      (catch Exception ex
		        (resp/json {:status "wrong"}))))))

(defn handle-categoery-delete [categoery]
  (try
    (db/delete-categoery (session/get :user) categoery)
    (db/delete-pdf-categoery (session/get :user) categoery)
    (let [path (util/join-path-parts (session/get :user) util/pdf categoery)
          dir (File. path)]
      (if (.exists dir)
        (util/delete-directory path)))
    (resp/json {:status "ok"})
    (catch Exception ex
      (resp/json "wrong"))))

(defroutes categoery-manage-routes
  (GET "/categoery/manage" []
        (restricted (handle-categoery-manage)))
  (POST "/categoery/add" [categoery]
        (restricted (handle-categoery-add categoery)))
  (POST "/categoery/delete" [categoery]
        (restricted (handle-categoery-delete (trim categoery)))))