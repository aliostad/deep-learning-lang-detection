(ns views.reagent.client.core
  (:require
    [reagent.core :as r]
    [views.reagent.utils :refer [relevant-event?]]))

(defonce ^:private first-connection? (atom true))

(defonce view-data (r/atom {}))

(defonce send-fn (atom nil))

(defn send-data!
  [data]
  (if-not @send-fn
    (throw (js/Error. "send-fn not set"))
    (@send-fn data)))

(defn ->view-sig-cursor
  "Creates and returns a Reagent cursor that can be used to access the data
   for the view corresponding with the view-sig.

   Generally, for code in a component's render function, you should use
   views.reagent.client.component/view-cursor instead of using this
   function directly. Use of this function instead requires you to manage
   view subscription/unsubscription yourself.

   NOTE: The data returned by this function is intended to be used in a
         read-only manner. Using this cursor to change the data will *not*
         propagate the changes to the server."
  [view-sig]
  (r/cursor view-data [view-sig :data]))

(defn- handle-view-refresh
  [[view-sig data]]
  (swap! view-data
         (fn [view-data]
           (if (contains? view-data view-sig)
             (update-in view-data [view-sig] assoc
                        :loading? false
                        :data data)
             view-data))))

(defn subscribed?
  "Returns true if we are currently subscribed to the specified view."
  [view-sig]
  (boolean (get view-data view-sig)))

(defn- update-for-unsubscription!
  [view-sig]
  (swap! view-data
         (fn [vd]
           (let [{:keys [refcount data]} (get vd view-sig)]
             (if (= 1 refcount)
               (dissoc vd view-sig)
               (update-in vd [view-sig :refcount] dec))))))

(defn unsubscribe!
  "Unsubscribes from all of the specified view(s). No further updates from the
   server will be received for these views and the latest data received from
   the server is cleared."
  [view-sigs]
  (doseq [view-sig view-sigs]
    (let [vd (update-for-unsubscription! view-sig)]
      (if-not (get vd view-sig)
        (send-data! [:views/unsubscribe view-sig])))))

(defn- update-for-subscription!
  [view-sig]
  (swap! view-data
         (fn [vd]
           (let [{:keys [refcount data]} (get vd view-sig)]
             ; for the first subscription, add an initial entry for this view
             ; with empty data. the server will send us initial data as
             ; a standard view refresh when the subscription is processed
             (if-not refcount
               (assoc vd view-sig {:refcount 1
                                   :loading? true
                                   :data     nil})
               (update-in vd [view-sig :refcount] inc))))))

(defn subscribe!
  "Subscribes to the specified view(s). Updates to the data on the server will
   be automatically pushed out. Use a 'view cursor' to read this data and
   render it in any component(s)."
  [view-sigs]
  (doseq [view-sig view-sigs]
    (let [vd (update-for-subscription! view-sig)]
      ; on the first subscription we need to tell the server we are subscribing
      ; to this view
      (if (= 1 (get-in vd [view-sig :refcount]))
        (send-data! [:views/subscribe view-sig])))))

(defn update-subscriptions!
  "Unsubscribes from old-view-sigs and then subscribes to new-view-sigs. This
   function should be used when one or more arguments to views that are currently
   subscribed to have changed."
  [new-view-sigs old-view-sigs]
  (unsubscribe! old-view-sigs)
  (subscribe! new-view-sigs))

(defn on-open!
  []
  (if @first-connection?
    (reset! first-connection? false)
    (if (seq @view-data)
      ; if there are existing subscriptions right when the messaging system connects
      ; to the server, then it means that this was probably a reconnection.
      ; the server removes subscriptions when a client disconnects, so we should
      ; send subscriptions for all of the views that were left in view-data
      (doseq [view-sig (keys @view-data)]
        (send-data! [:views/subscribe view-sig])))))

(defn on-receive!
  [data]
  (when (relevant-event? data)
    (let [[event & args] data]
      (condp = event
        :views/refresh (handle-view-refresh (first args))
        (js/console.log "unrecognized event" event "-- full received data:" data))
      ; indicating that we handled the received event
      true)))
