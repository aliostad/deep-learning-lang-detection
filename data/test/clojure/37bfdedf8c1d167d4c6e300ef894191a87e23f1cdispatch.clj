(ns note.dispatch.dispatch
  (:require (note.dispatch (common :as common_)
                           (create-note :as create-note_)
                           (create-user :as create-user_)
                           (css :as css_)
                           (login :as login_)
                           (task-list :as task-list_)
                           (toggle-note :as toggle-note_)
                           (path :as path_))
            :reload-all))

(def dispatcher-coll
  [;; root
   (common_/make (common_/make-predicate :method :get
                                         :uri "/")
                 (constantly (common_/redirect :login)))
   ;; css
   (common_/make (common_/make-predicate :method :get
                                         :uri "/note.css")
                 css_/get-dispatch)
   ;; login
   (common_/make (common_/make-predicate :method :get
                                         :uri (path_/get :login))
                 login_/get-dispatch)
   (common_/make (common_/make-predicate :method :post
                                         :uri (path_/get :login))
                 login_/post-dispatch)
   ;; new user
   (common_/make (common_/make-predicate :method :get
                                         :uri (path_/get :create-user))
                 create-user_/get-dispatch)
   (common_/make (common_/make-predicate :method :post
                                         :uri (path_/get :create-user))
                 create-user_/post-dispatch)
   ;; task list
   (common_/make (common_/make-predicate :method :get
                                         :uri (path_/get :task-list))
                 task-list_/get-dispatch)
   (common_/make (common_/make-predicate :method :post
                                         :uri (path_/get :task-list))
                 task-list_/post-dispatch)
   ;; create node
   (common_/make (common_/make-predicate :method :get
                                         :uri (path_/get :create-note))
                 create-note_/get-dispatch)
   (common_/make (common_/make-predicate :method :post
                                         :uri (path_/get :create-note))
                 create-note_/post-dispatch)
   ;; toggle note
   (common_/make (common_/make-predicate :method :get
                                         :uri (path_/get :toggle-note))
                 toggle-note_/get-dispatch)
   ])

(defn process
  [request]
  (let [dispatchers (filter (fn [{pred :pred}]
                              (when (pred request)
                                true))
                            dispatcher-coll)]
    (case (count dispatchers)
      0 nil ;; (throw (Exception. "No dispatcher found for request."))
      1 ((-> dispatchers first :dispatch) request)
      (throw (Exception. "Multiple dispatchers found.")))))
