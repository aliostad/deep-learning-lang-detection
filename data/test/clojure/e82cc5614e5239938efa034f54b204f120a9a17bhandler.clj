(ns chromaticgliss.handler
  (:use compojure.core
        clojure.pprint
        ring.middleware.json)
  (:import (com.fasterxml.jackson.core JsonGenerator))
  (:require [compojure.handler :as handler]
            [compojure.route :as route]
            [ring.util.response :refer [response]]
            [cheshire.generate :refer [add-encoder]]
            [chromaticgliss.models.users :as users]
            [chromaticgliss.models.lists :as lists]
            [chromaticgliss.models.products :as products]
            [chromaticgliss.models.posts :as posts]
            [chromaticgliss.views.main :as views]
            [chromaticgliss.auth :refer [auth-backend authenticate-token user-can user-isa user-has-id authenticated-user unauthorized-handler make-token!]]
            [buddy.auth.middleware :refer [wrap-authentication wrap-authorization]]
            [buddy.auth.accessrules :refer [restrict]]))

(add-encoder clojure.lang.Keyword
  (fn [^clojure.lang.Keyword kw ^JsonGenerator gen]
    (.writeString gen (name kw))))

(defn get-users [_]
  {:status 200
   :body {:success true
          :count (users/count-users)
          :results (users/find-all)}})

(defn create-user [{user :body}]
  (let [new-user (users/create user)]
    {:status 201
     :body {:success true}
     :headers {"Location" (str "/api/users/" (:id new-user))}}))

(defn find-user [{{:keys [id]} :params}]
  (response (users/find-by-id (read-string id))))

(defn lists-for-user [{{:keys [id]} :params}]
  (response
   (map #(dissoc % :user_id) (lists/find-all-by :user_id (read-string id)))))

(defn delete-user [{{:keys [id]} :params}]
  (users/delete-user {:id (read-string id)})
  {:status 204
   :body {:success true}
   :headers {"Location" "/api/users"}})

(defn get-lists [_]
  {:status 200
   :body {:count (lists/count-lists)
          :results (lists/find-all)}})

(defn create-list [{listdata :body}]
  (let [new-list (lists/create listdata)]
    {:status 201
     :headers {"Location" (str "/api/users/" (:user_id new-list) "/api/lists")}}))

(defn find-list [{{:keys [id]} :params}]
  (response (lists/find-by-id (read-string id))))

(defn update-list [{{:keys [id]} :params
                    listdata :body}]
  (if (nil? id)
    {:status 404
     :headers {"Location" "/lists"}}
    ((lists/update-list (assoc listdata :id id))
     {:status 200
      :headers {"Location" "/api/lists"}})))

(defn delete-list [{{:keys [id]} :params}]
  (lists/delete-list {:id (read-string id)})
  {:status 204
   :headers {"Location" "/api/lists"}})

(defn get-products [_]
  {:status 200
   :body {:count (products/count-products)
          :results (products/find-all)}})

(defn create-product [{product :body}]
  (let [new-prod (products/create product)]
    {:status 201
     :headers {"Location" (str "/api/products/" (:id new-prod))}}))

(defn create-post [{post :body}]
  (let [new-post (posts/create post)]
    {:status 201
     :body {:success true}
     :headers {"Location" (str "/api/posts/id/" (:id new-post))}}))

(defn update-post [{{:keys [id]} :params
                    postdata :body}]
  (if (nil? id)
    {:status 404
     :body {:success false}
     :headers {"Location" "/posts"}}
    (do
      (posts/update-post (assoc postdata :id id))
      {:status 200
       :body {:success true}
       :headers {"Location"  "/api/posts"}})))

(defn update-post-by-slug [{{:keys [slug]} :params
                    postdata :body}]
  (if (nil? slug)
    {:status 404
     :body {:success false}
     :headers {"Location" "/api/posts"}}
    ((posts/update-post-by-slug (assoc postdata :slug slug))
     {:status 200
      :body {:success true}
      :headers {"Location"  "/api/posts"}})))

(defn delete-post-by-id [{{:keys [id]} :params}]
  (posts/delete-post {:id (read-string id)})
  {:status 204
   :body {:success true}
   :headers {"Location" "/api/posts"}})

(defn delete-post-by-slug [{{:keys [slug]} :params}]
  (posts/delete-post-by-slug {:slug slug})
  {:status 204
   :body {:success true}
   :headers {"Location" "/api/posts"}})

(defn get-posts [_]
  {:status 200
   :body {:success true
          :count (posts/count-posts)
          :results (posts/find-all)}})

(defn find-post-by-id [{{:keys [id]} :params}]
   (response (posts/find-by-id (read-string id))))

(defn find-post-by-slug [{{:keys [slug] } :params}]
  (response (posts/find-by-slug slug)))

(defroutes api-routes
  ;; Users
  (context "/users" []
    (GET "/" [] (-> get-users
                    (restrict {:handler {:and [authenticated-user (user-can "manage-users")]}
                                :on-error unauthorized-handler})))
    (POST "/" [] create-user)
    (context "/:id" [id]
      (restrict
        (routes
         (GET "/" [] find-user))
        {:handler {:and [authenticated-user
                         {:or [(user-can "manage-users")
                               (user-has-id (read-string id))]}]}
         :on-error unauthorized-handler}))
    (DELETE "/:id" [id] (-> delete-user
                            (restrict {:handler {:and [authenticated-user (user-can "manage-users")]}
                                       :on-error unauthorized-handler}))))

  ;; Auth for frontend
  (context "/sessions" []
    (GET "/" {{:keys [token]} :body}
      (let [user-id (authenticate-token {} token)]
         (if user-id
           {:status 201
            :body {:id user-id}}
           {:status 409
            :body {:status "error"
                   :message "expired or invalid auth token"}})))
    (POST "/" {{:keys [email password]} :body}
      (let [user-id (:id (users/find-by :email email))]
        (if (users/password-matches? user-id password)
            {:status 201
             :body {:auth-token (make-token! user-id)}}
            {:status 409
             :body {:status "error"
                    :message "invalid username or password"}}))))

  ;; Posts
  (context "/posts" []
    (GET "/" [] get-posts)
    (POST "/" []
          (-> create-post
              (restrict {:handler {:and [authenticated-user (user-can "manage-posts")]}
                         :on-error unauthorized-handler})))
    (GET "/id/:id" [id] find-post-by-id)
    (POST "/id/:id" [id] update-post)
      ;; (-> update-post
      ;;     (restrict {:handler {:and [authenticated-user (user-can "manage-posts")]}
      ;;                :on-error unauthorized-handler})))
    (DELETE "/id/:id" [id]
      (-> delete-post-by-id
          (restrict {:handler {:and [authenticated-user (user-can "manage-posts")]}
                     :on-error unauthorized-handler})))
    (GET "/:slug" [slug] find-post-by-slug)
    (POST "/:slug" [slug]
      (-> update-post-by-slug
          (restrict {:handler {:and [authenticated-user (user-can "manage-posts")]}
                     :on-error unauthorized-handler})))
    (DELETE "/:slug" [slug]
      (-> delete-post-by-slug
          (restrict {:handler {:and [authenticated-user (user-can "manage-posts")]}
                     :on-error unauthorized-handler})))))

(defroutes site-routes
  (GET "/" [] (views/index-page)))

(defroutes app-routes
  site-routes
  (route/resources "/") ;; Implicit "/resources/public"
  (context "/api" [] api-routes)
  (route/not-found (response {:success false
                              :message "Page not found"})))

(defn wrap-log-request [handler]
  (fn [req]
    (clojure.pprint/pprint req)
    (handler req)))

(def app
  (-> app-routes
      (wrap-log-request)
      (wrap-authentication auth-backend)
      (wrap-authorization auth-backend)
      (wrap-json-response)
      (wrap-json-body {:keywords? true})))
