(ns components.metrics.middleware
  (:require
    [metrics.ring.instrument :as ring-metrics]
    [components.metrics.protocol :as metrics]
    [components.metrics.service :as service]))

(defn- default-normalize-uri [uri]
  "Clears uri from parameters and perform some weed out for urls like
  sales/find?customer=12&agent=334"
  (re-find #"[^\?]*" uri))

(defn url-middleware
  "Instrument each url call adding a counter and a clock.  normalize-uri-fn
  takes a string representing an url and returns a string, this function is
  used for normalizing uris, in case that you have uris involving some sort of
  identifier that you do not want to count as a different instrument."
  ([handler system-monitor application-name]
   (url-middleware handler system-monitor application-name default-normalize-uri))
  ([handler system-monitor application-name normalize-uri-fn]
   (fn [request]
     (if-let [uri (normalize-uri-fn (:uri request))]
       (do (when-not (metrics/timer? system-monitor uri)
             (metrics/add-timer! system-monitor uri [application-name "web-times" uri]))
           (when-not (metrics/meter? system-monitor uri)
             (metrics/add-meter! system-monitor uri [application-name "web-meter" uri]))
           (metrics/mark-meter! system-monitor uri)
           (metrics/clock-this! system-monitor uri
                                (binding [service/*current-monitor* system-monitor]
                                  (handler request))))
       (handler request)))))

(defn ring-middleware [handler system-monitor]
  (ring-metrics/instrument handler (metrics/get-registry system-monitor)))

