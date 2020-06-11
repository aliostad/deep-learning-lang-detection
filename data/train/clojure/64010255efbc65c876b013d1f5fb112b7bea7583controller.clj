;; the top section includes all of the libraries
;; injected so that we can use their namespace


(ns recursiftion.controller
  (:use [ring.adapter.jetty :only [run-jetty]]
        [ring.middleware params keyword-params nested-params]
        [ring.util.response :only (redirect)]
        [clojure.data.json :only (read-json json-str)]
        )
  (:require [compojure.core :refer :all]
            [compojure.handler :as handler]
            [compojure.route :as route]
            [clojure.java.io :as io]
            [ring.util.io :refer [string-input-stream]]
            [ring.util.response :as resp]
            [ring.util.response :refer [response]]
            [ring.middleware.json :as middleware]
            [ring.middleware.cors :refer [wrap-cors]]
            [environ.core :refer [env]]
            [recursiftion.model :as model]
            [recursiftion.models.users :as users]
            [recursiftion.auth :refer [auth-backend user-can user-has-id authenticated-user unauthorized-handler make-token! delete-token]]
            [buddy.sign.jws :as jws]
            [buddy.auth :refer [authenticated? throw-unauthorized]]
            [buddy.auth.backends.token :refer [jws-backend]]
            [buddy.auth.middleware :refer [wrap-authentication wrap-authorization]]
            [buddy.auth.accessrules :refer [restrict]]
            [bouncer.core :as b]
            [bouncer.validators :as v]))

 


; (defn create-tab-relationship [{user :body}]
;   (let [new-user (users/create user)]
;     {:status 201
;      :headers {"Location" (str "/users/" (:id new-user))}}))


; (defn get-tab-relationships-by-id [{{:keys [id]} :params}]
;   (response (recursiftion.model/get-tab-inventory (read-string id))))

; (defn underscores? [string]
;   (println (== 1 (count (clojure.string/split string #"_"))))
;   (== 1 (count (clojure.string/split string #"_")))
; )

(v/defvalidator underscores?

  {:default-message-format "%s must have no additional underscores"}
  [string]
  ; (println string)
  ; (println (== 2 (count (clojure.string/split string #"_"))))
  (== 2 (count (clojure.string/split string #"_")))
)

; /((([A-Za-z]{3,9}:(?:\/\/)?)(?:[-;:&=\+\$,\w]+@)?[A-Za-z0-9.-]+|(?:www.|[-;:&=\+\$,\w]+@)[A-Za-z0-9.-]+)((?:\/[\+~%\/.\w-_]*)?\??(?:[-\+=&;%@.\w_]*)#?(?:[\w]*))?)/


(defn validate-message [params]
  (first
    (b/validate (get-in params [:nodeobj])
    :name v/string
    :type v/string
    :color v/string
    :id  underscores?
    :background [[v/matches #"(?:([^:/?#]+):)?(?://([^/?#]*))?([^?#]*\.(?:jpg|gif|png))(?:\?([^#]*))?(?:#(.*))?"]])))

; [v/required [v/min-count 10]]

(defn transfer-tab [{old_tab_object :body}]
  (let [new_tab_object (model/transferTab old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))


(defn create-tab-batch [{old_tab_object :body}]
  (let [new_tab_object (model/createTabBatch old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))


(defn push-batch [{old_tab_object :body}]
  (let [new_tab_object (model/pushBatch old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn unshift-node-batch [{old_tab_object :body}]
  (let [new_tab_object (model/unshiftNodeBatch old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn update-tab [{old_tab_object :body}]
  (let [new_tab_object (model/updateTab old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn update-current-tab [{old_tab_object :body}]
  (let [new_tab_object (model/updateCurrentTab old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn update-current-date [{old_tab_object :body}]
  (let [new_tab_object (model/updateCurrentDate old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn update-is-open [{old_tab_object :body}]
  (println "SOUNDGARDEN" old_tab_object)
  (let [new_tab_object (model/updateIsOpen old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}})
)

(defn update-is-favorite [{old_tab_object :body}]
  (let [new_tab_object (model/updateIsFavorite old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn decrement-leaf-count [{old_tab_object :body}]
  (let [new_tab_object (model/decrementLeafCount old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))


(defn replace-node-at-index-batch [{old_tab_object :body}]
  (let [new_tab_object (model/replaceNodeAtIndexBatch old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn create-calendar-batch [{old_tab_object :body}]
  (let [new_tab_object (model/createCalendarBatch old_tab_object)]
    {:status 201
     :headers {"Location" (str "/calendar/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn edit-node-from-pointer [{old_tab_object :body}]
  (let [new_tab_object (model/editNodeFromPointer old_tab_object)]
    {:status 201
     :headers {"Location" (str "/node/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))






; (defn fetch-instance-batch [{old_tab_object :body}]
;   (let [new_tab_object (model/fetchInstanceBatch old_tab_object)]
;     {:status 201
;      :headers {"Location" (str "/instance/" (:id new_tab_object))}
;      :body {:new_tab_object new_tab_object}}))

(defn push-tab [{old_tab_object :body}]
  (let [new_tab_object (model/pushTab old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn exchange-tab [{old_tab_object :body}]
  (let [new_tab_object (model/exchangeTab old_tab_object)]
    {:status 201
     :headers {"Location" (str "/tabs/" (:id new_tab_object))}
     :body {:new_tab_object new_tab_object}}))

(defn create-node [{old_node_object :body}]
  (let [new_node_object (model/createNode old_node_object)]
    {:status 201
     :headers {"Location" (str "/nodes/" (:id new_node_object))}
     :body {:new_node_object new_node_object}}))

(defn fetch-node [{old_node_object :body}]
  (let [new_node_object (model/createNode old_node_object)]
    {:status 201
     :headers {"Location" (str "/nodes/" (:id new_node_object))}
     :body {:new_node_object new_node_object}}))

; (defn create-node [{old_node_object :body}]
  
;     {:status 201
;      :body {:new_node_object (model/createNode old_node_object)}}

  ; (if-let [errors (validate-message old_node_object)]
  ;   (do
  ;     (println errors)
  ;     {:status 400
  ;      :body errors}
  ;   )
  ;   {:status 201
  ;    :body {:new_node_object (model/createNode old_node_object)}}
  ; )
; )

; (defn save-message! [{:keys [params]}]
;   (if-let [errors (validate-message params)]
;     (-> (redirect "/")
;         (assoc :flash (assoc params :errors errors)))
    ; (do
    ;   (db/save-message!
    ;    (assoc params :timestamp (java.util.Date.)))
    ;   (redirect "/"))))


(defn create-user [{ requestpayload :body }]
  (let [new-user-object (users/insert-user (get-in requestpayload [:userobject]))
        new-instance-object (users/create-new-instance (get-in requestpayload [:instanceobject]) )]
    {:status 201
     :headers {"Location" (str "/users/" (:id new-user-object))}
     :body {
        :userobject new-user-object
        :instanceobject new-instance-object
      }}))



;; AKA register
(defn find-user [userid]
  (let [fetched-user-object (users/find-user-by-id userid)]
    {:status 201
     :headers {"Location" (str "/users/" (:id fetched-user-object))}
     :body {:userobject fetched-user-object}}))


; (defn find-user [{{:keys [id]} :params}]
;   (response (users/find-user-by-id (read-string id))))



(defroutes app-routes


  ; (context "/tab" []
  ;   (POST "/" [] create-tab-relationship)
  ;   (context "/:id" [id]
  ;     (restrict
  ;       (routes
  ;         (GET "/" [] find-user))
  ;       {:handler {:and [authenticated-user
  ;                        {:or [(user-can "manage-users")
  ;                              (user-has-id (read-string id))]}]}
  ;        :on-error unauthorized-handler})))

  (POST "/login" {{:keys [userid password argarray inheritpayload]} :body}
    (if (users/password-matches? userid password)
      (do (model/processInheritance inheritpayload userid)
          {:status 201
           :body {:auth-token (make-token! userid)
                  :userobject (users/find-user-by-id userid)
                  :instanceobj (model/fetchInstanceBatch userid argarray)}})
      {:status 409
       :body {:status "error"
              :message "invalid username or password"}}))


  (POST "/logout" {{:keys [token argarray]} :body}
    (if (delete-token token)
      {:status 200
       :body {:status "success"
              :instanceobj (model/fetchInstanceBatch "mysyllabi" argarray)
              :message "successfully logged out"}}
      {:status 409
       :body {:status "error"
              :message "error trying to log out"}}))



  (POST "/instance" {{:keys [instanceid argarray]} :body}
      (println "&&&&&&&&&&&")
      (println "instanceid" instanceid)
      (println "argarray" argarray)
      {:status 201
       :body (model/fetchInstanceBatch instanceid argarray)}

  )


  ;; AKA /register
  (POST "/user" [] create-user)

  (context "/user/:id" [id]
    (restrict
      (GET "/" [] (find-user id))
      {:handler {:and [authenticated-user
                       {:or [(user-can "manage-users")
                             (user-has-id (read-string id))]}]}
       :on-error unauthorized-handler}  
    )
  )

  (context "/calendar/create" []
    (restrict
      (POST "/" [] create-calendar-batch)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/push-batch" []
    (restrict
      (POST "/" [] push-batch)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/transfer" []
    (restrict
      (POST "/" [] transfer-tab)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/create-tab-batch" []
    (restrict
      (POST "/" [] create-tab-batch)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/unshift-node-batch" []
    (restrict
      (POST "/" [] unshift-node-batch)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/update" []
    (restrict
      (POST "/" [] update-tab)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/update-current-date" []
    (restrict
      (POST "/" [] update-current-date)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/update-current-tab" []
    (restrict
      (POST "/" [] update-current-tab)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/update-is-open" [] (POST "/" [] update-is-open)
    ; (restrict
    ;   (POST "/" [] update-is-open)
    ;   {:handler {:and [authenticated-user (user-can "manage-nodes")]}
    ;    :on-error unauthorized-handler} 
    ; )
  )

  (context "/tab/update-is-favorite" []
    (restrict
      (POST "/" [] update-is-favorite)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/decrement-leaf-count" []
    (restrict
      (POST "/" [] decrement-leaf-count)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )


  (context "/tab/replace-node-at-index-batch" []
    (restrict
      (POST "/" [] replace-node-at-index-batch)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  
  (context "/tab/push" []
    (restrict
      (POST "/" [] push-tab)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/tab/exchange" []
    (restrict
      (POST "/" [] exchange-tab)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (context "/node/edit-node-from-pointer" []
    (restrict
      (POST "/" [] edit-node-from-pointer)
      {:handler {:and [authenticated-user (user-can "manage-nodes")]}
       :on-error unauthorized-handler} 
    )
  )

  (GET "/tab/:tabid" request
      (let [leafid (or (get-in request [:params :tabid])
                       (get-in request [:body :tabid])
                            "ROUTER_ERROR")]

        {:status 200
         :headers {"Content-Type" "application/json"}
         :body (recursiftion.model/get-tab leafid)
        }
  ))


  (POST "/tab-instance" {{:keys [tabid tabprefix application_instance username]} :body}
      {:status 201
       :body (model/fetchTabInstance tabid tabprefix application_instance username)
      }
  )


  (GET "/node/:nodeid" request
      (let [nodeid (or (get-in request [:params :nodeid])
                       (get-in request [:body :nodeid])
                            "2ROUTER_ERROR")]
        
        {:status 200
         :headers {"Content-Type" "application/json"}
         :body (recursiftion.model/get-node nodeid)
        }
  ))


  ; (GET "/instance/:instanceid" request
  ;     (let [instanceid (or (get-in request [:params :instanceid])
  ;                      (get-in request [:body :instanceid])
  ;                           "2ROUTER_ERROR")]
        
  ;       {:status 200
  ;        :headers {"Content-Type" "application/json"}
  ;        :body (recursiftion.model/fetchInstanceBatch instanceid)
  ;       }
  ; ))







  ; (restrict
  ;     (GET "/user/:id" request
  ;         (let [id (or (get-in request [:params :id])
  ;                      (get-in request [:body :id])
  ;                               "ROUTER_ERROR")]

  ;         (find-user id)

  ;         ; (if-not (authenticated? request)
  ;         ;     (throw-unauthorized)
  ;         ;     (find-user id))
  ;     ))
  ;     {:handler {:and [authenticated-user
  ;                        {:or [(user-can "manage-users")
  ;                              (user-has-id (read-string id))]}]}
  ;        :on-error unauthorized-handler}  
  ; )



  ; (context "/user" []
  ;   (POST "/" [] create-user)
  ;   (context "/:id" [id]
  ;     (routes
  ;       (GET "/" [] find-user id))))
  ; (context "/users" []
  ;   (POST "/" [] create-user)
  ;   (context "/:id" [id]
  ;     (restrict
  ;       (routes
  ;         (GET "/" [] find-user)
  ;       {:handler {:and [q
  ;                        {:or [(user-can "manage-users")
  ;                              (user-has-id (read-string id))]}]}
  ;        :on-error unauthorized-handler})))



  ; (GET "/ws"   [:as req] (wamp-handler req))

  ;; static files under ./resources/public folder
  (route/resources "/")
  ;; 404, modify for a better 404 page
  (route/not-found "<p>Page not found.</p>")

)

(defn wrap-log-request [handler]
  (fn [req]
    (println req)
    (handler req)))

(def app
  (-> app-routes
      (wrap-authentication auth-backend)
      (wrap-authorization auth-backend)
      (middleware/wrap-json-body {:keywords? true})
      (middleware/wrap-json-response)
      (wrap-cors routes #"^$")))


(defn -main []
  (run-jetty app {:port (if (nil? (System/getenv "PORT"))
                          4200 ; localhost or heroku?
                          (Integer/parseInt (System/getenv "PORT")))}) )