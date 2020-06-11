(ns elm.ui.common
  (:import 
    org.openqa.selenium.Dimension
    org.openqa.selenium.remote.DesiredCapabilities
    org.openqa.selenium.phantomjs.PhantomJSDriver
    org.openqa.selenium.OutputType)
  (:use 
     clj-webdriver.taxi
     clj-webdriver.driver))

(defn take-snapshot []
  (.getScreenshotAs (:webdriver clj-webdriver.taxi/*driver*) OutputType/FILE))

(defn login []
  (to "https://localhost:8443/")
  (wait-until #(exists? "input#username"))
  (input-text "#username" "admin")
  (-> "#password" (input-text "changeme") submit)
  (wait-until #(exists? "a.SystemsMenu")))

(System/setProperty "webdriver.chrome.driver" "/usr/bin/chromedriver")

(System/setProperty "phantomjs.binary.path" "/usr/bin/phantomjs")

(defn phantom-driver []
  (let [args (into-array String ["--ignore-ssl-errors=true" "--webdriver-loglevel=ERROR"])]
  (PhantomJSDriver. 
    (doto (DesiredCapabilities.)
       (.setCapability "phantomjs.page.settings.userAgent", "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:27.0) Gecko/20100101 Firefox/27.0")
       (.setCapability "phantomjs.page.customHeaders.Accept-Language" "en-US")
       (.setCapability "phantomjs.page.customHeaders.Connection" "keep-alive")
       (.setCapability "phantomjs.cli.args" args)))))

(defn set-view-size [driver]
  (.setSize (.window (.manage driver)) (Dimension. 1920 1080)) driver)

(defn create-phantom []
  (init-driver {:webdriver (set-view-size (phantom-driver))}))

(def browser {:browser :phantomjs})

(defmacro with-driver-
  [driver & body]
  `(binding [clj-webdriver.taxi/*driver* ~driver]
     (try ~@body
       (catch Exception e# 
         (timbre/error e#)
         (take-snapshot))
       (finally (quit)))))

(defn uuid [] (first (.split (str (java.util.UUID/randomUUID)) "-")))
 
(defn click-next [] (click "button#Next"))
