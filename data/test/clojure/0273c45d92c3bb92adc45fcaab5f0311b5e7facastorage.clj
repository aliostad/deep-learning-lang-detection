(ns esp-common.storage)

;;;Event Source Dispatch Functions
(defn create-es-dispatch
  [sm data unique-tag]
  (:storage-type sm))

(defn get-es-dispatch
  [sm uuid]
  (:storage-type sm))

(defn lookup-es-dispatch
  [sm unique-tag]
  (:storage-type sm))

(defn update-es-dispatch
  [sm uuid data]
  (:storage-type sm))

(defn delete-es-dispatch
  [sm uuid]
  (:storage-type sm))

;;;Event Dispatch Functions
(defn create-event-dispatch
  [sm src-uuid data]
  (:storage-type sm))

(defn get-event-dispatch
  [sm uuid]
  (:storage-type sm))

(defn update-event-dispatch
  [sm uuid data]
  (:storage-type sm))

(defn delete-event-dispatch
  [sm uuid]
  (:storage-type sm))

;;;Event Source multimethods
(defmulti create-event-source create-es-dispatch :default nil)
(defmulti get-event-source get-es-dispatch :default nil)
(defmulti lookup-event-source lookup-es-dispatch :default nil)
(defmulti update-event-source update-es-dispatch :default nil)
(defmulti delete-event-source delete-es-dispatch :default nil)

;;;Event multimethods
(defmulti create-event create-event-dispatch :default nil)
(defmulti get-event get-event-dispatch :default nil)
(defmulti update-event update-event-dispatch :default nil)
(defmulti delete-event delete-event-dispatch :default nil)

(defmethod create-event-source "test"
  [sm data tag]
  tag)

