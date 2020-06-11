(ns puppetlabs.services.file-serving.file-serving-core-test
  (:require
    [clojure.java.io :as io]
    [clojure.string :as string]
    [clojure.test :refer :all]

    [cheshire.core :as json]

    [puppetlabs.services.protocols.request-handler :as jruby-file-server]
    [puppetlabs.services.file-serving.file-serving-service :as clj-file-server]

    [puppetlabs.trapperkeeper.app :as tk-app]
    [puppetlabs.trapperkeeper.bootstrap :as tk-bootstrap]
    [puppetlabs.trapperkeeper.config :as tk-config]
    [puppetlabs.trapperkeeper.testutils.bootstrap :as tst-bootstrap]

    [ring.util.codec :as ring-codec]
    [ring.util.response :as ring-response]
    [ring.mock.request :as ring-mock]))


(def bootstrap-config
  (-> "clj-file-server/bootstrap.cfg"
      io/resource
      .getPath))

(def app-config
  (-> "clj-file-server/config.conf"
      io/resource
      .getPath))

(def logback-config
  (-> "clj-file-server/logback-test.xml"
      io/resource
      .getPath))

(def codedir
  (-> "clj-file-server/fixtures/codedir"
      io/resource
      .getPath))

(def app-services
  (tk-bootstrap/parse-bootstrap-config! bootstrap-config))

(def base-config
  "Load dev config, but shift to a different port and turn logging down."
  (-> app-config
      tk-config/load-config
      (assoc-in [:webserver :ssl-port] 18140)
      (assoc-in [:global :logging-config] logback-config)
      (assoc-in [:jruby-puppet :master-code-dir] codedir)))

(defn get-jruby-handler
  [app]
  (partial jruby-file-server/handle-request
           (tk-app/get-service app :RequestHandlerService)))

(defn get-clj-handler
  [app]
  (partial clj-file-server/handle-request
           (tk-app/get-service app :FileServingService)))

(defn with-transformed-body
  "Parses JSON response bodies back into a map for easy diffing.
  Slurps file content response bodies into a string for comparison."
  [response]
  (condp contains? (ring-response/get-header response "Content-Type")
    #{"application/json" "text/pson"} (assoc response :body
                                             (-> response :body json/parse-string))
    #{"application/octet-stream"} (assoc response :body
                                         (-> response :body slurp))
    response))

(defn scrub-headers
  "Remove headers that are expected to be present in Clojure responses."
  [response]
  (update-in response [:headers]
             dissoc "X-Puppetserver-Service" "Content-Length" "Last-Modified"))

(defn assert-equal-response
  "Takes a reference to Ring handlers for JRuby and Clojure implementations of
  the File Server API and returns a function that can be used to assert each
  handler produces an equal response to a given Ring request."
  [ruby-handler clj-handler]
  (fn [request]
    (let [ruby-response (with-transformed-body (ruby-handler request))
          clj-response (-> (clj-handler request)
                           with-transformed-body
                           scrub-headers)]
      (is (= ruby-response clj-response)))))

(defn build-requests
  "A wrapper around ring-mock/request that allows headers to be set in
  addition to query parameters."
  [method paths {:keys [headers params]}]
  (map
    #(as-> (ring-mock/request method % params) r
       (reduce (fn [h [k v]] (ring-mock/header h k v)) r headers)
       (assoc r :remote-addr "127.0.0.1"))
    paths))

(defn describe-request
  "Creates a description for a request that can be used in a test macro."
  ([request]
   (describe-request request nil))
  ([request test-parameter]
   (let [method (-> request :request-method name string/upper-case)
         path (:uri request)]
     (if test-parameter
       (format "%s %s with %s" method path test-parameter)
       (format "%s %s" method path)))))

(defn test-parameterized-requests
  "Takes a test function and a base request along with a map of header values
  and query parameters. Each header and parameter should be associated with a
  vector of values. The base request is updated with those values and then
  given to the test function."
  [test-fn base-requests {:keys [headers params]}]
  (doseq [base-request base-requests]
    (let [base-params (if (contains? base-request :query-string)
                        (ring-codec/form-decode (:query-string base-request))
                        {})]

      ;; Test base case
      (testing (describe-request base-request)
        (test-fn base-request))

      ;; Iterate through headers
      (doseq [[header test-values] headers
              value test-values
              :let [test-param (string/join ": " [header value])
                    test-request (ring-mock/header base-request header value)]]
        (testing (describe-request test-request test-param)
          (test-fn test-request)))

      ;; Iterate through params
      (doseq [[param test-values] params
              value test-values
              :let [test-param (string/join "=" [param value])
                    test-request (ring-mock/query-string base-request
                                                         (merge
                                                           base-params
                                                           {param value}))]]
        (testing (describe-request test-request test-param)
          (test-fn test-request))))))


;; Test responses generated by the Clojure implementation against those
;; generated by the Ruby implementation and report any regressions.
;;
;; TODO: recurse parameter for file_metadatas
;; TODO: ignore parameter for file_metadatas
;; TODO: file_metadatas recursion depth? Not documented anywhere.
;; TODO: bad parameter values
;; TODO: file permission errors
;; TODO: missing files
;; TODO: broken symlinks
;; TODO: symlinks pointing to symlinks
(deftest jruby-regression-tests
  (tst-bootstrap/with-app-with-config
    app
    app-services
    base-config
    (let [ruby-handler (get-jruby-handler app)
          clj-handler (get-clj-handler app)
          assert-equal (assert-equal-response ruby-handler clj-handler)]

      (testing "/plugins mount"
        (testing "Metadatas API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_metadatas/plugins"]
              {:headers {"Accept" "text/pson"}
               :params {"environment" "production"
                        "recurse" "true"}})
            {:params {"links" ["manage" "follow"]
                      "checksum_type" ["md5"
                                       "md5lite"
                                       "sha256"
                                       "sha256lite"
                                       "mtime"
                                       "ctime"
                                       "none"]
                      "source_permissions" ["ignore"
                                            "use"
                                            "use_when_creating"]}}))
        (testing "Metadata API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_metadata/plugins"
               "/puppet/v3/file_metadata/plugins/facter/test_fact.rb"
               "/puppet/v3/file_metadata/plugins/facter/foo/test_link.rb"
               "/puppet/v3/file_metadata/plugins/facter/bar"
               "/puppet/v3/file_metadata/plugins/puppet/provider/foo_type/bar_provider.rb"]
              {:headers {"Accept" "text/pson"}
               :params {"environment" "production"}})
            {:params {"links" ["manage" "follow"]
                      "checksum_type" ["md5"
                                       "md5lite"
                                       "sha256"
                                       "sha256lite"
                                       "mtime"
                                       "ctime"
                                       "none"]
                      "source_permissions" ["ignore"
                                            "use"
                                            "use_when_creating"]}}))
        (testing "Content API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_content/plugins/facter/test_fact.rb"
               "/puppet/v3/file_content/plugins/facter/foo/test_link.rb"
               "/puppet/v3/file_content/plugins/puppet/provider/foo_type/bar_provider.rb"]
              {:headers {"Accept" "application/octet-stream"}
               :params {"environment" "production"}})
            {})))

      (testing "/pluginfacts mount"
        (testing "Metadatas API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_metadatas/pluginfacts"]
              {:headers {"Accept" "text/pson"}
               :params {"environment" "production"
                        "recurse" "true"}})
            {:params {"links" ["manage" "follow"]
                      "checksum_type" ["md5"
                                       "md5lite"
                                       "sha256"
                                       "sha256lite"
                                       "mtime"
                                       "ctime"
                                       "none"]
                      "source_permissions" ["ignore"
                                            "use"
                                            "use_when_creating"]}}))
        (testing "Metadata API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_metadata/pluginfacts"
               "/puppet/v3/file_metadata/pluginfacts/test_fact.txt"
               "/puppet/v3/file_metadata/pluginfacts/foo/test_fact_symlink.txt"
               "/puppet/v3/file_metadata/pluginfacts/bar"
               "/puppet/v3/file_metadata/pluginfacts/bar/test_fact_symlink.txt"]
              {:headers {"Accept" "text/pson"}
               :params {"environment" "production"}})
            {:params {"links" ["manage" "follow"]
                      "checksum_type" ["md5"
                                       "md5lite"
                                       "sha256"
                                       "sha256lite"
                                       "mtime"
                                       "ctime"
                                       "none"]
                      "source_permissions" ["ignore"
                                            "use"
                                            "use_when_creating"]}}))
        (testing "Content API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_content/pluginfacts/test_fact.txt"
               "/puppet/v3/file_content/pluginfacts/foo/test_fact_symlink.txt"
               "/puppet/v3/file_content/pluginfacts/bar/test_fact_symlink.txt"]
              {:headers {"Accept" "application/octet-stream"}
               :params {"environment" "production"}})
            {})))

      (testing "/modules mount"
        (testing "Metadatas API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_metadatas/modules/test1"
               "/puppet/v3/file_metadatas/modules/test2/foo"]
              {:headers {"Accept" "text/pson"}
               :params {"environment" "production"
                        "recurse" "true"}})
            {:params {"links" ["manage" "follow"]
                      "checksum_type" ["md5"
                                       "md5lite"
                                       "sha256"
                                       "sha256lite"
                                       "mtime"
                                       "ctime"
                                       "none"]
                      "source_permissions" ["ignore"
                                            "use"
                                            "use_when_creating"]}}))
        (testing "Metadata API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_metadata/modules/test1"
               "/puppet/v3/file_metadata/modules/test1/test_file.txt"
               "/puppet/v3/file_metadata/modules/test2/bar"
               "/puppet/v3/file_metadata/modules/test2/baz/test_file_link.txt"]
              {:headers {"Accept" "text/pson"}
               :params {"environment" "production"}})
            {:params {"links" ["manage" "follow"]
                      "checksum_type" ["md5"
                                       "md5lite"
                                       "sha256"
                                       "sha256lite"
                                       "mtime"
                                       "ctime"
                                       "none"]
                      "source_permissions" ["ignore"
                                            "use"
                                            "use_when_creating"]}}))
        (testing "Content API"
          (test-parameterized-requests
            assert-equal
            (build-requests
              :get
              ["/puppet/v3/file_content/modules/test1/test_file.txt"
               "/puppet/v3/file_content/modules/test2/baz/test_file_link.txt"]
              {:headers {"Accept" "application/octet-stream"}
               :params {"environment" "production"}})
            {}))))))
