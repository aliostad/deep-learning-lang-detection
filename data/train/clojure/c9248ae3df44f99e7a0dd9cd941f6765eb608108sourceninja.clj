(ns leiningen.sourceninja
  (:require [cemerick.pomegranate.aether :as aether]
            [cheshire.core :as json]
            [clj-http.client :as client]
            [leiningen.core.classpath :as classpath]))

(defn- print-help
  []
  (println "
  1. Create a SourceNinja (http://sourceninja.com) account.
  2. Log into SourceNinja and create a product. The product you create will be paired with your application.
  3. After you create a product, you will be directed to a page asking what language your application is running. Select Clojure from the menu on the left side.
  4. You will be presented with two values, you'll need these two values later.

     Example:
       SOURCENINJA_PRODUCT_ID=\"477fcfa7-765a-4b91-b6a5-2ebe4c4f9d58\"
       SOURCENINJA_TOKEN=\"50a336d92da8ddea1ae0a6c0d06a172\"

  5. Set these values as enviroment variables or embed them in your project.clj file

     Example:
       :sourceninja {:id \"477fcfa7-765a-4b91-b6a5-2ebe4c4f9d58\"
                     :token \"50a336d92da8ddea1ae0a6c0d06a172\"}

  6. Execute the sourceninja send task from leiningen.

     Example:
       lein sourceninja send"))

(defn exception-to-string
  [tr]
  (format "%s: %s" (.getName (class tr)) (.getMessage tr)))

(defn trace-element-to-string
  [e]
  (str
   (let [class (.getClassName e)
         method (.getMethodName e)]
     (let [match (re-matches #"^([A-Za-z0-9_.-]+)\$(\w+)__\d+$" class)]
       (if (and match (= "invoke" method))
         (apply format "%s/%s" (rest match))
         (format "%s.%s" class method))))
   (format " (%s:%d)" (or (.getFileName e) "") (.getLineNumber e))))

(defn stack-trace-to-string
  ([tr] (stack-trace-to-string tr nil))
  ([tr n]
     (let [st (.getStackTrace tr)]
       (clojure.string/join
        (for [e (if (nil? n)
                  (rest st)
                  (take (dec n) (rest st)))]
          (format "    %s\n" (trace-element-to-string e)))))))


(defn- get-param
  [project k e d]
  (if-let [val (k (:sourceninja project))]
    val
    (if-let [val (System/getenv e)]
      val
      d)))

(defn- sn-post-url
  [host id]
  (str host "/products/" id "/imports"))

(defn- format-dep
  [direct dep]
  {"name" (clojure.string/replace (first dep) "/" ":")
   "version" (second dep)
   "direct" direct})

(defn- post
  [url token contents]
  (client/request {:method :post
                   :url url
                   :multipart [["token" token]
                               ["import_type" "json"]
                               ["Content/type" "application/text"]
                               ["import[import]" (.getBytes contents "UTF-8")]]}))

(defn sourceninja
  "manage your application with SourceNinja"
  {:no-project-needed false
   :help-arglists '([subtask] [send [product-id product-token]])
   :subtasks [#'send]}

  ([]
     (print-help))

  ([subtask]
     (print-help))

  ([project subtask & args]
     (case subtask
       "send" (try
                (let [host (get-param project :host "SOURCENINJA_HOST" "https://app.sourceninja.com")
                      id (get-param project :id "SOURCENINJA_PRODUCT_ID" nil)
                      token (get-param project :token "SOURCENINJA_TOKEN" nil)
                      deps (#'classpath/get-dependencies :dependencies project)
                      deps (set (map first (zipmap (keys deps) (aether/dependency-files deps))))
                      direct (set (keys (classpath/dependency-hierarchy :dependencies project)))
                      indirect (clojure.set/difference deps direct)]

                  (if (or (nil? host) (nil? id))
                    (println "Both a product ID and token are required")
                    (post
                     (sn-post-url host id)
                     token
                     (json/generate-string (concat (map (partial format-dep true) direct)
                                                   (map (partial format-dep false) indirect))))))
                (catch Exception e
                  (println (exception-to-string e))
                  (if (not= -1 (.indexOf args "--debug"))
                    (println (stack-trace-to-string e)))))

       (print-help))))
