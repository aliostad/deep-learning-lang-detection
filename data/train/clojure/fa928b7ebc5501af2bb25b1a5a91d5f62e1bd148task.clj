(ns morgan.views.task
  (:require [net.cgrand.enlive-html :as html]
            [morgan.models.task :as t]
            [noir.session :as session])
  (:use [noir.core :only [defpage pre-route]]
        [noir.response :only [redirect]]
        [morgan.views.layout :only [layout]])) 

(html/defsnippet task  "morgan/views/task.html" [:#task]
  [tasks]
  [:#tasks-table]
  (html/clone-for [i tasks]
                  [:tr :td.task]
                  (html/content (:task i))

                  [:tr :td.date]
                  (html/content (str (:time i)))

                  [:tr :td :form :button.delete]
                  (html/do->
                   (html/content "Delete")
                   (html/set-attr :value (str (:_id i))))))

(pre-route "/task" {}
          (when-not (session/get :user-id)
            (redirect "/login")))

(defpage "/task" []
  (layout
   {:title "Morgan manage task"
    :wrapper
    (task
     (t/task-from-user-id (session/get :user-id)))
    :script-js ["http://code.jquery.com/jquery-1.7.2.min.js"
                "http://code.jquery.com/ui/1.8.21/jquery-ui.min.js"
                "/js/jQuery-Timepicker-Addon/jquery-ui-timepicker-addon.js"
                "/js/jQuery-Timepicker-Addon/jquery-ui-sliderAccess.js"
                "/js/jQuery-Timepicker-Addon/getdate.datetimepicker.js"]
    :css ["http://code.jquery.com/ui/1.8.21/themes/ui-lightness/jquery-ui.css"
          "/js/jQuery-Timepicker-Addon.css"]}))

(defpage [:post "/task/add"] {:keys [new-task date]}
  (t/memorize-task new-task date (session/get :user-id))
  (redirect "/task"))

(defpage [:post "/task/remove"] {:keys [task-id]}
  (t/delete-task (session/get :user-id) task-id)
  (redirect "/task"))
