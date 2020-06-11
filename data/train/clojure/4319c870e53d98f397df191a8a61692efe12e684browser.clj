(ns caius.browser
  (:import [org.openqa.selenium.remote RemoteWebDriver DesiredCapabilities]
           [java.net URL]
           [java.util.concurrent TimeUnit])
  (:require [environ.core :refer [env]]))

(def selenium-hostname (or (env :selenium-hostname) "selenium-chrome"))
(def selenium-port (or (env :selenium-port) 4444))

(defn create-webdriver
  ([] (create-webdriver selenium-port))
  ([port]
   (RemoteWebDriver.
    (URL. (str "http://" selenium-hostname ":" port "/wd/hub"))
    (DesiredCapabilities/chrome))))

(defn get-dom
  ([url] (get-dom url (create-webdriver)))
  ([url webdriver]
   (do
     (.. webdriver (manage) (timeouts) (pageLoadTimeout 10 TimeUnit/SECONDS))
     (.get webdriver url)
     (.executeScript webdriver "return document.documentElement.outerHTML" (object-array 0)))))
