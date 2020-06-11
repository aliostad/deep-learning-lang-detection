(ns sanakan.ulitharid.server.views.todos
  (:require
    [clostache.parser :as clostache]
    [sanakan.ulitharid.server.commons :as commons]
    [sanakan.ulitharid.server.time :as t]
    [sanakan.ulitharid.server.views.commons :as vcommons]))

(defn todo-link
  "Create a link to an item."
  [item]
  [:a {:href (str vcommons/path-item "/" (:_id item))} (:name item)])

(defn done-link
  "Create a link to mark an task done."
  [item]
  [:a {:href (str vcommons/path-done "/" (:_id item))} "x"])

(defn todo-style
  [item]
  (let [days (t/days-till (:due item))]
    (cond
      (nil? days) " green"
      (= 0 days) " orange"
      (> 0 days) " red"
      (< 0 days) " green"
      :else "")))

(defn todo-text
  [item]
  [:div {:class (str "box " (todo-style item))}
   (todo-link item)
   (when-not (nil? (:due item)) [:div {:class "small"} "due on " (:due item)])
   (when-not (nil? (:desc item)) [:div {:class "small"} (:desc item)])
   (when-not (nil? (:reason item)) [:div {:class "small"} (:reason item)])
   [:div {:style "padding-right: 2px; text-align: right;"} (done-link item)]])

(defn due
  [i]
  (if (or (= "" (:due i)) (nil? (:due i))) "9999-99-99" (:due i)))

(defn sort-todos
  [raw]
  (sort-by #(due %) raw))

(defn map-todos
  [todos]
  [:div (interpose [:br] (map #(todo-text %) todos))])

(defn list-todos
  [raw]
  (map-todos (sort-todos (filter #(not (= "done" (:state %))) raw))))

(defn index
  "Create index page."
  [raw]
  (vcommons/page
    "manage todos"
    (list
      (list-todos raw)
      [:form {:method "POST" :action (str vcommons/path-todos)}
       [:div {:class "subheader"} "add new todo"]
       [:br]
       [:div "todo"]
       [:input {:type "text" :class "in" :name "name"}]
       [:br]
       [:div "reason"]
       [:input {:type "text" :class "in" :name "reason" :value ""}]
       [:br]
       [:div "due date"]
       [:input {:type "text" :class "in" :name "due" :value ""}]
       [:br]
       [:input {:type "hidden" :name "state" :value "open"}]
       [:input {:type "submit" :class "submit button" :value "add"}]
       ]
      [:div {:class "nav"}
       [:br]
       [:a {:href (str "/")} "back to index"]
       ])))

(defn projects
  "Create page for managing projects and todos."
  [raw]
  (let [updated (map #(assoc % :style (todo-style %)) raw)
        open (sort-todos (filter #(or (= "open" (:state %)) (nil? (:state %))) updated))
        progress (sort-todos (filter #(= "progress" (:state %)) updated))
        done (sort-todos (filter #(= "done" (:state %)) updated))]
    (str
      (clostache/render-resource "templates/header.html" {:title "Ulitharid"})
      (clostache/render-resource "templates/projects.html"
                                 {:open open
                                  :progress progress 
                                  :done done})
      (clostache/render-resource "templates/footer.html" {}))))
