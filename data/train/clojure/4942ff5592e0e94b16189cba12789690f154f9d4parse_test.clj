;;;; ブラウザ毎のWebDriver作成機能
;;; Authoer Taketoshi Aono ##
;;;
;;; 全てのブラウザはjavascriptエラー検知機能を持っているが、それぞれ有効化する方法が違うので、
;;; このモジュールはjavascriptエラーの検知機能を有効化したWebDriverの作成方法を提供する。
;;;

(ns cats-client-tester.driver-util
  (:require [clojure.string :as str]
            [clj-webdriver.driver :as webdriver]
            [clj-webdriver.core :as webdriver-core]
            [clj-time.local :as local-time]
            [clj-time.format :as time-format]
            [clj-http.client :as client]
            [cats-client-tester.browser :as br]
            [cats-client-tester.log-message :as logm]
            [cats-client-tester.logger :as logger]
            [cats-client-tester.page-state :as page-state]
            [cats-client-tester.profile :as profile]
            [cats-client-tester.proxy-server :as ps])
  (:import  [clj_webdriver.driver Driver]
            [java.util.logging Level]
            [java.util.concurrent TimeUnit]
            [java.util TimerTask Timer]
            [java.net URL]
            [org.openqa.selenium WebDriver]
            [org.openqa.selenium.chrome ChromeDriver ChromeOptions]
            [org.openqa.selenium.phantomjs PhantomJSDriver PhantomJSDriverService]
            [org.openqa.selenium.logging LogEntries]
            [org.openqa.selenium.logging LogEntry]
            [org.openqa.selenium.logging LogType]
            [org.openqa.selenium.logging LoggingPreferences]
            [org.openqa.selenium.remote CapabilityType]
            [org.openqa.selenium.remote DesiredCapabilities]
            [org.openqa.selenium.firefox FirefoxDriver]
            [org.openqa.selenium.firefox FirefoxProfile]
            [org.openqa.selenium UnhandledAlertException]
            [net.jsourcerer.webdriver.jserrorcollector JavaScriptError]))


(def ^{:private true
       :doc "実行中に時間が変わる可能性があるので、現在時刻を持っておく。"}
  current-time (local-time/local-now))


(def ^{:private true
       :doc "カスタムフォーマッタ"}
  custom-local-formatter (time-format/formatter "yyyy-MM-dd_HH"))


(alter-var-root
 #'local-time/*local-formatters*
 (fn [formatters] (into formatters {:custom custom-local-formatter})))


(def ^{:private true
       :doc "スクリーンショットのファイル名末尾に付く日付"}
  screen-shot-date-suffix (local-time/format-local-time current-time :custom))


(defn- mkdirs
  "ディレクトリ階層を作成する。
   dir - str
   example
     (mkdirs \"foo/bar/baz/\")"
  ([dir]
   (let [dirs (str/split dir #"/")]
     (loop [dir (first dirs)
            dirs (rest dirs)]
       (when-not (= dir "/")
         (.mkdir (java.io.File. dir)))
       (when (seq dirs)
         (recur (format "%s/%s" dir (first dirs)) (rest dirs)))))))


(def ^{:private true
       :doc "スクリーンショットを保存する、日付のディレクトリ。<prefix>/<yyyy>/<MM>/<dd>/<hour>/"}
  screen-shot-path
  ((fn []
     (let [t current-time
           screen-shot-path-prefix (:path (:screen-shot (profile/s3-config)))
           year (.getYear t)
           month (.getMonthOfYear t)
           day (.getDayOfMonth t)
           hour (.getHourOfDay t)
           path (format "%s%s/%s/%s/%s/%s" profile/root-dir screen-shot-path-prefix year month day hour)]
       (mkdirs path)
       path))))


(def ^{:const
       :private
       :doc "Google Chromeのドライバのロケーション"}
  chrome-drivers {:win32   "win32/chromedriver.exe"
                  :win64   "win32/chromedriver.exe"
                  :linux32 "linux32/chromedriver"
                  :linux64 "linux64/chromedriver"
                  :mac     "mac/chromedriver"})

(def ^{:const
       :private
       :doc "OSの名前"}
  os-name (System/getProperty "os.name"))


(def ^{:const
       :private
       :doc "実行中のOSアーキテクチャ"}
  os-arch (System/getProperty "os.arch"))


(defprotocol JSErrorAwareDriver
  "エラー検知する用WebDriverのプロトコル定義"
  (log-errors [this browser url logger]
    "指定されたブラウザの全てのエラーを集める。
     集められたエラーをログに出力する。
     this    - clj-webdriver.driver/Driver
     browser - cats-client-tester.browser/Browser
     url     - str
     logger  - ch.qos.logback.classic.Logger"))


(defprotocol ScreenShotWritableDriver
  "スクリーンショットを指定された場所に書き出すWebDriverのプロトコル定義"
  (save-screen-shot [this path url ctn-id]
    "スクリーンショットを保存する。
     path   - str
     url    - str
     ctn-id - str"))


(defprotocol WhiteoutCheckableDriver
  "ページがホワイトアウトするかチェックする機能をもったWebDriverのプロトコル定義"
  (check-whiteout [this url logger]
    "ページがホワイトアウトしているかチェックし、
     もしホワイトアウトしていたら、ログに出力する。
     url    - str
     logger - ch.qos.logback.classic.Logger"))


(defn- init-chrome-driver
  "Javascriptのエラーログとプロキシサーバが有効になったGoogle Chromeのドライバを作成する。
   return - clj-webdriver.driver/Driver"
  ([]
   (let [cap (DesiredCapabilities/chrome)
         log-pref (LoggingPreferences.)
         opt (ChromeOptions.)]
     ;; Enable all browser logging.
     (.addArguments opt [(format "--proxy-server=http://localhost:%d" (ps/port ps/proxy-server))])
     (.. log-pref (enable LogType/BROWSER Level/ALL))
     (.. cap (setCapability CapabilityType/LOGGING_PREFS log-pref))
     (.. cap (setCapability ChromeOptions/CAPABILITY opt))
     (.. cap (setCapability CapabilityType/ACCEPT_SSL_CERTS true))
     (webdriver/init-driver (ChromeDriver. cap)))))


(defn- init-firefox-driver
  "Javascriptのエラーログとプロキシサーバが有効になったFirefoxのドライバを作成する。
   return - clj-webdriver.driver/Driver"
  ([]
   (let [ff-prof (FirefoxProfile.)
         port (ps/port ps/proxy-server)
         cap (DesiredCapabilities/firefox)]
     ;(JavaScriptError/addExtension ff-prof)
     (.. ff-prof (setAcceptUntrustedCertificates true))
     (.. ff-prof (setAssumeUntrustedCertificateIssuer true))
     (.. cap (setCapability CapabilityType/ACCEPT_SSL_CERTS true))
     (.. cap (setCapability CapabilityType/PROXY (ps/client ps/proxy-server)))
     (.. cap (setCapability FirefoxDriver/PROFILE ff-prof))
     (webdriver/init-driver (FirefoxDriver. cap)))))


(defn- init-phantomjs-driver
  "Javascriptのエラーログとプロキシサーバが有効になったphantomjsのドライバを作成する。
   return - clj-webdriver.driver/Driver"
  ([]
   (let [cap (DesiredCapabilities/phantomjs)
         port (ps/port ps/proxy-server)]
     (.setCapability cap PhantomJSDriverService/PHANTOMJS_EXECUTABLE_PATH_PROPERTY "/usr/local/bin/phantomjs")
     (.setCapability cap PhantomJSDriverService/PHANTOMJS_CLI_ARGS
                     (to-array ["--ignore-ssl-errors=yes" "--ssl-protocol=any"]))
     (.. cap (setCapability CapabilityType/ACCEPT_SSL_CERTS true))
     (.. cap (setCapability CapabilityType/PROXY (ps/client ps/proxy-server)))
     (webdriver/init-driver (PhantomJSDriver. cap)))))


(defn- get-jserror-collector-errors
  "JavaScriptErrorクラスによって集められたログを読み出す。
   driver - clj-webdriver.driver/Driver"
  ([driver]
   (JavaScriptError/readErrors (:webdriver driver))))


(defn- get-browser-console-errors
  "ブラウザのコンソールに出力されたjavascriptのエラーを取得する。
   driver - clj-webdriver.driver/Driver"
  ([driver]
   (.. (.manage (:webdriver driver)) (logs) (get "browser"))))


(defmulti ^:private log-js-errors
  "javascriptのエラーをログに出力する。
   エラーの取得方法は各ブラウザ毎に定義してある方法で取得する
   driver  - clj-webdriver.driver/Driver
   borwser - cats-client-tester.browser/Browser
   logger  - ch.qos.logback.classic.Logger"
  (fn [driver browser url logger] (br/log-typeof browser)))


(defmethod ^:private log-js-errors :jserror-collector
  [driver browser url logger]
  (doseq [error (get-jserror-collector-errors driver)]
    (logger/log logger (logm/init-log-message :jserror-collector error url))))


(defmethod ^:private log-js-errors :browser-console
  [driver browser url logger]
  (let [logs (get-browser-console-errors driver)]
    (doseq [log logs] (logger/log logger (logm/init-log-message :browser-console log url)))))


(defn- get-os-arch-type
  "実行するOSのアーキテクチャを取得し、
   'x64'か'x86'を返す。
   return - str"
  ([]
   (if (> (.. os-arch (indexOf "64")) -1) "x64" "x86")))


(defn get-chrome-driver-path-suffix
  "アーキテクチャに応じたChromeDriverのパスを返す。"
  ([]
   (case (str (subs os-name 0 3) "-" (get-os-arch-type))
     "Lin-x64" (:linux64 chrome-drivers)
     "Lin-x86" (:linux32 chrome-drivers)
     "Mac-x64" (:mac     chrome-drivers)
     "Win-x64" (:win64   chrome-drivers)
     "Win-x86" (:win32   chrome-drivers))))


(defn- set-timeout-to-driver
  "webdriverにタイムアウトを設定する。
   driver - clj-webdriver.driver.Driver"
  ([driver]
   (.. (:webdriver driver) (manage) (timeouts) (pageLoadTimeout 12 TimeUnit/SECONDS))
   driver))


(defn- disable-beforeunload
  "onbeforeunloadをjavascriptを使用して無効化する。
   driver - clj-webdriver.driver.Driver"
  ([driver]
   (webdriver-core/execute-script* (:webdriver driver) "window.onbeforeunload = function() {}")))


(defmulti init-driver
  "browserパラメータで指定されたWebDriverを作成する。
   この関数で作成されたWebDriverはjavascriptエラーのロギングが有効になっている。
   browser - cats-client-tester.browser/Browser"
  (fn [browser] (br/typeof browser)))

(defmethod init-driver :chrome    [browser] ((comp set-timeout-to-driver init-chrome-driver)))
(defmethod init-driver :firefox   [browser] ((comp set-timeout-to-driver init-firefox-driver)))
(defmethod init-driver :phantomjs [browser] ((comp set-timeout-to-driver init-phantomjs-driver)))


(def ^{:private true
       :doc "スクリーンショットのサイト毎のパス
             [<mst_container_id>-<ホスト名>-<urlパス>]"}
  screen-shot-site-specific-format "%s-%s-%s")


(def ^{:private true
       :doc "スクリーンショットのファイル名フォーマット
             <ディレクトリ>/screen_<ブラウザ名>_<screen-shot-site-specific-format>.<日付>.png"}
  screen-shot-filename-format "%s/screen_%s_%s.%s.png")


(defn id-host-path->filepath
  "mst_container_idとホスト名、URLパスをファイルパスに変換する。
   url    - java.net.URL
   ctn-id - str"
  ([url ctn-id]
   (let [url-obj (URL. url)
         host (str/replace (.getHost url-obj) #":" "-")
         replaced-url-path (str/replace (.getPath url-obj) #"/" "-")
         url-path (if (> (count replaced-url-path) 1) (subs replaced-url-path 1 (- (count replaced-url-path) 1)) "index")]
     (format screen-shot-site-specific-format ctn-id host url-path))))


(defn- create-screen-shot-path
  "スクリーンショットの保存先パスを作成する。
   browser - cats-client-tester.browser.Browser
   url     - str
   ctn-id  - str"
  ([browser url ctn-id]
     (format screen-shot-filename-format
             screen-shot-path
             (br/nameof browser)
             (id-host-path->filepath url ctn-id)
             screen-shot-date-suffix)))


;; clj-webdriver.driver/Driverを拡張し、
;; エラー収集関数を追加する。
(extend-type Driver
  ;; JSのエラー検知プロトコル実装
  JSErrorAwareDriver
  (log-errors [this browser url logger] (log-js-errors this browser url logger))
  ;; スクリーンショット保存機能プロトコル実装
  ScreenShotWritableDriver
  (save-screen-shot [this browser url ctn-id]
    (-> this
        (webdriver-core/get-screenshot :file (create-screen-shot-path browser url ctn-id))))
  ;; ホワイトアウト対応のプロトコル実装
  WhiteoutCheckableDriver
  (check-whiteout [this url logger]
    ;; (when (> (count (:trace-redirects (client/get url))) 1)
    ;;   (logger/log logger (logm/init-log-message :simple-warn "302 Redirected, so selenium assume this url need login." url)))
    (webdriver-core/to this url)
    (Thread/sleep 700)
    (disable-beforeunload this)
    ;; Safari, Phantomjs等のWebkitベースのブラウザでは、onbeforeunloadは
    ;; unconfigurableなので、ここで無効化しなければならない。
    (when (page-state/is-whiteout? this)
      (logger/log-whiteout logger url))))
