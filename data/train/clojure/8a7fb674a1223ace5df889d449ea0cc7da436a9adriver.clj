(ns limo.driver
  (:require [environ.core :refer [env]]
            [clojure.java.io :as io]
            [clojure.test :refer :all]
            [clojure.tools.logging :as log]
            [limo.api :as api :refer [to delete-all-cookies current-url implicit-wait]])
  (:import org.openqa.selenium.remote.RemoteWebDriver
           org.openqa.selenium.remote.CapabilityType
           org.openqa.selenium.remote.DesiredCapabilities
           org.openqa.selenium.logging.LogEntries
           org.openqa.selenium.logging.LogEntry
           org.openqa.selenium.logging.LogType
           org.openqa.selenium.logging.LoggingPreferences
           org.openqa.selenium.WebDriver
           org.openqa.selenium.chrome.ChromeDriver
           org.openqa.selenium.firefox.FirefoxDriver
           org.openqa.selenium.WebDriverException
           org.openqa.selenium.Dimension
           java.util.logging.Level
           java.net.URL
           java.util.Date))

(def normal-report clojure.test/report)

(defn console-logs [driver]
  (map (fn [entry]
         {:timestamp (.getTimestamp entry)
          :level (.getLevel entry)
          :message (.getMessage entry)})
       (.. driver manage logs (get LogType/BROWSER))))

(defn create-screenshot-reporter [reporter-fn]
  (fn [m]
    (when (#{:fail :error} (:type m))
      (let [filename (if (:file m)
                       (str (:file m) "/" "line-" (:line m) "/" (.getTime (Date.)))
                       (str "unknown-files/" (.getTime (Date.))))]
        (log/error "Saved screenshot to:" filename)
        (api/screenshot filename)))
    (reporter-fn m)))

(defn create-console-log-reporter [reporter-fn drivers-fn]
  (fn [m]
    (when (#{:fail :error} (:type m))
      (doseq [driver (drivers-fn)]
        (doseq [entry (console-logs api/*driver*)]
          (log/error "[Console]" entry))))
    (reporter-fn m)))

(defn map->capabilities [^java.util.Map m]
  (if (instance? DesiredCapabilities m)
    m
    (DesiredCapabilities. m)))

(defn logging-capability
  ([desired-capabilities] (logging-capability desired-capabilities Level/ALL))
  ([desired-capabilities level]
   (doto (map->capabilities desired-capabilities)
     (.setCapability CapabilityType/LOGGING_PREFS
                     (doto (LoggingPreferences.)
                       (.enable LogType/BROWSER level))))))

(def capabilities
  {:chrome (DesiredCapabilities/chrome)
   :firefox (DesiredCapabilities/firefox)
   :browser-stack {:samsung-galaxy-s4 (doto (DesiredCapabilities.)
                                        (logging-capability)
                                        (.setCapability "browserName" "android")
                                        (.setCapability "platform" "ANDROID")
                                        (.setCapability "device" "Samsung Galaxy S4")
                                        (.setCapability "browserstack.debug" "true"))}})

(defn create-chrome
  ([] (create-chrome (:chrome capabilities)))
  ([capabilities] (ChromeDriver. capabilities)))

(defn create-firefox
  ([] (create-firefox (:firefox capabilities)))
  ([capabilities] (FirefoxDriver. capabilities)))

(defn create-remote
  ([desired-capabilities] (RemoteWebDriver. desired-capabilities))
  ([url desired-capabilities] (RemoteWebDriver. (io/as-url url) desired-capabilities)))

(defn with-driver* [driver {:keys [quit?]} f]
  (let [old-driver api/*driver*
        result (atom nil)]
    (api/set-driver! driver)
    (try
      (reset! result (f))
      (finally
        (when quit?
          (.quit driver))
        (api/set-driver! old-driver)))
    @result))

(defmacro with-driver [driver options & body]
  {:pre [(map? options)]}
  `(with-driver* ~driver ~options (fn [] ~@body)))

(defn with-fresh-browser* [create-driver-fn f]
  (with-driver* (create-driver-fn) {:quit? true} f))

(defmacro with-fresh-browser [create-driver-fn & body]
  `(with-fresh-browser* ~create-driver-fn (fn [] ~@body)))
