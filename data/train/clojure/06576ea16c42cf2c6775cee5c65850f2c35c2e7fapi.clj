(ns limo.api
  (:require [clojure.java.io :as io]
            [clojure.string :as string]
            [clojure.test :refer :all]
            [clojure.tools.logging :as log]
            [environ.core :refer [env]]
            [clojure.set :as set])
  (:import java.util.concurrent.TimeUnit
           org.openqa.selenium.By
           org.openqa.selenium.By$ByCssSelector
           org.openqa.selenium.Dimension
           [org.openqa.selenium
            Keys
            StaleElementReferenceException
            TimeoutException
            NoSuchElementException]
           org.openqa.selenium.OutputType
           org.openqa.selenium.TakesScreenshot
           org.openqa.selenium.WebDriver
           org.openqa.selenium.WebElement
           org.openqa.selenium.interactions.Actions
           [org.openqa.selenium.support.ui
            ExpectedCondition
            ExpectedConditions
            WebDriverWait]
           org.openqa.selenium.support.ui.Select))

(def ^:dynamic *driver* nil)
(def ^:dynamic *default-timeout* 15000) ;; msec
(def ^:dynamic is-waiting false)

(defn set-driver! [d]
  (when d
    (alter-var-root #'*driver* (constantly d))))

;; Helpers

(defmacro ^:private narrate [msg args]
  `(when-let [m# ~msg]
     (log/info m# ~@args)))

(defn- wrap-narration [f msg]
  (fn [& args]
    (narrate msg (map pr-str args))
    (apply f args)))

(defn- lower-case [s]
  (string/lower-case (str s)))

(defn- case-insensitive= [s1 s2]
  (= (lower-case s1) (lower-case s2)))

(defn- join-paths [& paths]
  (apply str (interpose "/" paths)))

;; Elements

(defn element? [e]
  (instance? WebElement e))

(defn ^By by
  [s]
  (cond
    (element? s) (By/id (.getId s))
    (:xpath s) (By/xpath (:xpath s))
    (:id s) (By/id (:id s))
    (:tag-name s) (By/tagName (:tag-name s))
    (:link-text s) (By/linkText (:link-text s))
    (:partial-link-text s) (By/partialLinkText (:partial-link-text s))
    (:name s) (By/name (:name s))
    (:class-name s) (By/className (:class-name s))
    (:css s) (By$ByCssSelector. (:css s))
    (:css-selector s) (By/cssSelector (:css-selector s))
    :else (By/cssSelector s)))

(defn ^WebElement element
  ([selector-or-element] (element *driver* selector-or-element))
  ([driver selector-or-element]
   (if (element? selector-or-element)
     selector-or-element
     (.findElement driver (by selector-or-element)))))

(defn elements
  ([selector-or-elements] (elements *driver* selector-or-elements))
  ([driver selector-or-elements]
   (cond
     (element? selector-or-elements) [selector-or-elements]
     (seq? selector-or-elements) selector-or-elements
     :else (.findElements driver (by selector-or-elements)))))

(defn exists?
  ([selector-or-element] (exists? *driver* selector-or-element))
  ([driver selector-or-element]
   (try
     (not (= nil (element driver selector-or-element)))
     (catch org.openqa.selenium.NoSuchElementException _ false))))

;; Polling / Waiting

(defn wait-until
  ([pred] (wait-until pred *default-timeout*))
  ([pred timeout]
   (wait-until *driver* pred timeout 0))
  ([pred timeout interval]
   (wait-until *driver* pred timeout interval))
  ([driver pred timeout interval]
   (if is-waiting
     (if-let [result (pred)]
       result
       (throw (StaleElementReferenceException. "Inside another wait-until. Forcing retry.")))
     (binding [is-waiting true]
       (let [return-value (atom nil)
             wait (doto (WebDriverWait. driver (/ timeout 1000) interval)
                    (.ignoring StaleElementReferenceException))]
         (.until wait (proxy [ExpectedCondition] []
                        (apply [d] (reset! return-value (pred)))))
         @return-value)))))

(defn wait-until-clickable
  ([selector] (wait-until-clickable *driver* selector *default-timeout*))
  ([driver selector timeout]
   (let [wait (doto (WebDriverWait. driver (/ timeout 1000) 0)
                (.ignoring StaleElementReferenceException))]
     (.until wait (ExpectedConditions/elementToBeClickable (by selector))))))

(defmacro wait-for [narration & body]
  (if (empty? narration)
    `(wait-until (fn [] ~@body))
    `(do
       (println ~@narration)
       (wait-until (fn [] ~@body)))))

(defmacro wait-for-else [narration default-value & body]
  `(try
     ~(if (empty? narration)
        `(wait-until (fn [] ~@body))
        `(do
           (println ~@narration)
           (wait-until (fn [] ~@body))))
     (catch TimeoutException te#
       ~default-value)))

(defn implicit-wait
  ([timeout] (implicit-wait *driver* timeout))
  ([driver timeout] (.. driver manage timeouts (implicitlyWait timeout TimeUnit/MILLISECONDS))))

;; Act on Driver

(defn execute-script [driver js & js-args]
  (.executeScript driver (str js) (into-array Object js-args)))

(defn quit
  ([] (quit *driver*))
  ([driver] (.quit driver)))

(defn delete-all-cookies
  ([] (delete-all-cookies *driver*))
  ([driver] (.. driver manage deleteAllCookies)))

(defn switch-to
  ([iframe-element] (switch-to *driver* iframe-element))
  ([driver iframe-element] (.. driver (switchTo) (frame iframe-element))))

(defn switch-to-main-page
  ([] (switch-to-main-page *driver*))
  ([driver] (.. driver switchTo defaultContent)))

(defn switch-to-window
  [driver window-handle]
  (.. driver (switchTo) (window window-handle)))

(defn all-windows
  ([] (all-windows *driver*))
  ([driver] (set (.getWindowHandles driver))))

(defn active-window
  ([] (active-window *driver*))
  ([driver] (.getWindowHandle driver)))

(defmacro in-new-window
  ([opts action do-body] `(in-new-window *driver* ~opts ~action ~do-body))
  ([driver {:keys [auto-close?]} action do-body]
   `(let [prev-handle# (active-window ~driver)
          old-handles# (all-windows ~driver)]
      ~action
      (wait-until #(> (count (all-windows ~driver))
                      (count old-handles#)))
      (switch-to-window ~driver
                        (first (set/difference (all-windows ~driver)
                                               old-handles#)))
      ~do-body
      (if ~auto-close?
        (wait-until #(= (count (all-windows ~driver))
                        (count old-handles#)))
        (.close ~driver))
      (switch-to-window ~driver prev-handle#))))

;; Act on Element

(defn scroll-to
  ([selector-or-element] (scroll-to *driver* selector-or-element))
  ([driver selector-or-element]
   (wait-until #(exists? selector-or-element))
   (cond
     (string? selector-or-element)
     (execute-script driver
                     (if (= org.openqa.selenium.firefox.FirefoxDriver (type *driver*))
                       (format "document.querySelector(\"%s\").scrollIntoView();" selector-or-element)
                       (format "document.querySelector(\"%s\").scrollIntoViewIfNeeded();" selector-or-element)))
     (element? selector-or-element)
     (execute-script driver (if (= org.openqa.selenium.firefox.FirefoxDriver (type *driver*))
                              "arguments[0].scrollIntoView();"
                              "arguments[0].scrollIntoViewIfNeeded();")
                     selector-or-element))
   selector-or-element))

(defn click
  ([selector-or-element] (click *driver* selector-or-element))
  ([driver selector-or-element]
   (scroll-to driver selector-or-element)
   (wait-until-clickable selector-or-element)
   (wait-for ["click" selector-or-element]
             (.click (element driver selector-or-element))
             true)))

(def submit click)
(def toggle click)

(defn select-by-text
  ([selector-or-element value] (select-by-text *driver* selector-or-element value))
  ([driver selector-or-element value]
   (scroll-to driver selector-or-element)
   (wait-for ["select-by-text" selector-or-element value]
             (doto (Select. (element driver selector-or-element))
               (.selectByVisibleText value))
             selector-or-element)))

(defn select-by-value
  ([selector-or-element value] (select-by-value *driver* selector-or-element value))
  ([driver selector-or-element value]
   (scroll-to driver selector-or-element)
   (wait-for ["select-by-value" selector-or-element value]
             (doto (Select. (element driver selector-or-element))
               (.selectByValue value))
             selector-or-element)))

(defn send-keys
  ([selector-or-element s] (send-keys *driver* selector-or-element s))
  ([driver selector-or-element s]
   (wait-for nil
             (.sendKeys (element driver selector-or-element)
                        (into-array CharSequence [s]))
             true)))

(def input-text send-keys)

;; Query Element

(defn tag [selector-or-element]
  (wait-for-else ["tag" selector-or-element] nil
                 (.getTagName (element selector-or-element))))

(defn text
  ([selector-or-element] (text *driver* selector-or-element))
  ([driver selector-or-element]
   (wait-for-else ["text" selector-or-element] ""
                  (.getText (element driver selector-or-element)))))

(defn attribute
  ([selector-or-element attr] (attribute *driver* selector-or-element attr))
  ([driver selector-or-element attr]
   (if (= attr :text)
     (text selector-or-element)
     (let [attr (name attr)
           boolean-attrs ["async", "autofocus", "autoplay", "checked", "compact", "complete",
                          "controls", "declare", "defaultchecked", "defaultselected", "defer",
                          "disabled", "draggable", "ended", "formnovalidate", "hidden",
                          "indeterminate", "iscontenteditable", "ismap", "itemscope", "loop",
                          "multiple", "muted", "nohref", "noresize", "noshade", "novalidate",
                          "nowrap", "open", "paused", "pubdate", "readonly", "required",
                          "reversed", "scoped", "seamless", "seeking", "selected", "spellcheck",
                          "truespeed", "willvalidate"]
           webdriver-result (wait-for-else ["attribute" selector-or-element attr] nil
                                           (.getAttribute (element driver selector-or-element) (name attr)))]
       (if (some #{attr} boolean-attrs)
         (when (= webdriver-result "true")
           attr)
         webdriver-result)))))

(defn allow-backspace?
  "Don't hit backspace on selects, radios, checkboxes, etc.
   The browser will go back to the previous page."
  [e]
  (when e
    (case (tag e)
      "select" false
      "input" (-> (attribute e "type")
                  #{"radio" "checkbox" "button"}
                  not)
      true)))

(defn has-class [q class]
  (-> (element q)
      (.getAttribute "Class")
      (or "")
      (.contains class)))

(defn window-size
  ([] (window-size *driver*))
  ([driver]
   (wait-for ["window-size"]
             (let [d (.. driver manage window getSize)]
               {:width (.getWidth d)
                :height (.getHeight d)}))))

(defn window-resize
  ([dimensions-map] (window-resize *driver* dimensions-map))
  ([driver {:keys [width height] :as dimensions-map}]
   (println "window-resize")
   (-> driver
       .manage
       .window
       (.setSize (Dimension. width height)))))

(defn refresh
  ([] (refresh *driver*))
  ([driver]
   (println "refresh")
   (-> driver .navigate .refresh)))

(defn to
  ([^String url] (to *driver* url))
  ([driver ^String url]
   (println "to" url)
   (-> driver .navigate (.to url))))

(defn current-url
  ([] (current-url *driver*))
  ([^WebDriver driver]
   (println "current-url")
   (.getCurrentUrl driver)))

(defn options
  ([selector-or-element] (options *driver* selector-or-element))
  ([driver selector-or-element]
   (let [select-elem (Select. (element driver selector-or-element))]
     (map (fn [el]
            {:value (.getAttribute el "value")
             :text (.getText el)})
          (.getAllSelectedOptions select-elem)))))

;; modified queries from taxi to retry if StaleElementReferenceException is thrown
;; Any timeouts (aka - element not found) are converted to default return values

(defn visible?
  ([selector-or-element] (visible? *driver* selector-or-element))
  ([driver selector-or-element]
   (wait-for-else ["visible?" selector-or-element] false
                  (.isDisplayed (element driver selector-or-element)))))
(defn selected?
  ([selector-or-element] (selected? *driver* selector-or-element))
  ([driver selector-or-element]
   (wait-for-else ["selected?" selector-or-element] false
                  (.isSelected (element driver selector-or-element)))))

(defn value
  ([selector-or-element] (value *driver* selector-or-element))
  ([driver selector-or-element]
   (wait-for-else ["value" selector-or-element] ""
                  (.getAttribute (element driver selector-or-element) "value"))))

(defn invisible?
  ([selector-or-element] (invisible? *driver* selector-or-element))
  ([driver selector-or-element]
   (wait-for-else ["invisible?" selector-or-element] false
                  (not (.isDisplayed (element driver selector-or-element))))))

(defn current-url-contains? [substr]
  (println "current-url-contains?" (pr-str substr))
  (let [result (try
                 (wait-until #(.contains (current-url) substr))
                 (catch TimeoutException te
                   false))]
    (println "  -> " (pr-str result))
    result))

;; Assert on Elements

(defn text=
  ([selector-or-element expected-value] (text= *driver* selector-or-element expected-value))
  ([driver selector-or-element expected-value]
   (wait-for-else ["assert text=" selector-or-element expected-value] false
                  (case-insensitive= (.getText (element selector-or-element)) expected-value))))

(defn value=
  ([selector-or-element expected-value] (value= *driver* selector-or-element expected-value))
  ([driver selector-or-element expected-value]
   (wait-for-else ["assert value=" selector-or-element expected-value] false
                  (case-insensitive= (.getAttribute (element selector-or-element) "value")
                                     expected-value))))

(defn contains-text?
  ([selector-or-element expected-substr] (contains-text? *driver* selector-or-element expected-substr))
  ([driver selector-or-element expected-substr]
   (wait-for-else ["assert contains-text?" selector-or-element expected-substr] false
                  (.contains (lower-case (.getText (element selector-or-element)))
                             (lower-case expected-substr)))))

(defn num-elements=
  ([selector-or-element expected-count] (num-elements= *driver* selector-or-element expected-count))
  ([driver selector-or-element expected-count]
   (wait-for-else ["assert num-elements=" selector-or-element expected-count] false
                  (= (count (elements selector-or-element)) expected-count))))

(defn element-matches
  ([selector-or-element pred] (element-matches *driver* selector-or-element pred))
  ([driver selector-or-element pred]
   (wait-for-else ["match element with pred" selector-or-element] false
                  (pred (element selector-or-element)))))

;; Actions based on queries on elements

(defn click-when-visible [selector]
  (is (visible? selector))
  (click selector))

(defn set-checkbox [selector checked?]
  (when-not (= (selected? selector) checked?)
    (toggle selector)))

;; - Form Filling

(defn clear-fields [fields] ;- {selector function-or-string-to-enter}
  (doseq [[selector _] (filter (fn [[key value]] (string? value)) fields)]
    (when (allow-backspace? selector)
      ;; once for each character in the field
      (doseq [c (value selector)]
        ;; input[type=number] cursor starts at the beginning instead of end
        (send-keys selector Keys/BACK_SPACE)
        (send-keys selector Keys/DELETE)))))

(defn normalize-fields
  "Converts all string values that indicate typing text into functions"
  [fields]
  (into {}
        (map (fn [[k v]] [k (if (string? v)
                              #(input-text % v)
                              v)])
             fields)))

(defn- fill-form*
  ([fields] ;- {selector function-or-string-to-enter}
   (doseq [[selector action] (normalize-fields fields)]
     (action selector)))
  ([fields & more-fields]
   (fill-form* fields)
   (apply fill-form* more-fields)))

(defn fill-form
  ([fields1 fields2 & more-fields]
   (fill-form fields1)
   (apply fill-form fields2 more-fields))
  ([fields]
   (clear-fields fields)
   (fill-form* fields)
   (doseq [[selector value] (filter string? fields)]
     (is (value= selector value)
         (format "Failed to fill form element '%s' with '%s' (mis-entered to '%s')"
                 selector value (value selector))))))

;; Screenshots

(defn take-screenshot
  ([] (take-screenshot *driver* :file))
  ([format] (take-screenshot *driver* format nil))
  ([format destination] (take-screenshot *driver* format destination))
  ([driver format destination]
   {:pre [(or (= format :file)
              (= format :base64)
              (= format :bytes))]}
   (let [driver ^TakesScreenshot driver
         output (case format
                  :file (.getScreenshotAs driver OutputType/FILE)
                  :base64 (.getScreenshotAs driver OutputType/BASE64)
                  :bytes (.getScreenshotAs driver OutputType/BYTES))]
     (if destination
       (do
         (io/copy output (io/file destination))
         (log/info "Screenshot written to destination")
         output)
       output))))

(defn- screenshot-dir []
  (or (:circle-artifacts env)
      "screenshots"))

(defn- save-screenshot [name screenshot-dir]
  (let [f (io/file (screenshot-dir) name)]
    (io/make-parents f)
    (take-screenshot :file f)))

(defn screenshot
  ([name] (screenshot name screenshot-dir))
  ([name dir-f] (save-screenshot (str name ".png") dir-f)))

;; Window Size

(defn with-window-size* [new-size actions]
  (let [w-size (window-size)]
    (window-resize new-size)
    (let [result (actions)]
      (window-resize w-size)
      result)))

(defmacro with-window-size [new-size & body]
  `(with-window-size* ~new-size (fn [] ~@body)))
