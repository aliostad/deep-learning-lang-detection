;; Copyright (C) 2011, Jozef Wagner. All rights reserved. 

(ns dredd.app
  "App management"
  (:use compojure.core
        ring.util.response
        [hiccup core page-helpers form-helpers]
        [incanter core excel])
  (:require [compojure.route :as route]
            [compojure.handler :as handler]
            [dredd.local-settings :as settings]
            [dredd.db-adapter.neo4j :as neo]
            [dredd.server :as server]
            [dredd.data :as data]
            [dredd.data.tests :as tests]
            [dredd.data.itest :as itest]
            [dredd.data.iquestion :as iquestion]
            [dredd.data.user :as user]))

;; Implementation details

;; Main

(defn- choose-group []
  (form-to [:post "set-group"]
           [:p "Vyberte si skupinu, do ktorej patrite: " (drop-down :group ["Pondelok 7:30" "Pondelok 13:30" "Streda 15:10"])]
           (submit-button "Pokracovat")))

(defn- login-form []
  (form-to [:post "login"]
           [:p "Username: " (text-field :username "")]
           [:p "Password: " (password-field :password "")]
           (submit-button "Log in")))

(defn- user-menu [user-id]
  (let [user (user/get user-id)]
    [:p
     (:cn user) " | "
     [:a {:href "choose"} "Vybrat cvicenie"] " | " ;; NOTE: localization
     [:a {:href "logout"} "Log out"]]))

(defn- main-page [user-id message]
  (html
   (html5
    [:head [:meta {:charset "UTF-8"}]]
    [:body
     [:h1 "Zistovanie pripravenosti studentov na cvicenia z predmetu Programovanie"] ;; NOTE: localization
     (when message [:p [:b message]])
     (if user-id
       (let [user (user/get user-id)]
         (if (or (user/admin? user-id) (:group user))
           (user-menu user-id)
           (choose-group)))
       (login-form))])))

;; Login

(defn- login-page! [username password]
  (io!)
  (let [user-id (user/login! username password)]
    (-> (redirect "main")
        (assoc :session (if user-id
                          {:user-id user-id}
                          {:message "Wrong username or password"})))))

;; Logout

(defn- logout-page []
  (-> (redirect "main")
      (assoc :session nil)))

(defn- set-group! [user-id group]
  (user/set-group! user-id group)
  (redirect "main"))

;; Choosing test

(defn- can-take-test [user-id test-id]
  (let [itest (itest/get user-id test-id)]
    (or (nil? itest) (not (:finished itest)))))

(defn- show-controls [user-id test-id]
  (if (users/admin? user-id)
    [:p [:a {:href (str "admin/" test-id)} "Administracia"] " "
     [:a {:href "export.xls"} "Export"]
     ]
    (if (can-take-test user-id test-id)
      [:a {:href (str "test/" test-id)} "Otvor"]
      [:a {:href (str "view/" test-id)} "Pozri vysledky"])))

(defn- choose-page [user-id]
  (html
   (html5
    [:body
     [:h1 "Vyber si cvicenie"] ;; NOTE: Localization
     (map
      (fn [t] [:p (:name t) " | " (show-controls user-id (:id t))])
      tests/tests)])))

;; Taking test

(defn- print-iquestion [& ids]
  (let [q (apply iquestion/get ids)]
    [:div 
     [:p [:b "Question " (:id q) ": "] (:name q)]
     [:p [:i (:text q)]]
     [:textarea {:rows "15" :cols "80" :name (:id q)} ""]]))

(defn- take-test-page [user-id test-id]
  (if-not (can-take-test user-id test-id)
    ;; user has already finished the test
    {:status  403
     :headers {}
     :body    "You have already finished this test"}
    ;; ready to take a test
    (let [itest (or (itest/get user-id test-id)
                    (data/add-itest! user-id (tests/get test-id)))
          user (user/get user-id)]
      (html
       (html5
        [:body
         [:h1 (:name itest)]
         (form-to [:post "../submit-test"]
                  (hidden-field :test-id test-id)
                  [:hr]
                  (map (partial print-iquestion user-id test-id) (:questions itest))
                  [:hr]
                  (submit-button "Odoslat a Ukoncit"))]))))) ;; NOTE: Localization

;; Viewing test

(defn- view-iquestion [& ids]
  (let [q (apply iquestion/get ids)]
    [:div 
     [:p [:b "Question " (:id q) ": "] (:name q)]
     [:p [:i (:text q)]]
     [:p [:i "Your answer: "]]
     [:p [:pre (h (:answer q))]]
     [:p [:i "Znamka: "] (:result q)]
     [:p [:i "Poznamka: "] (:comment q)]]))

(defn- view-test-page [user-id test-id]
  (let [itest (itest/get user-id test-id)
        user (user/get user-id)]
    (html
     (html5
      [:body
       [:h1 (:name itest)]
       [:hr]
       (map (partial view-iquestion user-id test-id) (:questions itest))
       [:hr]]))))

;; Submitting test

(defn- submit-test! [user-id test-id params]
  (io!)
  ;; TODO: only if not finished yet
  (data/submit-itest! user-id test-id params)
  (-> (redirect "main")
      (assoc :session {:user-id user-id
                       :message "Uspesne odoslane!"})))

;; Rank test

(defn- rank-test! [{:keys [student-id test-id question-id result comment]}]
  (io!)
  (iquestion/rank! student-id test-id question-id result comment)
  (redirect (str "admin/" test-id)))

;; Manage users

(defn- print-user [user-id]
  (let [user (user/get user-id)]
    [:div
     [:hr]
     [:p "Id: " [:b (:uid user)]]
     [:p "Name: " [:b (:givenName user)]]
     [:p "Surname: " [:b (:sn user)]]]))

(defn- manage-users []
  (html
   (html5
    [:body
     [:h1 "User management"]
     (map print-user (user/get-all))])))

;; Administrator interface

(defn- rank-iquestion [user-id test-id question-id]
   (let [q (iquestion/get user-id test-id question-id)]
    (when-not (:result q)
      [:div
       (form-to [:post "../rank-question"]
                (hidden-field :test-id test-id)
                (hidden-field :student-id user-id)
                (hidden-field :question-id question-id)
                [:p [:b "Question " (:id q) ": "] (:name q)]
                [:p [:i (:text q)]]
                [:p [:i "Your answer: "]]
                [:p [:pre (h (:answer q))]]
                [:p [:i "Znamka: "] (text-field :result (:result q))]
                [:p [:i "Poznamka: "] (text-field :comment (:comment q))]
                [:p (submit-button "Rank")]
                )])))

(defn- has-unranked-questions [user-id test-id]
  true
  (let [questions (:questions (itest/get user-id test-id))]
    (some #(not ( :result (iquestion/get user-id test-id %))) questions)))

(defn- admin-user-test [user-id test-id]
  (let [user (user/get user-id)
        itest (itest/get user-id test-id)]
    (when (has-unranked-questions user-id test-id)
      [:div
       [:hr]
       [:p (:cn user) " (" user-id ")"]
       (if (:finished itest)
         [:p "Test finished at " (:finished itest)]
         [:p "Test NOT finished"])
       (map (partial rank-iquestion user-id test-id) (:questions itest))])))

(defn- admin-test-page [test-id]
  (let [user-ids (user/get-all)]
    (html
     (html5
      [:body
       [:h1 "Administracia"]
       (map #(admin-user-test % test-id) user-ids)]))))

;; Export

(defn- question-header [test-id question-id]
  (let [h (str test-id "-" question-id "-")]
    [(str h "question") (str h "answer") (str h "result")]))

(defn- question-body [user-id test-id question-id]
  (let [q (iquestions/get-iquestion user-id test-id question-id)]
    [(:text q)
     (:answer q)
     (str (if (empty?
                            (str (:result q) (comment "(" (:comment q) ")")))
                         ""
                         (str(:result q))))]))

(defn- test-header [{test-id :id}]
  (let [qs (:questions (tests/get test-id))]
    (mapcat (partial question-header test-id) qs)))

(defn- create-sheet-header []
  (cons "Name:" (cons "Group:" (mapcat test-header tests/tests))))

(defn user-test-body [user-id {test-id :id}]
  (let [qs (:questions (tests/get test-id))]
    (mapcat (partial question-body user-id test-id) qs)))

(defn user-row [user-id]
  (let [u (users/get-user user-id)]
    (cons (users/get-user-name u)
          (cons (:group u)
          (mapcat (partial user-test-body user-id) tests/tests)))))

(defn- create-sheet-body []
  ;; each user has one row
  (map user-row (user/get-all))
  )
(defn- admin-export-page []
    (let [fname "temp.xls"
          sheet-header (create-sheet-header)
          sheet-body (create-sheet-body)]
      (save-xls (dataset sheet-header sheet-body) fname)
      (file-response fname)))

;; Middleware

;; TODO: authorization

(defmacro with-user [user-id & body]
  `(if (and ~user-id (not (data/maintenance?)))
     (do ~@body)
     {:status  403
      :headers {}
      :body    "You must be logged in to view this page!"}))

(defmacro with-admin [user-id & body]
  `(if (user/admin? ~user-id)
     (do ~@body)
     {:status  403
      :headers {}
      :body    "You must be administrator to view this page"}))

(defmacro with-test [test-id & body]
  `(if (tests/get ~test-id)
     (do ~@body)
     {:status  403
      :headers {}
      :body    "There is no such test!"}))

;; Page layout

;; TODO zaradenie do skupiny

(defroutes main-routes
  (GET "/" []
       (redirect (str (:base-url settings/server) "/main")))
  (GET "/main" {{:keys [user-id message]} :session}
       (main-page user-id message))
  (GET "/choose" {{user-id :user-id} :session}
       (with-user user-id
         (choose-page user-id)))
  (GET "/test/:test-id" {{user-id :user-id} :session {test-id :test-id} :route-params}
       (with-user user-id
         (with-test test-id
           (take-test-page user-id test-id))))
  (GET "/admin/:test-id" {{user-id :user-id} :session {test-id :test-id} :route-params}
       (with-admin user-id
         (with-test test-id
           (admin-test-page test-id))))  
  (GET "/admin-users" {{user-id :user-id} :session}
       (with-admin user-id
         (manage-users)))  
  (GET "/view/:test-id" {{user-id :user-id} :session {test-id :test-id} :route-params}
       (with-user user-id
         (with-test test-id
           (view-test-page user-id test-id))))
  (GET "/export.xls" {{user-id :user-id} :session}
       (with-admin user-id
         (admin-export-page)))
  (POST "/submit-test" {{user-id :user-id} :session {test-id :test-id :as params} :params}
       (with-user user-id
         (with-test test-id
           (submit-test! user-id test-id params))))
  (POST "/rank-question" {{user-id :user-id} :session {test-id :test-id :as params} :params}
       (with-admin user-id
         (rank-test! params)))  
  ;; TODO hodnotenie
  (GET "/logout" []
       (logout-page))
  (GET "/shutdown" {{user-id :user-id} :session}
       (with-admin user-id
         (server/shutdown!)
         "you may now stop the server"))
  (POST "/login" [username password]
        (login-page! username password))
  (POST "/set-group" {{user-id :user-id} :session {group :group :as params} :params}
        (with-user user-id
          (set-group! user-id group)))
  (POST "/user-do" [])
  (route/resources "/")
  (route/not-found "Page not found"))

;; TODO logging

(defn wrap-utf8
  [handler]
  (fn [request]
    (-> (handler request)
        (content-type "text/html; charset=utf-8"))))

;; Main App handler

(def handler
     (-> (handler/site main-routes)
         (wrap-utf8)))
