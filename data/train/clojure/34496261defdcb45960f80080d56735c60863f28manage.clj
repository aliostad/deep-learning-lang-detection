(ns sketchpad.fuzzy.manage
	(:use [seesaw.core]
				[sketchpad.fuzzy.component])
	(:require [sketchpad.state.state :as state]))

(defn hide-fuzzy
	[panel text-area]
	(reset! fuzzy-visible false)
	(invoke-later
		(config! panel :visible? false)
		(config! text-area :visible? false)))

(defn show-fuzzy
	[panel text-area]
	(reset! fuzzy-visible true)
	(invoke-later
		(config! panel :visible? true)
		(config! text-area :visible? true)
		(.requestFocus text-area)))

(defn toggle-fuzzy
	[]
	(let [fuzzy-panel (get-in (:fuzzy @state/app) [:component :container])
				fuzzy-text-area (get-in (:fuzzy @state/app) [:component :text-area])
				editor-panel (get-in (:buffer-component @state/app) [:component :container])]
		(if @fuzzy-visible
			(do
				(hide-fuzzy fuzzy-panel fuzzy-text-area))
			(do
				(show-fuzzy fuzzy-panel fuzzy-text-area)))))