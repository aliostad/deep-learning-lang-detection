(ns ui.core
    (:require [reagent.core :as reagent :refer [atom]]
              [reagent.session :as session]
              [secretary.core :as secretary :include-macros true]
              [goog.events :as events]
              [goog.history.EventType :as EventType]
              [ajax.core :refer [GET]])
    (:import goog.History))

(enable-console-print!)

;; -------------------------
;; Views

(defn collate [lines]
  (let [[collated _]
        (reduce (fn [[acc current] line]
                  (if-let [match (re-matches #"^=== (.*)" line)]
                    (let [date (get match 1)]
                      [(assoc acc date []) date])
                    [(update acc current #(conj % line)) current]))
                [{} nil]
                lines)]
    collated))


(defn find-here-blocks [lines]
  (:out (reduce (fn [{:keys [out state]} line]
             (case state
               :outside (if (= "<<<" line)
                          {:out out :state []}
                          {:out (conj out line) :state state})
               ;; inside <<< block
               (if (= ">>>" line)
                 {:out (conj out `[:div.here-block ~@state]) :state :outside}
                 {:out out :state (conj state (str line "\n"))})))
           {:out []
            :state :outside} lines)))

(defn markup-lines [lines]
  (map
   (fn [line]
     (if (string? line)
       (condp (comp seq re-seq) line
         #"^(https?://[^ ]+)" :>> #(do [:span [:a {:href (second (first %))} (second (first %))] "\n"])
         #"^occ//chef-manage/(.*)" :>>
         #(let [path (second (first %))]
            [:span.pill.type-gh
             [:a {:href (str "https://github.com/chef/chef-manage/tree/master/" path)} line] "\n"])
         #"^TODO: (.*)" :>> #(do [:span [:span.pill.type-q "TODO"] [:span.bold (second (first %))] "\n"])
         #"^DONE: (.*)" :>> #(do [:span [:span.pill.type-a "DONE"] [:span (second (first %))] "\n"])
         #"^Q: (.*)" :>> #(do [:span [:span.pill.type-q "Q"] [:span.bold (second (first %))] "\n"])
         #"^A: (.*)" :>> #(do [:span [:span.pill.type-a "A"] (second (first %)) "\n" ])
         #"^\$ (.*)" :>> #(do [:span [:span.pill.type-shell "$"] [:span.shell (second (first %))] "\n" ])
         #"^A:$" :>> #(do [:span [:span.pill.type-a "A"] "\n"])
        (str line "\n"))
      line))
   lines))

(GET "/api/notes" {:handler #(session/put! :data %)
                   :keywords? true
                   :response-format :json})

(defn home-page []
  [:div
   (for [entry (session/get :data)]
     (let [{:keys [date lines]} entry]
       ^{:key date} [:div.day
                     [:div.date date]
                     `[:div.entry
                       ~@(-> lines
                             (find-here-blocks)
                             (markup-lines))
                       ]]))])

;; -------------------------
;; Initialize app
(defn mount-root []
  (reagent/render [home-page] (.getElementById js/document "app")))

(defn init! []
  (mount-root))
