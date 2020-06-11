(ns todo.main
 (:require [ajax.core :refer [GET POST ajax-request transform-opts]]
           [dommy.core :as dom])
 (:use-macros [dommy.macros :only [node sel1 sel by-id]]))


(def gapiImm (js-obj "client_id" "724598683708.apps.googleusercontent.com"
                        "scope" "https://www.googleapis.com/auth/tasks"
                        "immediate" true))

(def gapiNotImm (js-obj "client_id" "724598683708.apps.googleusercontent.com"
                        "scope" "https://www.googleapis.com/auth/tasks"
                        "immediate" false))


(defn log [& stuff]
  (.log js/console (clojure.string/join " " stuff)))

(defn PUT [uri & [opts]]
   (ajax-request uri "PUT" (transform-opts opts)))


(def *parent* nil) ;; FIXME
(def *options* {
                :hide-completed true})

(defn toggle-hide-completed []
  (set! *options* (assoc *options* :hide-completed (not (*options* :hide-completed))))
  (if (*options* :hide-completed)
    (dorun (map #(dom/add-class! % "hidden") (sel ".completed")))
    (dorun (map #(dom/remove-class! % "hidden") (sel ".completed")))))

(dom/listen! (sel1 :#opt-hide-completed) :change toggle-hide-completed)

;; starting point
(defn authCb [token]
  "Manage the authetication token"
  (if (= token nil)
    (.authorize js/gapi.auth gapiNotImm authCb)
    (do
      (.setItem js/localStorage "gapi_token" (.-access_token token))
      (get-lists))))

(defn make-auth-token []
  "Generate authentication token for header"
  (clojure.string/join " " ["Bearer" (.getItem js/localStorage "gapi_token")]))

(defn submit-task [e]
  (if (or (= (aget e "which") 13) (= (aget e "keyCode") 13))
    (let [el-input (aget e "target")
          task-message (aget el-input "value")]
      (create-task task-message))))

(defn display-list [title id]
  "Adds a new task list to the DOM"
  (when (seq title)
    (let [tl (node [:li {:id id} title [:ul]])
          el-input (node [:input {:type "text"
                                :placeholder "Something to do"
                                :class "add-task"}])]
      (dom/append! (sel1 :#tasklists) tl)
      (dom/append! tl el-input)
      (dom/listen! el-input :keydown submit-task)
      (dom/listen! tl :click get-tasks))))

(defn process-lists [resp]
   (doseq [task (get resp "items")]
     (display-list (get task "title") (get task "id"))))

(defn set-status-ack []
  (log "set status"))

(defn set-status [task-id new-status target]
  (PUT (str "https://www.googleapis.com/tasks/v1/lists/" *parent* "/tasks/" task-id)
       {:format :json :headers {"Authorization" (make-auth-token)}
        :params {:id task-id
                 :parent *parent*
                 :status new-status}
        :handler set-status-ack}))

(defn add-checkbox [elem status]
  (let [check (node [:input {:type "checkbox",
                             :class "input-check"}])
        done (= status "completed")
        toggled-status (if done "needsAction" "completed")
        label (node [:label {:class "topcoat-checkbox"}])
        checkmark (node [:div {:class "topcoat-checkbox__checkmark"}])]
    (if done
      (dom/set-attr! check :checked true))
    (dom/append! label check)
    (dom/append! label checkmark)
    (dom/listen! label :change (partial set-status (dom/attr elem :id) toggled-status))
    (dom/append! elem label)))

(defn display-task [text id status]
  "Adds a new task under a task list"
    (let [li (node [:li {:id id}])
          span (node [:span text])]
      (add-checkbox li status)
      (dom/append! li span)
      (when (= status "completed")
        (dom/add-class! li "completed")
        (when (*options* :hide-completed)
          (dom/add-class! li "hidden")))
      (dom/append! (sel1 :#tasks) li)))

(defn process-tasks [resp]
   ;; clear old ones first
   (dom/set-html! (sel1 :#tasks) "")
   (doseq [task (get resp "items")]
     (let [title (get task "title")
           id (get task "id")
           status (get task "status")]
       (when (> (seq title)) ;; Google gives me empty tasks
         (display-task title id status)))))

(defn append-task [task-message]
  (log task-message))

;; /lists/tasklist/tasks
(defn create-task [task-message]
  (POST (str "https://www.googleapis.com/tasks/v1/lists/" *parent* "/tasks")
       {:format :json :headers {"Authorization" (make-auth-token)}
        :params {:tasklist *parent*
                 :title task-message}
        :handler (append-task task-message)}))

(defn get-lists []
  (GET "https://www.googleapis.com/tasks/v1/users/@me/lists"
       {:format :json :headers {"Authorization" (make-auth-token)}
        :handler process-lists}))

(defn get-tasks [e]
  (let [id (dom/attr (aget e "target") "id")
        el-active (sel1 ".active")]
    (if-not (or (= *parent* id) (= nil id))
      (do
        (set! *parent* id)
        (when el-active (dom/remove-class! el-active "active"))
        (dom/add-class! (sel1 (str "#" id)) :active)
        (GET (str "https://www.googleapis.com/tasks/v1/lists/" id "/tasks")
           {:format :json :headers {"Authorization" (make-auth-token)}
            :handler process-tasks})))))

(defn ^:export authorize []
  (.authorize js/gapi.auth gapiImm authCb))


