(ns leiningen.checkout
  (:refer-clojure :exclude [list])
  (:require [fs.core                    :as fs]
            [leiningen.checkout.utils   :as utils]
            [leiningen.checkout.ln      :refer [ln]]
            [leiningen.checkout.rm      :refer [rm]]
            [leiningen.checkout.enable  :refer [enable]]
            [leiningen.checkout.disable :refer [disable]]
            [leiningen.checkout.list    :refer [list]]))

(def task-dispatch
  {"ln" #'ln
   "rm" #'rm
   "enable" #'enable
   "disable" #'disable
   "list" #'list
   :default #'ln})

(defn
  ^{:subtasks [#'ln
               #'rm
               #'enable
               #'disable
               #'list]}
  checkout
  "Manage your checkouts directory.

Add a `:checkout` key to your project or `:user` profile which is a vector of directory paths under which projects to be considered for checkouts can be found.

ln: add a project to your checkouts.
rm: remove a project from your checkouts.
disable: temporarily move aside checkouts.
enable: re-enable checkouts, moving it back into place.

Call `lein help checkout` for more options."
  [project & args]
  #_(println (utils/pprint-str [project args]))
  (apply
   (or (task-dispatch (first args)) (:default task-dispatch))
   project
   (if (task-dispatch (first args))
     (rest args)
     args)))
