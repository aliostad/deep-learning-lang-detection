(ns leiningen.lispkorea
  (:use [leiningen.help :only (help-for subtask-help-for)]
        [leiningen.lispkorea.user :only (add-user del-user list-user)]))

(defn- nary? [v n]
  (some #{n} (map count (:arglists (meta v)))))

(defn lispkorea
  "Manage lispkorea web application."
  {:help-arglists '([add-user del-user list-user])
   :subtasks [#'add-user #'del-user]}
  ([project]
     (println (if (nary? #'help-for 2)
                (help-for project "lispkorea")
                (help-for "lispkorea"))))
  ([project subtask & args]
     (case subtask
       "add-user" (apply add-user project args)
       "del-user" (apply del-user project args)
       "list-user" (apply list-user project args)
       (println "Subtask" (str \" subtask \") "not found."
                (subtask-help-for *ns* #'lispkorea)))))
