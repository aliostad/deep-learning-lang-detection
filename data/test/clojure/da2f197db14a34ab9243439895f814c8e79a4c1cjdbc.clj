(ns sql-crud.jdbc
  "JDBC integration code used to manage java.sql"
  (:import [java.sql DriverManager Connection Statement PreparedStatement ResultSet SQLException]))

;; TODO: Integrate this information, seems to use .setX functions and `?` in the
;; query string in order to pass values, which might be more appropriate than how
;; I am generating them for the context right now
;; http://stackoverflow.com/questions/89350/is-it-possible-to-store-and-retrieve-a-boolean-value-in-a-varchar-field-using-ja

(defn- execute-update
  ^Integer
  [statement sql]
  (.executeUpdate statement sql))

(defn- execute-query
  ^ResultSet
  [statement sql cursor-to-result]
  (let [result-set (.executeQuery statement sql)]
    (loop [cur (.next result-set) acc []]
      (if cur
        (do
          (let [result (cursor-to-result result-set)
                results (conj acc result)]
            (recur (.next result-set) results)))
        acc))))

(defn- execute-query-map
  [statement {:keys [type sql cursor-to-result] :as sql-query-map}]
  (cond (contains? #{:create :insert :update :delete :drop} type)
        (assoc sql-query-map :result (execute-update statement sql))

        (contains? #{:select} type)
        (assoc sql-query-map :result (execute-query statement sql cursor-to-result))))

;; TODO: Handle possible failures more rigorously
;; TODO: Use Prepared statements for passing `?` and using `setX` methods to handle
;; putting the info into the database
(defn db-execute
  ""
  [{:keys [connection-string sql-query-maps driver-string]
    :or {connection-string "jdbc:sqlite:test.db"
         sql-query-maps []
         driver-string "org.sqlite.JDBC"}}]
  ; This loads the sqlite driver
  (java.lang.Class/forName driver-string)
  (let [c (DriverManager/getConnection connection-string)
        stmt (.createStatement c)
        args (map (fn [st qm] [st qm]) (repeat stmt) sql-query-maps)]
    (.setAutoCommit c false)
    (try
      (let [results (doall (map #(apply execute-query-map %) args))]
        (.commit c)
        results)
      (catch SQLException e
        (when (not (nil? c))
          (try
            (.rollback c)
            (throw e))))
      (finally
        (when (not (nil? stmt))
          (.close stmt))
        (.close c)))))

