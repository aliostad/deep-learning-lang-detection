(ns wilson.handler
  (:require [clojure.tools.logging :as log]
            [schema.core :as s]
            [ring.util.http-response :refer :all]
            [ring.logger :refer [wrap-with-logger]]
            [ring.middleware.etag :refer [calculate-etag wrap-etag]]
            [compojure.route :as route]
            [compojure.api.sweet :refer :all]
            [wilson.schema :as wsc]
            [wilson.handler.items :as ih]
            [wilson.handler.votes :as vh]))

(defn custom-handler [^Exception e data request]
  (log/error (.getMessage e) e)
  (internal-server-error {:message (.getMessage e)}))

(defmethod calculate-etag clojure.lang.IHashEq [c]
  (str (hash c)))

(defapi app
  {:swagger {:ui "/api-docs"
             :spec "/swagger.json"
             :data {:info {:title "Wilson API"
                           :description "How not to sort by average rating."
                           :version (System/getProperty "wilson.version")}
                    :tags [{:name "items" :description "Manage items"}
                           {:name "votes" :description "Vote on items"}]}}
   :exceptions {:handlers {:compojure.api.exception/default custom-handler}}}
  (middleware [wrap-with-logger wrap-etag]
    (context "/items" []
      :tags ["items"]

      (POST "/" []
        :body [item wsc/NewItem]
        :return wsc/Item
        :summary "Create a new item, optionally with pre-existings votes"
        (ih/post-items! item))

      (GET "/" []
        :return [s/Str]
        :summary "Get a list of all item ids"
        (ih/get-items))

      (GET "/:iid" [iid]
        :return wsc/Item
        :summary "Get a specific item by id"
        (ih/get-item iid))

      (DELETE "/:iid" [iid]
        :summary "Delete the item and all associated votes"
        (ih/delete-item! iid))

      (GET "/:iid/votes" [iid]
        :return [s/Str]
        :summary "Get a list of all vote ids for the item"
        (vh/get-votes iid))

      (POST "/:iid/votes" [iid]
        :body [vote wsc/NewVote]
        :return wsc/Vote
        :summary "Up or down vote the item"
        (vh/post-votes! iid vote)))

    (context "/votes" []
      :tags ["votes"]

      (GET "/" []
        :return [s/Str]
        :summary "Get all vote ids"
        (vh/get-all-votes))

      (GET "/:vid" [vid]
        :return wsc/Vote
        :summary "Get a specific vote per id"
        (vh/get-vote vid))

      (PATCH "/:vid" [vid]
        :body [vote wsc/NewVote]
        :return wsc/Vote
        :summary "Change a vote"
        (vh/patch-vote! vid vote)))

    (undocumented
      (route/not-found "Not found"))))
