(ns expense-tracker.transaction.view
  (:require [expense-tracker.utils :as u]
            [expense-tracker.globals :as g]
            [expense-tracker.transaction.utils :as tu]
            [expense-tracker.account.rm :as ar]
            [expense-tracker.account.manage :as am]
            [clojure.string :as str]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; helpers

(defn individual-accs [haystack typeof needle]
  (->> haystack
       ((fn [x]
          (if needle
            (filter #(and (= typeof (:type @%))
                          (u/contains (:acc @%) needle))
                    x)
            (filter #(= typeof (:type @%)) x))))
       (mapv (fn [x] [(:acc @x) (:val @x)]))))

(defn trans-rm [e t]
  (when (u/confirm "Do you really want to delete this transaction?")
    (tu/rm-helper t)
    (u/trans-view nil (:attrs @g/app-page))))

(defn trans-edit [e t] (reset! g/app-page {:page :trans-edit :attrs {:id (:id t)}}))

(defn acc-edit [e] )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; components and views

(defn c-acc [[href _]]
  [:a {:href "#" :onClick #(u/trans-view % {:href href}) :style {:margin-right "1em"}} href])

(defn c-view []
  (let [href (:href (:attrs @g/app-page))
        from (->> @g/app-page :attrs :from)
        to (->> @g/app-page :attrs :to)
        fltr (u/filter-transactions href from to)]
    [:div [:div [:div.form-group [:label "Breadcrumb: "]
                 (let [accs (str/split href #":")
                       cnt (count accs)]
                   [:span (for [i (range cnt)]
                            ^{:key (u/random)}
                            [:span [:a.text-capitalize
                                    {:href "#"
                                     :onClick #(u/trans-view
                                                %
                                                {:href (str/join ":" (take (inc i) accs))})}
                                    (nth accs i)]
                             [:span " >> "]])])]
           [u/c-filter-by u/trans-view href]
           [:table.table.table-striped.table-bordered
            [:tbody [:tr [:th "Date"] [:th "From"] [:th "To"] [:th "Amount"] [:th "Manage"]]
             (for [f fltr]
               (let [from (let [rslt (individual-accs (:trans f) :from href)]
                            (if-not (empty? rslt)
                              rslt
                              (individual-accs (:trans f) :from nil)))
                     to (let [rslt (individual-accs (:trans f) :to href)]
                          (if-not (empty? rslt)
                            rslt
                            (individual-accs (:trans f) :to nil)))]
                 ^{:key (u/random)}
                 [:tr [:td (:date f)]
                  [:td (for [ia from] ^{:key (u/random)} [c-acc ia])]
                  [:td (for [ia to] ^{:key (u/random)} [c-acc ia])]
                  [:td (if (or (= (count from) 1) (= (count to) 1))
                         (if (= (count from) 1)
                           (second (first from))
                           (second (first to)))
                         (:to f))]
                  [:td [:a.glyph {:href "#"} [:span.glyphicon.glyphicon-pencil
                                              {:onClick #(trans-edit % f)}]]
                   [:a.glyph {:href "#"} [:span.glyphicon.glyphicon-remove
                                          {:onClick #(trans-rm % f)}]]]]))]]]
     [:div.row
      [:p]
      [:div.col-sm-6 [:button.btn.btn-default.pull-right {:onClick am/edit} "Edit Account"]]
      [:div.col-sm-6 [:button.btn.btn-default {:onClick ar/rm} "Delete Account"]]]]))
