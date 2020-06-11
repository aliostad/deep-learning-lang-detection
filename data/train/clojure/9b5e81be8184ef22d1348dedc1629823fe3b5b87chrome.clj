(in-ns 'clj-webdriver.core)

(import '[org.openqa.selenium.remote RemoteWebDriver]
        '[org.openqa.selenium.support.ui ExpectedCondition WebDriverWait]
        '[java.util.concurrent TimeUnit])

(require '[clj-webdriver.wait :as wait])

(extend-type ChromeDriver

  wait/IWait
  (implicit-wait [driver timeout]
    (.implicitlyWait (.. driver manage timeouts) timeout TimeUnit/MILLISECONDS)
    driver)

  (wait-until
    ([driver pred] (wait/wait-until driver pred 5000 0))
    ([driver pred timeout] (wait/wait-until driver pred timeout 0))
    ([driver pred timeout interval]
     (let [wait (WebDriverWait. driver (/ timeout 1000) interval)]
       (.until wait (proxy [ExpectedCondition] []
                      (apply [d] (let [result (pred (init-driver {:webdriver d}))]
                                   ;; This allows us to wrap zero-arity functions
                                   ;; in a single-arity function, so we don't need
                                   ;; to write a macro or different function.
                                   ;; (Taxi API support)
                                   (if (fn? result)
                                     (result)
                                     result)))))
       driver)))

  ;; Basic Functions
  IDriver
  (back [driver]
    (.back (.navigate driver))
    driver)

  (close [driver]
    (let [handles (window-handles* driver)]
      (if (> (count handles) 1) ; get back to a window that is open before proceeding
        (let [this-handle (window-handle* driver)
              idx (.indexOf handles this-handle)]
          (cond
           (zero? idx)
           (do                       ; if first window, switch to next
             (.close driver)
             (switch-to-window driver (nth handles (inc idx))))

           :else
           (do                     ; otherwise, switch back one window
             (.close driver)
             (switch-to-window driver (nth handles (dec idx)))))
          )
        (do
          (.close driver)
          ))))

  (current-url [driver]
    (.getCurrentUrl driver))

  (forward [driver]
    (.forward (.navigate driver))

    driver)

  (get-url [driver url]
    (.get driver url)

    driver)

  (get-screenshot
    ([driver] (get-screenshot driver :file))
    ([driver format] (get-screenshot driver format nil))
    ([driver format destination]
       {:pre [(or (= format :file)
                  (= format :base64)
                  (= format :bytes))]}
       (let [wd driver
             output (case format
                      :file (.getScreenshotAs wd OutputType/FILE)
                      :base64 (.getScreenshotAs wd OutputType/BASE64)
                      :bytes (.getScreenshotAs wd OutputType/BYTES))]
         (if destination
           (do
             (io/copy output (io/file destination))
             (log/info "Screenshot written to destination")
             output)
           output))))

  (page-source [driver]
    (.getPageSource driver))

  (quit [driver]
    (.quit driver)
   )

  (refresh [driver]
    (.refresh (.navigate driver))

    driver)

  (title [driver]
    (.getTitle driver))

  (to [driver url]
    (.to (.navigate driver) url)

    driver)


  ;; Window and Frame Handling
  ITargetLocator
  ;; TODO (possible): multiple arities; only driver, return current window handle; driver and query, return matching window handle
  (window [driver]
    (win/init-window driver
                     (.getWindowHandle driver)
                     (title driver)
                     (current-url driver)))

  (windows [driver]
    (let [current-handle (.getWindowHandle driver)
          all-handles (lazy-seq (.getWindowHandles driver))
          handle-records (for [handle all-handles]
                           (let [b (switch-to-window driver handle)]
                             (win/init-window driver
                                              handle
                                              (title b)
                                              (current-url b))))]
      (switch-to-window driver current-handle)
      handle-records))

  (other-windows [driver]
    (remove #(= (:handle %) (:handle (window driver)))
            (doall (windows driver))))

  (switch-to-frame [driver frame]
    (.frame (.switchTo driver)
            (if (element? frame)
              (:webelement frame)
              frame))
    driver)

  (switch-to-window [driver window]
    (cond
     (string? window)
     (do
       (.window (.switchTo driver) window)
       driver)

     (win/window? window)
     (do
       (.window (.switchTo (:driver window)) (:handle window))
       driver)

     (number? window)
     (do
       (switch-to-window driver (nth (windows driver) window))
       driver)

     (nil? window)
     (throw (RuntimeException. "No window can be found"))

     :else
     (do
       (.window (.switchTo driver) window)
       driver)))

  (switch-to-other-window [driver]
    (if (not= (count (windows driver)) 2)
      (throw (RuntimeException.
              (str "You may only use this function when two and only two "
                   "browser windows are open.")))
      (switch-to-window driver (first (other-windows driver)))))

  (switch-to-default [driver]
    (.defaultContent (.switchTo driver)))

  (switch-to-active [driver]
    (.activeElement (.switchTo driver)))


  ;; Options Interface (cookies)
  IOptions
  (add-cookie [driver cookie-spec]
    (.addCookie (.manage driver) (:cookie (init-cookie cookie-spec)))
    driver)

  (delete-cookie-named [driver cookie-name]
    (.deleteCookieNamed (.manage driver) cookie-name)
    driver)

  (delete-cookie [driver cookie-spec]
    (.deleteCookie (.manage driver) (:cookie (init-cookie cookie-spec)))
    driver)

  (delete-all-cookies [driver]
    (.deleteAllCookies (.manage driver))
    driver)

  (cookies [driver]
    (set (map #(init-cookie {:cookie %})
                   (.getCookies (.manage driver)))))

  (cookie-named [driver cookie-name]
    (let [cookie-obj (.getCookieNamed (.manage driver) cookie-name)]
      (init-cookie {:cookie cookie-obj})))

  ;; Alert dialogs
  IAlert
  (accept [driver]
    (-> driver :webdriver .switchTo .alert .accept))

  (alert-obj [driver]
    (-> driver :webdriver .switchTo .alert))

  (alert-text [driver]
    (-> driver :webdriver .switchTo .alert .getText))

  ;; (authenticate-using [driver username password]
  ;;   (let [creds (UserAndPassword. username password)]
  ;;     (-> driver :webdriver .switchTo .alert (.authenticateUsing creds))))

  (dismiss [driver]
    (-> driver :webdriver .switchTo .alert .dismiss))

  ;; Find Functions
  IFind
  (find-element-by [driver by-value]
    (let [by-value (if (map? by-value)
                     (by-query (build-query by-value))
                     by-value)]
      (init-element (.findElement driver by-value))))

  (find-elements-by [driver by-value]
    (let [by-value (if (map? by-value)
               (by-query (build-query by-value))
               by-value)
          els (.findElements driver by-value)]
      (if (seq els)
        (lazy-seq (map init-element els))
        (lazy-seq nil))))

  (find-windows [driver attr-val]
    (if (contains? attr-val :index)
      [(nth (windows driver) (:index attr-val))] ; vector for consistency below
      (filter #(every? (fn [[k v]] (if (= java.util.regex.Pattern (class v))
                                    (re-find v (k %))
                                    (= (k %) v)))
                       attr-val) (windows driver))))

  (find-window [driver attr-val]
    (first (find-windows driver attr-val)))

  (find-table-cell [driver table coords]
    (when (not= (count coords) 2)
      (throw (IllegalArgumentException.
              (str "The `coordinates` parameter must be a seq with two items."))))
    (let [[row col] coords
          row-css (str "tr:nth-child(" (inc row) ")")
          col-css (if (and (find-element-by table (by-tag "th"))
                             (zero? row))
                      (str "th:nth-child(" (inc col) ")")
                      (str "td:nth-child(" (inc col) ")"))
          complete-css (str row-css " " col-css)]
      (find-element-by table (by-query {:css complete-css}))))

  (find-table-row [driver table row]
    (let [row-css (str  "tr:nth-child(" (inc row) ")")
          complete-css (if (and (find-element-by table (by-tag "th"))
                                  (zero? row))
                           (str row-css " " "th")
                           (str row-css " " "td"))]
      ;; Element, not Driver, version of protocol
      (find-elements-by table (by-query {:css complete-css}))))

  ;; TODO: reconsider find-table-col with CSS support

  (find-by-hierarchy [driver hierarchy-vec]
    (find-elements driver {:xpath (build-query hierarchy-vec)}))

  (find-elements
    ([driver attr-val]
     (find-elements* driver attr-val)))

  (find-element
    ([driver attr-val]
     (find-element* driver attr-val)))

  IActions

  (click-and-hold
    ([driver]
       (let [act (:actions driver)]
         (.perform (.clickAndHold act))))
    ([driver element]
       (let [act (:actions driver)]
         (.perform (.clickAndHold act (:webelement element))))))

  (double-click
    ([driver]
       (let [act (:actions driver)]
         (.perform (.doubleClick act))))
    ([driver element]
       (let [act (:actions driver)]
         (.perform (.doubleClick act (:webelement element))))))

  (drag-and-drop
    [driver element-a element-b]
    (cond
     (nil? element-a) (throw-nse "The first element does not exist.")
     (nil? element-b) (throw-nse "The second element does not exist.")
     :else (let [act (:actions driver)]
             (.perform (.dragAndDrop act
                                     (:webelement element-a)
                                     (:webelement element-b))))))

  (drag-and-drop-by
    [driver element x-y-map]
    (if (nil? element)
      (throw-nse)
      (let [act (:actions driver)
            {:keys [x y] :or {x 0 y 0}} x-y-map]
        (.perform
         (.dragAndDropBy act
                         (:webelement element)
                         x y)))))

  (key-down
    ([driver k]
       (let [act (:actions driver)]
         (.perform (.keyDown act (key-code k)))))
    ([driver element k]
       (let [act (:actions driver)]
         (.perform (.keyDown act (:webelement element) (key-code k))))))

  (key-up
    ([driver k]
       (let [act (:actions driver)]
         (.perform (.keyUp act (key-code k)))))
    ([driver element k]
       (let [act (:actions driver)]
         (.perform (.keyUp act (:webelement element) (key-code k))))))

  (move-by-offset
    [driver x y]
    (let [act (:actions driver)]
      (.perform (.moveByOffset act x y))))

  (move-to-element
    ([driver element]
       (let [act (:actions driver)]
         (.perform (.moveToElement act (:webelement element)))))
    ([driver element x y]
       (let [act (:actions driver)]
         (.perform (.moveToElement act (:webelement element) x y)))))

  (release
    ([driver]
       (let [act (:actions driver)]
         (.release act)))
    ([driver element]
       (let [act (:actions driver)]
         (.release act element)))))

(extend-type org.openqa.selenium.interactions.Actions

  IActions
  ;; TODO: test coverage
  (click-and-hold
    ([act]
       (.clickAndHold act))
    ([act element]
       (.clickAndHold act (:webelement element))))

  ;; TODO: test coverage
  (double-click
    ([act]
       (.doubleClick act))
    ([act element]
       (.doubleClick act (:webelement element))))

  ;; TODO: test coverage
  (drag-and-drop
    [act element-a element-b]
    (.dragAndDrop act (:webelement element-a) (:webelement element-b)))

  ;; TODO: test coverage
  (drag-and-drop-by
    [act element x y]
    (.dragAndDropBy act (:webelement element) x y))

  ;; TODO: test coverage
  (key-down
    ([act k]
       (.keyDown act (key-code k)))
    ([act element k]
       (.keyDown act (:webelement element) (key-code k))))

  ;; TODO: test coverage
  (key-up
    ([act k]
       (.keyUp act (key-code k)))
    ([act element k]
       (.keyUp act (:webelement element) (key-code k))))

  ;; TODO: test coverage
  (move-by-offset
    [act x y]
    (.moveByOffset act x y))

  ;; TODO: test coverage
  (move-to-element
    ([act element]
       (.moveToElement act (:webelement element)))
    ([act element x y]
       (.moveToElement act (:webelement element) x y)))

  ;; TODO: test coverage
  (perform [act] (.perform act))

  ;; TODO: test coverage
  (release
    ([act]
       (.release act))
    ([act element]
       (.release act (:webelement element)))))

(extend-type CompositeAction

  IActions
  (perform [comp-act] (.perform comp-act)))

(defn find-element* [driver attr-val]
  (first (find-elements driver attr-val)))

(defn find-elements* [driver attr-val]
  (when-not (and (or
                  (map? attr-val)
                  (vector? attr-val))
                 (empty? attr-val))
    (try
      (cond
        ;; Accept by-clauses
        (not (or (vector? attr-val)
                 (map? attr-val)))
        (find-elements-by driver attr-val)

        ;; Accept vectors for hierarchical queries
        (vector? attr-val)
        (find-by-hierarchy driver attr-val)

        ;; Build XPath dynamically
        :else
        (find-elements-by driver (by-query (build-query attr-val))))
      (catch org.openqa.selenium.NoSuchElementException e
        ;; NoSuchElementException caught here to mimic Clojure behavior like
        ;; (get {:foo "bar"} :baz) since the page can be thought of as a kind of associative
        ;; data structure with unique selectors as keys and HTML elements as values
        (lazy-seq nil)))))

(defn new-sauce-labs-browser []
  ;; TODO: Change this to pg-eng, move key to secure location (out of source), and cycle
  (let [username "sgrove-pg"
        key      "c711f656-6fe7-4a4a-a5f5-70f07a034781"
        url      (format "http://%s:%s@ondemand.saucelabs.com:80/wd/hub" username key)
        caps     (org.openqa.selenium.remote.DesiredCapabilities/firefox)
        driver   (org.openqa.selenium.remote.RemoteWebDriver. (java.net.URL. url) caps)
        ]
    driver))
