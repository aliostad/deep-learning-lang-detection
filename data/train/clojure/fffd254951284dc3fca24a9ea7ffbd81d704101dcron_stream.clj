(ns com.joshuagriffith.cron-stream
  (:require [manifold
             [deferred :as d]
             [stream :as s]])
  (:import com.addthis.cronus.CronPattern
           [java.time Duration ZonedDateTime ZoneId]
           [java.util Date TimeZone]))

(defn cron-stream
  "Takes a 5-field cron expression and returns a stream that emits
  Dates according to the supplied schedule. Additionally takes the
  following option keys:

    :timezone - evaluate the cron expression in a given TimeZone.
                Defaults to the local system timezone.

    :buffer - buffer size of the returned stream. Defaults to 0.

  Returns a manifold stream containing Dates. If the stream parks for
  an extended period of time, the next date will be computed based on
  when the stream resumes accepting puts. To prevent missing dates,
  use a non-zero buffer value.

  Note: the initial Date is calculated from the time the stream is
  created."

  [cron-expression & {:keys [timezone buffer]
                      :or {timezone (TimeZone/getDefault)
                           buffer 0}}]
  (let [cron-pattern (CronPattern/build cron-expression)
        stream (s/stream buffer)
        zone-id (.toZoneId timezone)]
    (d/loop []
      (let [t0 (ZonedDateTime/now zone-id)
            t1 (-> (.next cron-pattern t0 false)
                   (.withSecond 0)
                   (.withNano 0))
            delay (.toMillis (Duration/between t0 t1))]
        (d/chain' (d/timeout! (d/deferred) delay false)
                  (fn [_]
                    (s/put! stream (Date/from (.toInstant t1))))
                  (fn [result]
                    (if result
                      (d/recur)
                      (s/close! stream))))))
    stream))
