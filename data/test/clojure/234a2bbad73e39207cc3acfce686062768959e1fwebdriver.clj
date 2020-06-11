(ns #^{:author "Miki Tebeka <miki@saucelabs.com>"
       :doc "WebDriver support for Clojure" }
  webdriver
  (:refer-clojure :exclude [get])
  (:import [org.openqa.selenium By WebDriver WebElement Speed Cookie
                                NoSuchElementException]
           [org.openqa.selenium.firefox FirefoxDriver]
           [org.openqa.selenium.ie InternetExplorerDriver]
           [org.openqa.selenium.chrome ChromeDriver]
           [org.openqa.selenium.htmlunit HtmlUnitDriver]
           [java.util Date]
           [java.io File]))

(def *drivers* {
      :firefox FirefoxDriver
      :ie InternetExplorerDriver 
      :chrome ChromeDriver
      :htmlunit HtmlUnitDriver })
               
(defn new-driver
  "create new driver"
  [browser]
  (.newInstance (*drivers* browser)))

(defn get
  [driver url]
  (.get driver url))

(defn current-url
  [driver]
  (.getCurrentUrl driver))

(defn title
  [driver]
  (.getTitle driver))

(defn page-source
  [driver]
  (.getPageSource driver))

(defn close
  [driver]
  (.close driver))

(defn quit
  [driver]
  (.quit driver))

(defn window-handles
  [driver]
  (into #{} (.getWindowHandles driver)))

(defn window-handle
  [driver]
  (.getWindowHandle driver))

; FIXME: This is FirefoxDriver only and deprecated
(defn save-screenshot
  [driver filename]
  (.saveScreenshot driver (new File filename)))

; Navigation interface
(defn back
  [driver]
  (.back (.navigate driver)))

(defn forward
  [driver]
  (.forward (.navigate driver)))

(defn to
  [driver url]
  (.to (.navigate driver) url))

(defn refresh
  [driver]
  (.refresh (.navigate driver)))

; TargetLocator interface
(defn switch-to-frame
  [driver frame]
  (.frame (.switchTo driver) frame))

(defn switch-to-window
  [driver window]
  (.window (.switchTo driver) window))

(defn switch-to-default
  [driver]
  (.defaultContent (.switchTo driver)))

(defn swith-to-active
  [driver]
  (.activeElement (.switchTo driver)))

; FIXME: Full Cookie interface
(defn new-cookie
  ([name value] (new-cookie name value "/" nil))
  ([name value path] (new-cookie name value path nil))
  ([name value path date] (new Cookie name value path date)))

(defn cookie-name
  [cookie]
  (.getName cookie))

(defn cookie-value
  [cookie]
  (.getValue cookie))

; Option interface
(defn add-cookie
  [driver cookie]
  (.addCookie (.manage driver) cookie))

; FIXME: Multi method for delete-cookie-named and delete-cookie
(defn delete-cookie-named
  [driver name]
  (.deleteCookieNamed (.manage driver) name))

(defn delete-cookie
  [driver cookie]
  (.deleteCookie (.manage driver) cookie))

(defn delete-all-cookies
  [driver]
  (.deleteAllCookies (.manage driver)))

(defn cookies
  [driver]
  (into #{} (.getCookies (.manage driver))))

(defn cookie-named
  [driver name]
  (.getCookieNamed (.manage driver) name))


(def *slow-speed* Speed/SLOW)
(def *medium-speed* Speed/MEDIUM)
(def *fast-speed* Speed/FAST)

(defn speed
  ([driver] (.getSpeed (.manage driver)))
  ([driver speed] (.setSpeed (.manage driver) speed)))

(defn by-id
  [expr]
  (By/id expr))

(defn by-link-text
  [expr]
  (By/linkText expr))

(defn by-partial-link-text
  [expr]
  (By/partialLinkText expr))

(defn by-name
  [expr]
  (By/name expr))

(defn by-tag-name
  [expr]
  (By/tagName expr))

(defn by-xpath
  [expr]
  (By/xpath expr))

(defn by-class-name
  [expr]
  (By/className expr))

(defn by-css-selector
  [expr]
  (By/cssSelector expr))

(defn find-element
  [obj by]
  (try (.findElement obj by)
  (catch NoSuchElementException e nil)))

(defn find-elements
  [obj by]
  (try (into [] (.findElements obj by))
  (catch NoSuchElementException e [])))

; WebElement
(defn click
  [element]
  (.click element))

(defn submit
  [element]
  (.submit element))

(defn value
  [element]
  (.getValue element))

(defn clear
  [element]
  (.clear element))

(defn tag-name
  [element]
  (.getTagName element))

(defn attribute
  [element name]
  (.getAttribute element name))

(defn toggle
  [element]
  (.toggle element))

(defn selected?
  [element]
  (.isSelected element))

(defn select
  [element]
  (.setSelected element))

(defn enabled?
  [element]
  (.isEnabled element))

(defn text
  [element]
  (.getText element))

(defn send-keys
  [element keys]
  (.sendKeys element (into-array CharSequence (list keys))))
