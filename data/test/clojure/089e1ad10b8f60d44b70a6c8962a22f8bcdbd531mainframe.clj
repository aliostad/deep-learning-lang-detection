(ns layout.mainframe
  (:use seesaw.core)
  (:gen-class))

(defn menu-handler
  [event]
  (println event))

(defn new-chart [_]
  (-> (frame :title "a New Chart"
             :width 512 :height 400)
      show!))

(declare main-window)
(def num-of-tabs (atom 0))

(defn new-instrument [e]
  (let [tabs (select main-window [:#EditorTabs])]
    (config! tabs :tabs [{:title (str "tab" (swap! num-of-tabs inc))}])))

(def new-chart-action      (menu-item :text "Chart" :font "ARIAL-14" :listen [:action new-chart]))
(def new-datasrc-action    (menu-item :text "Instrument" :font "ARIAL-14"  :listen [:action new-instrument]))
(def new-indicator-action  (menu-item :text "Indicator" :font "ARIAL-14" :listen [:action menu-handler]))
(def exit-action           (menu-item :text "Exit"   :listen [:action (fn [e] (System/exit 0))]))

(def file-menu (menu :text "File" :font "ARIAL-15" :items
                     [(menu :text "New..." :font "ARIAL-14"
                            :items [new-chart-action new-datasrc-action new-indicator-action])
                      (separator)
                      exit-action]))

(def main-menubar (menubar :items [file-menu]))

(def main-window (frame :title "i-Charts"
                        :width 512 :height 400
                        :content (tabbed-panel :placement :top
                                               :id :EditorTabs)
                        :menubar main-menubar
                        :on-close :exit))



(defn -main [& args]
  (invoke-later
   (show! main-window)))

