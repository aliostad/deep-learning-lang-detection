(ns kulive.typeahead
  (:require [kulive.handlers]
            [kulive.subs]
            [kulive.utils :refer [value-of]]
            [re-frame.core :as rf])
  (:require-macros [reagent.ratom :refer [reaction]]))

(defn typeahead []
  (let [typeahead-db (rf/subscribe [:typeahead-db])
        courses (rf/subscribe [:courses])
        course-count (reaction (count @courses))
        data-source (fn [text]
                      (filter
                       #(-> (.toLowerCase %) (.indexOf text) (> -1))
                       ["Alice" "Alan" "Bob" "Beth" "Jim" "Jane" "Kim" "Rob" "Zoe"]))
        value (reaction (:value @typeahead-db))
        index (reaction (:index @typeahead-db))
        selections (reaction (:selections @typeahead-db))
        typeahead-hidden? (reaction (:hidden? @typeahead-db))
        mouse-on-list? (reaction (:mouse-on-list? @typeahead-db))]
    (fn []
      [:form
       [:label "강의 검색 (" @course-count ")"]
       [:input
        {:type "search"
         :placeholder "과목명, 교수, 번호, 학부, 과, 학점..."
         :style {:width "100%" :margin-bottom "0rem" :font-size "2.5rem" :height "6rem"}
         :value @value
         :on-blur #(when-not @mouse-on-list?
                     (rf/dispatch [:set-typeahead-hidden true])
                     (rf/dispatch [:set-typeahead-index 0]))
         :on-change #(do
                       (rf/dispatch [:set-typeahead-val (value-of %)])
                       (rf/dispatch [:select-typeahead (when-not (= "" (value-of %))
                                                         (data-source (.toLowerCase (value-of %))))])
                       (rf/dispatch [:set-typeahead-hidden false])
                       (rf/dispatch [:set-typeahead-index 0]))
         :on-key-down #(do
                         (case (.-which %)
                           ;; Up key
                           38 (do (.preventDefault %)
                                  (if-not (= 0 @index)
                                    (rf/dispatch [:set-typeahead-index (dec @index)])))
                           ;; Down key
                           40 (do (.preventDefault %)
                                  (if-not (= @index
                                             (dec (count @selections)))
                                    (rf/dispatch [:set-typeahead-index (inc @index)])))
                           ;; Enter key
                           13 (do (.preventDefault %)
                                  (rf/dispatch [:set-typeahead-val
                                                (nth @selections @index)])
                                  (rf/dispatch [:set-typeahead-hidden true]))
                           ;; Esc key
                           27 (do (rf/dispatch [:set-typeahead-hidden true])
                                  (rf/dispatch [:set-typeahead-index 0]))
                           "default"))}]
       [:ul {:hidden (or (empty? @selections) @typeahead-hidden?)
             :class "typeahead-list"
             ;; :on-mouse-enter (rf/dispatch [:set-mouse-on-list true])
             ;; :on-mouse-leave (rf/dispatch [:set-mouse-on-list false])
             }
        (doall
         (map-indexed
          (fn [i result]
            [:li {:tab-index i
                  :key i
                  :class (if (= @index i) "highlighted" "typeahead-item")
                  :on-mouse-over #(do
                                    (rf/dispatch [:set-typeahead-index
                                                  (js/parseInt (.getAttribute (.-target %) "tabIndex"))]))
                  :on-click #(do
                               (rf/dispatch [:set-typeahead-hidden true])
                               (rf/dispatch [:set-typeahead-val result]))} result])
          @selections))]
       [:div {:style {:margin-top "2rem"}} ;; Just for visualizaiton
        [:pre (str "first course: " (first @courses))]
        [:pre (str "data source: " (data-source @value))]
        [:pre (str "value: " @value)]
        [:pre (str "typeahead-hidden: " @typeahead-hidden?)]
        [:pre (str "mouse on list: " @mouse-on-list?)]
        [:pre (str "selections: " @selections)]
        [:pre (str "selected index: " @index)]]])))

