(ns salty.impl
  (:import [org.openqa.selenium By WebDriver WebElement Cookie]
           org.openqa.selenium.firefox.FirefoxDriver
           [org.openqa.selenium.support.ui ExpectedCondition WebDriverWait]))

(def *driver* nil)

;; Convenience test, just to have something quick to type at the repl
(defn test-with-google []
  (let [driver (FirefoxDriver.)]
    (.get driver "http://www.google.com/")
    (println "Original page title is " (.getTitle driver))
    (let [element (.findElement driver (By/name "q"))]
      (.sendKeys element (into-array ["clojure\n"]))
      (.submit element)
      (-> (WebDriverWait. driver 10)
          (.until (proxy [ExpectedCondition] []
                    (apply [d]
                      (-> (.getTitle d)
                          (.toLowerCase)
                          (.startsWith "clojure"))))))
      (println "Page title after searching is " (.getTitle driver))
      (.quit driver))))

(defn go-to-url
  "Given a valid WebDriver, open the web page at the given
url."
  [driver url]
  (.get driver url))

(defn end
  "Close current WebDriver instance."
  [driver]
  (.quit driver))

(defn add-cookie
  "Set a cookie on same domain as the last page loaded."
  [driver k v]
  (let [cookie (Cookie. k v)]
    (.addCookie (.manage driver) cookie)))

(defn get-cookies
  "Get the current cookies"
  [driver]
  (let [cookies (.getCookies (.manage driver))]
    (into #{} (for [c cookies]
                [(.getName c) (.getValue c)]))))

(defn delete-cookie
  "Delete the cookie with the given name."
  [driver cookie]
  (.deleteCookieNamed (.manage driver) cookie))

(defn delete-all-cookies
  "Delete all cookies associated with the domain of the last page loaded."
  [driver]
  (.deleteAllCookies (.manage driver)))

