(ns bookshelf.core
  (:require [devtools.core :as devtools]
            [reagent.core :as reagent]
            [re-frame.core :refer [dispatch dispatch-sync]]
            [bookshelf.db]
            [bookshelf.events]
            [bookshelf.subs]
            [bookshelf.views]))

;; -- Debugging aids ----------------------------------------------------------
(devtools/install!)       ;; we love https://github.com/binaryage/cljs-devtools
(enable-console-print!)   ;; so that println writes to `console.log`

(defn ^:export main
  []

  (dispatch-sync [:initialise-db])

  (reagent/render [bookshelf.views/app]    ;;
                  (.getElementById js/document "mount-point")))
