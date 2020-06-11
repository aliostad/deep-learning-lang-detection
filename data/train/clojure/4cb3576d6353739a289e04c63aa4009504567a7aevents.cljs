(ns coverton.ed.events
  (:require [re-frame.core  :as rf :refer [reg-event-db path trim-v dispatch dispatch-sync reg-event-fx]]
            [coverton.ed.db :refer [default-db]]
            [taoensso.timbre :refer-macros [info]]
            [coverton.ajax.events :as ajax-evt]
            [dommy.core     :as d :refer [sel1]]
            [coverton.util  :refer [merge-db]]))



(def ed-interceptors      [(path [:ed])               trim-v])
(def dimmer-interceptors  [(path [:ed :dimmer])       trim-v])
(def cover-interceptors   [(path [:ed :cover])        trim-v])
(def marks-interceptors   [(path [:ed :cover :cover/marks]) trim-v])



(reg-event-db
 ::initialize
 ed-interceptors
 (fn [db [cover]]
   (let [;;cover (or cover (:cover db))
         _     (info "initializing with " cover)]
     {:cover (merge default-db cover)
      :t (inc (:t db))})))


(reg-event-db
 ::update
 ed-interceptors
 (fn [db [k f & args]]
   (apply update db k f args)))


(reg-event-db
 ::merge
 ed-interceptors
 merge-db)


(reg-event-db
 ::update-cover
 cover-interceptors
 (fn [db [k f & args]]
   (apply update db k f args)))


(reg-event-db
 ::merge-cover
 cover-interceptors
 merge-db)



(reg-event-db
 ::update-mark-pos
 cover-interceptors
 (fn [db [id pos]]
   (let [[w h] (:cover/size db)
         [x y] pos]
     (assoc-in db [:cover/marks id :pos] [(/ x w)
                                          (/ y h)]))))


(reg-event-db
 ::update-mark-font-size
 cover-interceptors
 (fn [db [id fsize]]
   (let [[w h] (:cover/size db)]
     (assoc-in db [:cover/marks id :font-size] (/ fsize h)))))



(reg-event-db
 ::add-mark
 cover-interceptors
 (fn [cover [mark]]
   (let [id   (or (:id mark) (random-uuid))
         mark (merge (:cover/font cover) mark {:id id})
         sid  (str id)]
     (assoc-in cover [:cover/marks sid] mark))))



(reg-event-db
 ::remove-mark
 marks-interceptors
 (fn [marks [id]]
   (dissoc marks id)))
 

(reg-event-db
 ::update-marks
 marks-interceptors
 (fn [db [k f & args]]
   (apply update db k f args)))



(reg-event-db
 ::merge-marks
 marks-interceptors
 merge-db)



(reg-event-db
 ::set-cover-id
 cover-interceptors
 (fn [db [res]]
   (assoc db :cover/id (:cover/id res))))




(defn set-active-mark [id]
  (dispatch [::merge-cover {:active-mark id}]))


(defn add-mark [m]
  (dispatch [::add-mark m]))


(defn remove-mark [id]
  (dispatch [::remove-mark id]))


(defn set-size [size]
  (dispatch [::merge-cover {:cover/size size}]))


(defn set-image-url [url]
  (dispatch [::merge-cover {:cover/image-url url}]))


(defn set-pos [id pos]
  (dispatch [::update-mark-pos id pos]))


(defn set-font-size [id fsize]
  (dispatch [::update-mark-font-size id fsize]))


(defn set-font-family [id family]
  (dispatch [::merge-marks {id {:font-family family}}])
  (dispatch [::merge-cover {:cover/font {:font-family family}}]))



(defn set-color [id color]
  (dispatch [::merge-marks {id {:color color}}])
  (dispatch [::merge-cover {:cover/font {:color color}}]))


(defn set-ref [id ref]
  (dispatch [::merge-marks {id {:ref ref}}]))


(defn set-text [id text]
  (dispatch [::merge-marks {id {:text text}}]))


(defn set-mark-static [id static]
  (dispatch [::merge-marks {id {:static static}}]))


(defn set-dimmer [panel]
  (dispatch [::merge {:dimmer panel}]))


(defn save-mark-offset [x y]
  (dispatch [::merge-cover {:mark-offset  [x y]}]))


(defn set-mark-read-only [id read-only?]
  (dispatch [::merge-marks {id {:read-only? read-only?}}]))


(defn initialize [cover]
  (dispatch-sync [::initialize cover]))


;;editor
(reg-event-fx
 ::save-cover
 (fn [_ [_ cover & props]]
   {:dispatch
    [::ajax-evt/request-auth {:method :post
                              :uri "/save-cover"
                              :params (merge-db cover props)
                              :on-success [::merge-cover]}]}))


(reg-event-fx
 ::get-cover
 (fn [_ [_ id]]
   {:dispatch
    [::ajax-evt/request-auth {:method :post
                              :uri "/get-cover"
                              :params {:id id}
                              :on-success [::initialize]}]}))



(reg-event-fx
 ::upload-file
 (fn [_ [_ data & [args]]]
   (when data
     {:dispatch
      [::ajax-evt/request-auth (-> {:method :post
                                    :uri "/upload-file"
                                    :body data}
                                   (merge args))]})))









#_(reg-event-db
   ::update-mark
   marks-interceptors
   (fn [marks [id ks v]]
     (if (and (get marks id)
              (not= (get-in marks (into [id] ks))
                    v))
       (assoc-in marks (into [id] ks) v)
       marks)))
