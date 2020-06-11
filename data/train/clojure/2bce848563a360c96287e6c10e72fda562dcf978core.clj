(ns clj-appium.core
  (:import (java.util UUID)
           (java.net URL)
           (java.util.concurrent TimeUnit)
           (io.appium.java_client.ios IOSDriver)
           (io.appium.java_client.android AndroidDriver)
           (io.appium.java_client AppiumDriver MobileElement)
           (org.openqa.selenium.remote DesiredCapabilities)
           (org.openqa.selenium Capabilities By ScreenOrientation OutputType)
           (org.openqa.selenium.support.ui WebDriverWait ExpectedConditions)))


(defn uuid
  []
  (str (UUID/randomUUID)))


(defn create-desired-caps
  [& {:as m}]
  (let [desired-caps-map (assoc m :testobject_testuuid (uuid))
        desired-cap-obj  (DesiredCapabilities.)]
    (loop [d desired-caps-map]
      (if-let [[key val] (first d)]
        (do
          (.setCapability desired-cap-obj (subs (str key) 1) val)
          (recur (rest d)))
        desired-cap-obj))))


(defn create-driver
  [type url caps]
  (case type
    :ios (IOSDriver. (URL. url) caps)
    :android (AndroidDriver. (URL. url) caps)
    (throw (IllegalArgumentException. "There is no such a platform!"))))


(defn get-cap-val
  [driver k]
  (let [capabilities (->> driver
                          (cast AppiumDriver)
                          .getCapabilities
                          (cast Capabilities))]
    (.getCapability capabilities k)))


(defn quit-driver
  [driver]
  (some-> driver (. quit)))


(defn rotate
  [driver r]
  (case r
    :landscape (. driver (rotate ScreenOrientation/LANDSCAPE))
    :portrait (. driver (rotate ScreenOrientation/PORTRAIT))
    (throw (IllegalArgumentException. "There is no such a rotation!"))))


(defn implicitly-wait
  ([driver]
   (implicitly-wait driver 15))
  ([driver seconds]
   (.. driver manage timeouts (implicitlyWait seconds TimeUnit/SECONDS))))


(defmulti find-element (fn [t driver] (:by t)))


(defmethod find-element :id
  [{:keys [val]} driver]
  (cast MobileElement (.. driver (findElement (By/id val)))))


(defmethod find-element :xpath
  [{:keys [val]} driver]
  (cast MobileElement (.. driver (findElement (By/xpath val)))))


(defmethod find-element :default
  [_ _]
  (throw (IllegalArgumentException. "Please implement default!")))


(defn get-url
  [driver url]
  (.get driver url))


(defn- key->output-type
  [k]
  (case k
    :file OutputType/FILE
    :base64 OutputType/BASE64
    :bytes OutputType/BYTES
    (throw (IllegalArgumentException. "There is no such a type!"))))


(defn get-screenshot-as
  [driver output-type]
  (.getScreenshotAs driver (key->output-type output-type)))


(defn click
  [coll]
  (doseq [button coll]
    (.click button)))


(defn wait-text-to-be-present
  [driver seconds result-field exp-val]
  (.until (WebDriverWait. driver seconds) (ExpectedConditions/textToBePresentInElement result-field exp-val)))