(ns pg-types.read-column
  (:require
    [clojure.java.jdbc :as jdbc]
    [clojure.tools.logging :as logging]
    [pg-types.misc :as misc]
    ))

;(ns-unmap *ns* 'convert-column)

(defn- dispatch-convert-column [type-name-kw value _ _]
  [type-name-kw (type value)])

(defmulti convert-column dispatch-convert-column)

(defmethod convert-column :default
  [type-name-kw value rsmeta idx]
  value)

(defn dispatch-to-convert-column [val rsmeta idx]
  (logging/debug 'dispatch-to-convert-column [val rsmeta idx])
  (let [type-name-kw (-> (.getColumnTypeName rsmeta idx)
                         misc/dispatch-type-name-kw)
        _ (logging/debug "calling convert-column with: " [type-name-kw val])
        converted (convert-column type-name-kw val rsmeta idx)]
    (logging/debug "converted-column: " converted)
    converted))

(extend-protocol jdbc/IResultSetReadColumn
  Object
  (result-set-read-column [val rsmeta idx]
    (dispatch-to-convert-column val rsmeta idx)))

