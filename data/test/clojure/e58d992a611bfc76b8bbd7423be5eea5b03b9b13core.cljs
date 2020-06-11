(ns clj-number-game-third.core
	(:require [reagent.core :as reagent]
			  [re-frame.core :as re-frame]
			  [clj-number-game-third.handlers]
              [clj-number-game-third.subs]
              [clj-number-game-third.views :as views]))

;;(enable-console-print!)

(defn mount-root []
	(re-frame/dispatch-sync [:initialize-db])
	(reagent/render [views/container]
		(.getElementById js/document "app"))
	)

(mount-root)

(defn ^:export init []
  (re-frame/dispatch-sync [:initialize-db])
  (mount-root))

 (defn ^:export run []
   (re-frame/dispatch-sync [:initialize-db])
   (mount-root))
