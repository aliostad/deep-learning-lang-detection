(ns io.aviso.taxi-toolkit.fixtures
  "General clojure.test purpose fixtures for running selenium/webdriver tests.
  Please note that this namespace relies on webdriver-remote library."
  (:require [clj-webdriver.taxi :as taxi]
            [clj-webdriver.remote.server :as webdriver-remote])
  (:import (java.util.concurrent TimeUnit)))

(defn new-webdriver-remote-session
"Set up a webdriver remote session for a port/host specified as:
- system properties - named selenium.port/selenium.host or
- environment variables - named SELENIUM_PORT/SELENIUM_HOST

If SELENIUM_HOST is used, and SAUCE_USER_NAME environment variable is set, set the host
will include the authentication string in a following format: username:password@host.

This follows the convention from: https://github.com/saucelabs/bamboo_sauce/wiki#referencing-environment-variables to some extent.

The default settings are localhost/4444."
  [browser-spec]
  (second
    (webdriver-remote/new-remote-session
     {:port     (Integer/parseInt (or
                                    (System/getProperty "selenium.port")
                                    (System/getenv "SELENIUM_PORT")
                                    "4444"))
      :existing true
      :host     (or
                  (System/getProperty "selenium.host")
                  (when-let [host (System/getenv "SELENIUM_HOST")]
                    (if (System/getenv "SAUCE_USER_NAME")
                      (str (System/getenv "SAUCE_USER_NAME") ":"
                           (System/getenv "SAUCE_API_KEY") "@"
                           host)
                      host))
                  "localhost")}
     browser-spec)))

(defn setup-webdriver-remote-session!
"Configure webdriver remote session, setting the timeout and resizing the browser window."
  [a-driver timeout-ms window-size]
  (.setScriptTimeout (.. (:webdriver a-driver) manage timeouts) timeout-ms TimeUnit/MILLISECONDS) ;meh meh meh
  (.pageLoadTimeout (.. (:webdriver a-driver) manage timeouts) timeout-ms TimeUnit/MILLISECONDS) ;meh meh meh
  (taxi/implicit-wait 200)                            ;meh
  (taxi/window-resize window-size))

(defn webdriver-remote-fixture
"Takes options map as first argument, which can have the following entries:

  - timeout-ms - defaults to 15000
  - window-size - defaults to {:width 1680 :height 1050}

Other arguments are browser specs, and for each of them, the driver session is created
using new-webdriver-remote-session, set up with setup-webdriver-remote-session!.

Next, the fixture function is invoked as usual.

Finally, quit function is invoked on the webdriver session to close it."
  [{:keys [timeout-ms window-size] :or {timeout-ms 15000 window-size {:width 1680 :height 1050}}}
   & browser-specs]
  (fn [f]
    (doseq [browser-spec browser-specs]
      (let [a-driver (new-webdriver-remote-session browser-spec)]
        (try
          (taxi/set-driver! a-driver)
          (setup-webdriver-remote-session! a-driver timeout-ms window-size)
          (f)
          (finally (taxi/quit)))))))

(defn jvm-timeout-fixture
"General purpose fixture, in case Selenium tests would hang (it happens).

Takes one argument:
- timeout-seconds - timeout in seconds after which the JVM should be stopped if the test is still running."
  [timeout-seconds]
  (fn [f]
    (let [finished? (atom false)]
      (doto (Thread. (fn []
                       (Thread/sleep (* timeout-seconds 1000))
                       (when-not @finished?
                         (println "Timeout after " timeout-seconds "seconds.")
                         (System/exit 99))))
        (.setDaemon true)
        (.start))
      (try
        (f)
        (finally
          (reset! finished? true))))))