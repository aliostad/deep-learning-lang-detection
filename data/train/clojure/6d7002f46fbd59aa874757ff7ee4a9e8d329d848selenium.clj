
;; Copyright (C) 2012 by Pramati Technologies

;; Licensed under the Apache License, Version 2.0 (the "License");
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at 
;; http://www.apache.org/licenses/LICENSE-2.0

;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or
;; implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

(ns nolan.selenium
  (require [nolan.xml]
           [clojure.xml :as xml]
           [clojure.zip :as zip]
           [clojure.contrib.zip-filter.xml :as zf])
  (import [org.openqa.selenium.firefox FirefoxDriver]
          [org.openqa.selenium WebDriverBackedSelenium]))

(def page-wait-millis "10000")

(defn- and-wait? [command]
  (.endsWith command "AndWait"))

(defn- strip-and-wait [command]
  (if (and-wait? command)
    (.substring command 0 (- (count command) (count "AndWait")))
    command))

(defn- method-for [driver command]
  (first (filter #(= command (.getName %))
                 (.getMethods (.getClass driver)))))

(defn- arg-count [method]
  (count (.getParameterTypes method)))

(defn- run-command [driver command]
  (let [command-method
        (method-for driver
                    (strip-and-wait (:command command)))]
    (.invoke command-method
             driver
             (object-array
              (case (arg-count command-method)
                0 nil
                1 [(:target command)]
                2 [(:target command) (:value command)]))))
  (when (and-wait? (:command command))
    (.waitForPageToLoad driver page-wait-millis)))

(defn parse-commands [html-file]
  (map
   (partial zipmap [:command :target :value])
   (partition 3
              (-> (java.io.File. html-file)
                  (xml/parse nolan.xml/non-validating-sax)
                  (zip/xml-zip)
                  (zf/xml-> :body :table :tbody :tr :td zf/text)))))

(defn run-commands [web-driver commands]
  (let [web-backed-selenium-driver
        (WebDriverBackedSelenium. web-driver "")]
    (doseq [c commands]
      (run-command web-backed-selenium-driver c))))

(defn browser-area [browser]
  "Returns a rectangle with left, top, width, height of the browser"
  (let [wnd (-> browser .manage .window)
        point (.getPosition wnd)
        size (.getSize wnd)]
    (java.awt.Rectangle. (.x point) (.y point)
                         (.width size) (.height size))))

(defmacro with-firefox [driver-name & body]
  `(let [~driver-name (FirefoxDriver.)]
     (try
       ~@body
       (finally (.close ~driver-name)))))

