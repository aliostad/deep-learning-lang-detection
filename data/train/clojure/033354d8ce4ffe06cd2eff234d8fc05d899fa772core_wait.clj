(ns etuk.core-wait
  (:require [webica.core :as w])
  (:require [webica
             [web-driver :as driver]
             [by :as by]
             [keys :as wkeys]
             [remote-web-driver :as browser]
             [web-driver :as driver]
             [web-driver-wait :as wait]
             [web-element :as element]]
            [clojure.string :as string]
            [clojure.edn :as edn]
            [me.raynes.fs :as fs])
  (:import [java.util.concurrent.TimeUnit]
           [org.openqa.selenium
            WebDriver]
           [org.openqa.selenium.support.ui
            ExpectedCondition
            Select
            WebDriverWait])
  (:gen-class))

(def ^:private wait-driver (atom nil))

(defn ^:private init-webdriver-wait
  "Create the WebDriverWait from existing WebDriver object."
  ([driver]
   (init-webdriver-wait driver 15))
  ([driver max-timeouts-in-secs]
   ;; First always maximize window
   (-> driver
       .manage
       .window
       .maximize)

   ;; Then we manage the implicit timeouts
   (.implicitlyWait
    (-> driver
        .manage
        .timeouts)
    max-timeouts-in-secs java.util.concurrent.TimeUnit/SECONDS)

   (let [wait-instance (org.openqa.selenium.support.ui.WebDriverWait. driver max-timeouts-in-secs)]
     wait-instance)))

(defn get-instance
  "Return existing current instance of WebDriverWait object or create one if none exists."
  []
  (when-not @wait-driver
    (reset! wait-driver (init-webdriver-wait (driver/get-instance))))
  @wait-driver)
