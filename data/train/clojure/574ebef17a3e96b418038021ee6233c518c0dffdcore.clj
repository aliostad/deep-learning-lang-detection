(ns learn-selenium.core
  #_(:use [clj-webdriver.taxi])
  (:import [org.openqa.selenium WebDriver Cookie]
           [org.openqa.selenium WebElement]
           [org.openqa.selenium.support.ui ExpectedCondition]
           [org.openqa.selenium.support.ui WebDriverWait]
           (org.openqa.selenium.firefox FirefoxDriver FirefoxProfile)
           (org.openqa.selenium By)
           (org.openqa.selenium Cookie)
           (org.openqa.selenium JavascriptExecutor)
           (org.openqa.selenium.htmlunit HtmlUnitDriver)
           (org.openqa.selenium.firefox.internal ProfilesIni)
           (java.io File)
           (org.openqa.selenium.ie InternetExplorerDriver)
           (org.openqa.selenium.chrome ChromeDriver)))

(declare my-driver)

(defmacro use-firefox
  []
  `(def my-driver (FirefoxDriver.)))

(defmacro use-htmlunit
  []
  `(def my-driver (HtmlUnitDriver.)))

(defmacro use-ie
  []
  (let [_ (System/setProperty
            "webdriver.ie.driver"
            "C:/iedriver/IEDriverServer.exe")]
    `(def my-driver (InternetExplorerDriver.))))

(defmacro use-chrome
  []
  (let [_ (System/setProperty
            "webdriver.chrome.driver"
            "C:/chromedriver/chromedriver.exe")]
    `(def my-driver (ChromeDriver.))))

(defn to
  [url]
  (.get my-driver url))

(defmacro find-element-help
  [type name]
  `(let [element# (~type ~name)]
     (. my-driver (findElement element#))))

(defn find-element
  [type name]
    (case type
    :name (find-element-help By/name name)
    :class-name (find-element-help By/className name)
    :id (find-element-help By/id name)
    :tag-name (find-element-help By/tagName name)
    :link-text (find-element-help By/linkText name)
    :partial-link-text (find-element-help By/partialLinkText name)
    :css (find-element-help By/cssSelector name)
    :xpath (find-element-help By/xpath name)
    nil))

(defmacro find-elements-help
  [type name]
  `(let [element# (~type ~name)]
     (. my-driver (findElements element#))))

(defn find-elements
  [type name]
  (case type
    :name (find-elements-help By/name name)
    :class-name (find-elements-help By/className name)
    :id (find-elements-help By/id name)
    :tag-name (find-elements-help By/tagName name)
    :link-text (find-elements-help By/linkText name)
    :partial-link-text (find-elements-help By/partialLinkText name)
    :css (find-elements-help By/cssSelector name)
    :xpath (find-elements-help By/xpath name)
    nil))

(defn click
  [obj]
  (.click obj))

(defn get-attribute
  [obj attr]
  (.getAttribute obj attr))

(defn get-value
  [obj]
  (get-attribute obj "value"))

(defn submit
  [elt]
  (.submit elt))

(defn get-window-handles
  [driver]
  (.getWindowHandles driver))

(defn switch-to-window
  [window-name]
  (.. my-driver switchTo (window window-name)))

(defn switch-to-frame
  [frame-name]
  (.. my-driver switchTo (frame frame-name)))

(defn find-alert
  []
  (.. my-driver switchTo alert))

(defn navigate
  [direction]
  (case direction
    :forward (.. my-driver navigate forward)
    :back (.. my-driver navigate back)
    nil))

(defn print-cookie
  []
  (doseq [cookie (.. my-driver manage getCookies)]
    (println (format "%s -> %s" (.getName cookie) (.getValue cookie)))))

(defn get-cookies
  []
  (.. my-driver manage getCookies))

(defn delete-cookie-named
  [cookie-name]
  (.. my-driver manage (deleteCookieNamed cookie-name)))

(defn delete-cookie
  [cookie]
  (.. my-driver manage (deleteCookie cookie)))

(defn add-cookie
  [k v]
  (Cookie. k v))

(defn execute-script
  [script]
  (.executeScript ^JavascriptExecutor my-driver script (make-array Object 0)))





(comment
  (use-firefox)
  (use-htmlunit)
  (use-ie)
  (use-chrome)
  (to "http://www.baidu.com/")
  (find-element :name "wd")
  (find-element-help By/name "wd")
  (find-elements :css "#su")
  (find-elements :name "#su")
  (. my-driver (findElement (By/name "wd")))
  (.click (find-element :id "su"))
  (.getAttribute (find-element :id "su") "value")
  (get-value (find-element :id "su"))
  (.submit (find-element :id "kw"))
  (submit (find-element :id "kw"))
  (get-window-handles my-driver)
  (switch-to-window "{a257b72c-2bad-4859-a791-1ee47dafa2ea}")
  (find-alert)
  (navigate :back)
  (navigate :forward)
  (new Cookie "markxueyuan" "y95u98a02n08")
  (.. my-driver manage getCookies)
  (print-cookie)
  (add-cookie "BD_UPN" "133144")
  (get-cookies)
  (delete-cookie-named "BD_UPN")
  (doseq [c (get-cookies)]
    (delete-cookie c))
  (FirefoxProfile.)

  (def x (+ 1 1))
  (def x (+ 2 2))

  (.getProfile (ProfilesIni.) "WebDriver")

  (.executeScript ^JavascriptExecutor my-driver "return navigator.userAgent;" (make-array Object 0))
  (execute-script "return navigator.userAgent;")

  (cast String "a")

  (.getProfile (ProfilesIni.) "default")
  (.readProfiles (ProfilesIni.) (File. "C:/Users/Xue/AppData/Roaming/Mozilla/Firefox/Profiles/lpobb8os.default"))

  (ProfilesIni.)






 )


