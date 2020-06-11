(ns learn-enlive.models.selenium
  #_(:use [clj-webdriver.taxi])
  (:import [org.openqa.selenium WebDriver Cookie OutputType TakesScreenshot]
           [org.openqa.selenium WebElement]
           [org.openqa.selenium.support.ui ExpectedCondition ExpectedConditions]
           [org.openqa.selenium.support.ui WebDriverWait]
           (org.openqa.selenium.firefox FirefoxDriver FirefoxProfile)
           (org.openqa.selenium By)
           (org.openqa.selenium Cookie)
           (org.openqa.selenium JavascriptExecutor)
           (org.openqa.selenium.htmlunit HtmlUnitDriver)
           (org.openqa.selenium.firefox.internal ProfilesIni)
           (java.io File)
           (org.openqa.selenium.ie InternetExplorerDriver)
           (org.openqa.selenium.chrome ChromeDriver)
           (org.openqa.selenium.remote Augmenter)))

(def ^:dynamic my-driver nil)

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
            "resources/driver/IEDriverServer.exe")]
    `(def my-driver (InternetExplorerDriver.))))

(defmacro use-chrome
  []
  (let [_ (System/setProperty
            "webdriver.chrome.driver"
            "resources/driver/chromedriver.exe")]
    `(def my-driver (ChromeDriver.))))

(defn firefox
  []
  (FirefoxDriver.))

(defn htmlunit
  []
  (HtmlUnitDriver.))

(defn ie
  []
  (let [_ (System/setProperty
            "webdriver.ie.driver"
            "C:/iedriver/IEDriverServer.exe")]
    (InternetExplorerDriver.)))

(defn chrome
  []
  (let [_ (System/setProperty
            "webdriver.chrome.driver"
            "C:/chromedriver/chromedriver.exe")]
    (ChromeDriver.)))

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

(defn input
  [element & strings]
  (.sendKeys element (into-array strings)))

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
  [^String script]
  (.executeScript ^JavascriptExecutor my-driver script (make-array Object 0)))

(defmacro build-element
  [type name]
  `(~type ~name))

(defmacro wait-until
  [time-out type name condition]
  `(when-let [elt# (case ~type
                     :name (By/name ~name)
                     :class-name (By/className ~name)
                     :id (By/id ~name)
                     :tag-name (By/tagName ~name)
                     :link-text (By/linkText ~name)
                     :partial-link-text (By/partialLinkText ~name)
                     :css (By/cssSelector ~name)
                     :xpath (By/xpath ~name)
                     nil)]
     (.until
       (WebDriverWait. my-driver ~time-out)
       (~condition elt#))))

(defn wait-until-find
  [time-out type name]
  (wait-until time-out type name ExpectedConditions/presenceOfElementLocated))


(defn wait-until-clickable
  [time-out type name]
  (wait-until time-out type name ExpectedConditions/elementToBeClickable))

(defn take-screenshot
  []
  (let [augment-driver ^TakesScreenshot (.augment (Augmenter.) my-driver)]
    (.getScreenshotAs augment-driver OutputType/FILE)))





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

  (macroexpand-1 '(wait-until 10 :id "su" ExpectedConditions/presenceOfElementLocated))

  (wait-until-find 10 :id "s")

  (wait-until-clickable 10 :id "cp")

  (take-screenshot)

  (.getScreenshotAs my-driver OutputType/FILE)

  (defn test-pre
    [x]
    {:pre [(pos? x)]}
    (Math/log x))

  (test-pre -2)
  (.sendKeys (find-element :id "kw")  (into-array (list "hello" "haha")))

  (input (find-element :id "kw") "hello ")

  (doto (find-element :name "email")
    (input "我操"))

  (doto (find-element :name "password")
    (input "wocao")
    submit)

  (click (find-element :class-name "simple-btn"))


  (to "http://www.sohu.com")

  (click (find-element :css "input.simple-btn:nth-child(3)"))

  (to "https://www.u51.com/")

  (click (find-element :css ".navMenu-money"))

  (doto (find-element :name "user_name_input")
    (input "markxueyuan"))

  (doto (find-element :name "user_pwd_input")
    (input "y95u98a02n08"))

  (click (find-element :css  "a.login-btn:nth-child(4)"))

  (get-cookies)

  (map bean (get-cookies))

  )

