(ns mex.api
  (:require-macros [mex.macros.core :refer [-<>]])
  (:require [clojure.walk :as walk]
            [mex.controller.download :as download]
            [mex.re-frame :as rf]))

(defn ^:export modal [params]
  (if (string? params)
    (case params
      "close" (rf/dispatch-sync [:modal/close])
      "open" (rf/dispatch-sync [:modal/open {}])
      "loading" (rf/dispatch-sync [:modal/loading])
      nil)
    (let [params (-<> params
                      (js->clj <> :keywordize-keys true)
                      (walk/postwalk-replace {:open :open?
                                              :overlay_close :overlay-close?
                                              :on_click :on-click}
                                             <>))]
      (rf/dispatch-sync [:modal/open params]))))

(defn ^:export register-download-validator [func]
  (rf/dispatch-sync [:download/add-validator func]))

(def ^:export clj-to-js clj->js)

(defn ^:export state [path]
  (let [path (mapv #(if (string? %) (keyword %) %) path)]
    (rf/dispatch [:app/print-db path])))

(defn ^:export dispatch [event & args]
  (rf/dispatch (into [(keyword event)] (or (js->clj args) []))))