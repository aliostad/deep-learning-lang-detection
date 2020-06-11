(ns timers.lib.marauder
  (:refer-clojure :exclude [conj! replace! reset!])
  (:require [reagent.core :as reagent :refer [atom]]
            [reagent.session :as session]))

;; TODO:
;; - I would like to think about adding some more resource types:
;; --- session: a map that can be (invalidate!)
;; --- page-session: a map that only lives until route change
;; --- map: wonder if this is any good?
;; --- element: just one single element
;; -- THE BENEFIT of doing all this would be to couple the rest of the
;;    code to a PROTOCOL & a VAR, not a path in the atom. And, with clojure,
;;    it would be quite easy to just swap the implementation for something else
;;    like server-storage or something like that.

(defprotocol AtomCollection
  "Manage a collection of items inside an state atom."
  (data [resource] "Get associated resource data.")
  (-bake-new [resource params] "Bake a new item (using provided generator)")
  (get-all [resource] "Get the full collection.")
  (conj! [resource item] "Inserts ITEM in the collection (maybe gives :id).")
  (reset! [resource coll] "Resets the value of the resource to the given COLL.")
  (get-by [resource key value] "Find an item by :key.")
  (find-by [resource key value] "Find all items by :key.")
  (replace! [resource old new] "Switch an item for another.")
  (remove! [resource item] "Removes ITEM from the collection."))

(defn bake-new
  "This fn is here because protocols does not support variadic args."
  [resource & params]
  (-bake-new resource params))

(defprotocol AtomCollectionEditableItem
  "Items can be edited by a virtual cursor."
  (set-current! [resource item] [resource key value] "[Finds +] Copies item into the cursor.")
  (get-current [resource] "Retrieves the value in the cursor.")
  (save-current! [resource] "Updates the original item in the collection.")
  (cleanup-current! [resource] "Cleans up the cursor.")
  (-update-current! [resource transform params] "Applies TRANSFORM to the cursor."))

(defn update-current!
  "This fn is here because protocols does not support variadic args."
  [resource transform & params]
  (-update-current! resource transform params))

(defonce uid
  (let [i (atom (.now js/Date))]
    #(swap! i inc)))

(defn get-id [] {:id (uid)})

(def lib-defaults
  {:id-key :id
   :generator hash-map
   :path []
   :atom nil
   :current-atom nil})

;; -------------------------
;; RESOURCE TYPE: Collection

(defn collection
  ([data] (collection data {}))
  ([data defaults]
   (let [{:keys [path atom current-atom generator id-key]
          :as data} (merge lib-defaults defaults data)]
     (reify
       AtomCollection
       (data [_] data)
       (get-all [_] (get-in @atom path []))
       (get-by [this key value]
         (first (find-by this key value)))
       (-bake-new [_ params] (apply generator params))
       (conj! [_ item]
         (swap! atom update-in path
                #(conj (or % []) (if (id-key item)
                                   item
                                   (merge item (get-id))))))
       (reset! [_ coll]
         (swap! atom assoc-in path coll))
       (find-by [this key value]
         (filter #(= (key %) value)
                 (get-all this)))
       (replace! [_ old new]
         (swap! atom update-in path
                #(replace {old new} (or % []))))
       (remove! [_ item]
         (swap! atom update-in path
                (let [trans (remove #(= item %))]
                  #(into [] trans (or % [])))))
       AtomCollectionEditableItem
       (set-current! [_ item]
         (swap! current-atom assoc-in path item))
       (set-current! [this key value]
         (set-current! this (find-by this key value)))
       (get-current [_]
         (get-in @current-atom path nil))
       (save-current! [this]
         (let [current (get-current this)
               current-id (get current id-key :new)
               item (get-by this id-key current-id)]
           (if (= current-id :new)
             (conj! this (merge current (get-id)))
             (replace! this item current))
           (println @atom @current-atom current-id)))
       (cleanup-current! [_]
         (swap! current-atom update-in (butlast path)
                #(dissoc % (last path))))
       (-update-current! [_ transform params]
         (apply swap! current-atom update-in path transform params))))))
