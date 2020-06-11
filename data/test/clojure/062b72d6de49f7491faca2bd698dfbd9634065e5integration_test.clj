(ns rill.integration-test
  (:require  [clojure.test :refer [deftest testing is use-fixtures]]
             [rill.event-store :refer [retrieve-events]]
             [rill.event-store.mysql :refer [mysql-event-store]]
             [rill.event-store.mysql.tools :as mysql.tools]
             [rill.event-stream :refer [all-events-stream-id]]
             [rill.wheel :as wheel :refer [defevent defaggregate defcommand ok?]]
             [rill.wheel.bare-repository :refer [bare-repository]]
             [rill.wheel.testing :refer [sub? with-instrument-all]]
             [rill.wheel.wrap-stream-properties :refer [wrap-stream-properties]]))

(alias 'message 'rill.message)

(use-fixtures :once with-instrument-all)

(defaggregate thing
  "an aggregate"
  [thing-id])

(defevent beeped ::thing
  [thing tone]
  (update thing :beeps conj tone))

(defcommand beep ::thing
  [thing tone]
  (beeped thing tone))

(def config
  (when (System/getenv "RILL_MYSQL_DB")
    {:user     (System/getenv "RILL_MYSQL_USER")
     :password (System/getenv "RILL_MYSQL_PASSWORD")
     :hostname (System/getenv "RILL_MYSQL_HOST")
     :port     (if-let [p (System/getenv "RILL_MYSQL_PORT")]
                 (Integer/parseInt p)
                 3306)
     :database (System/getenv "RILL_MYSQL_DB")}))

(defn event-store
  []
  (when config
    (mysql.tools/load-schema! config)
    (-> (mysql.tools/spec config)
        (mysql-event-store)
        (wrap-stream-properties))))

(deftest integration-test
  (when-let [store (event-store)]
    (let [repo (bare-repository store)]
      (is (not (seq (retrieve-events store all-events-stream-id))))
      (is (ok? (beep! repo 1234 "C#")))
      (let [stream-id (sorted-map ::wheel/type ::thing
                                  :thing-id    1234)
            result (beep! repo 1234 "F")]
        (is (ok? result))
        (is (sub? {::wheel/events
                   [{::message/type      ::beeped
                     ::message/number    1
                     :tone               "F"
                     ::message/stream-id stream-id}]}
                  result))
        (is (sub? [{::message/type      ::beeped
                    ::message/number    0
                    :tone               "C#"
                    ::message/stream-id stream-id}
                   {::message/type      ::beeped
                    ::message/number    1
                    :tone               "F"
                    ::message/stream-id {::wheel/type ::thing
                                         :thing-id    1234}}]
                  (retrieve-events store all-events-stream-id)))
        (is (sub? [{::message/type      ::beeped
                    ::message/number    0
                    :tone               "C#"
                    ::message/stream-id stream-id}
                   {::message/type      ::beeped
                    ::message/number    1
                    :tone               "F"
                    ::message/stream-id stream-id}]
                  (retrieve-events store stream-id)))))))

