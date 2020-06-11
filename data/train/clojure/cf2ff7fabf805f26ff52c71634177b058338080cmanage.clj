(ns nestvoting.manage
  (:require [tools.tasks :as tasks])
  (:gen-class))

; run with: java -cp nestvoting.jar nestvoting.manage

(def -main
  (tasks/main-fn
    (tasks/group "Nestvoting management"
      {:hello
        {:summary "Greets you"
         :description "It's nice to have a polite application"
         :options [["-n" "--name N" "Your name"
                    :id :name :default "stranger"]]
         :handler
           (fn [{{:keys [name]} :options}]
             (println (str "Hello " name "!")))}})))
