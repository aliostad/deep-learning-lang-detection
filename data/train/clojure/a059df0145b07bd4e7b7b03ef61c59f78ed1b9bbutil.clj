;; Copyright (c) 2014 The Finnish National Board of Education - Opetushallitus
;;
;; This program is free software:  Licensed under the EUPL, Version 1.1 or - as
;; soon as they will be approved by the European Commission - subsequent versions
;; of the EUPL (the "Licence");
;;
;; You may not use this work except in compliance with the Licence.
;; You may obtain a copy of the Licence at: http://www.osor.eu/eupl/
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; European Union Public Licence for more details.

(ns osaan-e2e.util
  (:require [clj-time.format]
            [clj-time.local]
            [clj-webdriver.driver :refer [init-driver]]
            [clj-webdriver.taxi :as w])
  (:import java.util.concurrent.TimeUnit
           (com.paulhammant.ngwebdriver ByAngular
                                        WaitForAngularRequestsToFinish)
           (org.openqa.selenium NoAlertPresentException
                                TimeoutException
                                UnexpectedAlertBehaviour
                                UnhandledAlertException)
           org.openqa.selenium.firefox.FirefoxDriver
           (org.openqa.selenium.remote CapabilityType
                                       DesiredCapabilities
                                       RemoteWebDriver)))

(def ^:dynamic *ng*)

(defn luo-webdriver! []
  (let [remote_url (System/getenv "REMOTE_URL")
        browser-name (or (System/getenv "BROWSER_NAME") "internet explorer")
        capabilities (doto
                       (if remote_url
                         (doto (DesiredCapabilities.) (.setBrowserName browser-name))
                         (DesiredCapabilities.))
                       (.setCapability
                         CapabilityType/UNEXPECTED_ALERT_BEHAVIOUR
                         UnexpectedAlertBehaviour/IGNORE)
                       (.setCapability
                         CapabilityType/ACCEPT_SSL_CERTS
                         true))
        driver (init-driver
                 (if remote_url
                    (RemoteWebDriver. (java.net.URL. remote_url) capabilities)
                    (FirefoxDriver. capabilities)))]
    (w/set-driver! driver)
    (w/implicit-wait 3000)
    (-> driver :webdriver .manage .timeouts (.setScriptTimeout 30 TimeUnit/SECONDS))))

(defn ^:private luo-aikaleima-tiedostonimea-varten
  []
  (clj-time.format/unparse
    (.withZone (clj-time.format/formatter "yyyyMMdd'T'HHmmssSSS") (clj-time.core/default-time-zone))
    (clj-time.local/local-now)))

(defn ^:private ota-kuva-tiedostoon
  []
  (w/take-screenshot w/*driver* :file (str "screenshot-" (luo-aikaleima-tiedostonimea-varten) ".png")))

(defn ^:private aja-ja-ota-kuva-epaonnistumisesta [f]
  (try
    (f)
    (catch Throwable e
      (ota-kuva-tiedostoon)
      (throw e))))

(defn ^:private aja-testit [f]
  (aja-ja-ota-kuva-epaonnistumisesta f))

(defn with-webdriver* [f]
  (if (bound? #'*ng*)
    (aja-testit f)
    (do
      (luo-webdriver!)
      (try
        (binding [*ng* (ByAngular. (:webdriver w/*driver*))]
          (aja-testit f))
        (finally
          (w/quit))))))

(defmacro with-webdriver [& body]
  `(with-webdriver* (fn [] ~@body)))

(defmacro odota-kunnes [& body]
  `(w/wait-until (fn [] ~@body) 20000))

(defn ^:private odota-sivun-latautumista []
  (let [ready-state (atom nil)]
    (try
      (odota-kunnes (= (reset! ready-state
                               (w/execute-script "return document.readyState"))
                       "complete"))
      (catch TimeoutException e
        (println (str "document.readyState == '" @ready-state "'"))
        (throw e)))))

(defn odota-angular-pyyntoa []
  (WaitForAngularRequestsToFinish/waitForAngularRequestsToFinish
    (:webdriver w/*driver*)))

(defn avaa-url
  [url]
    (w/to url)
    (try
      (odota-kunnes (= (w/current-url) url))
      (catch TimeoutException e
        (println (str "Odotettiin selaimen siirtyvän URLiin '" url "'"
                      ", mutta sen URL oli '" (w/current-url) "'"))
        (throw e)))
    (odota-sivun-latautumista))
