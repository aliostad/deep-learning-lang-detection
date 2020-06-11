(ns quibbler.core
  (:import org.openqa.selenium.Dimension)
  (:require
   [clj-webdriver.taxi :as taxi]
   [org.httpkit.server :as hk]
   [cemerick.url :as c]))

(defonce server (atom nil))
(def default-dim (Dimension. 1028 720))
(defonce port (atom (+ (rand-int 1000) 8000)))
(defonce options (atom {:server {:port @port}
                        :webdriver {:default-window-size default-dim
                                    :url (str "http://localhost:" @port)
                                    :browser :phantomjs
                                    :implicit-wait 10}}))

(defonce handler (atom nil))
(defonce driver (atom nil))

(defn reset-handler!
  "Reset the handler running in httpkit"
  [h]
  (reset! handler h))

(defn reset-options!
  [opts]
  "Reset the options used to initialize the server and webdriver"
  (reset! options opts))

(defn restart-server!
  "Restart the httpkit server"
  []
  (@server)
  (reset! server nil))

(def handler-nil-msg
  (str `handler "is nil, please set with " `reset-handler!))

(defn start-server!
  "Start the httpkit server"
  []
  (if (nil? @handler)
    (throw (IllegalArgumentException. handler-nil-msg))
    (reset! server (hk/run-server @handler (@options :server)))))

(defn start-driver!
  "Start the selenium webdriver"
  []
  (when-not @driver
    (reset! driver (taxi/set-driver!
                    {:browser (get-in @options [:webdriver :browser])}
                    (get-in @options [:webdriver :url])))
    (->
     @driver
     :webdriver
     .manage
     .window
     (.setSize (get-in @options [:webdriver :default-window-size])))

    (taxi/implicit-wait (get-in @options [:webdriver :implicit-wait]))))

(defn with-server
  "A fixture that starts an httpkit server with the set handler
  and starts the selenium driver pointing to the httpkit server"
  [t]
  (when-not @server
    (start-server!))
  (when-not @driver
    (start-driver!))
  (t))
