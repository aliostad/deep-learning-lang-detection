(ns pallet.crate.forever-test
  (:require
   [clojure.test :refer :all]
   [clojure.tools.logging :as logging]
   [pallet.actions
    :refer [exec-checked-script exec-script package remote-file]]
   [pallet.api :refer [plan-fn server-spec]]
   [pallet.build-actions :refer [build-actions]]
   [pallet.core :refer [lift]]
   [pallet.crate :refer [assoc-settings defplan get-settings]]
   [pallet.crate.automated-admin-user :refer [automated-admin-user]]
   [pallet.crate.forever :as forever]
   [pallet.crate.network-service :refer [wait-for-http-status]]
   [pallet.crate.node-js :as node-js]
   [pallet.crate.service :refer [supervisor-config-map] :as service]
   [pallet.live-test :as live-test]
   [pallet.node :refer [primary-ip]]
   [pallet.stevedore :as stevedore]
   [pallet.test-utils :refer :all]))

(deftest invoke-test
  (is (build-actions {}
        (forever/settings {})
        (forever/install {}))))

(def settings-map {})

(def node-script "
var http = require(\"http\");
http.createServer(function(request, response) {
    response.writeHead(200, {\"Content-Type\": \"text/plain\"});
    response.end(\"Hello World!\\n\");}).listen(8080);
console.log(\"Server running at http://localhost:8080/\");")

(defmethod supervisor-config-map [:forever-test :forever]
  [_ {:keys [] :as settings} options]
  {})

(defplan service
  "Run the forever test service."
  [& {:keys [action if-flag if-stopped instance-id]
      :or {action :manage}
      :as options}]
  (let [{:keys [supervision-options] :as settings}
        (get-settings :forever-test {:instance-id instance-id})]
    (service/service settings (merge supervision-options
                                     (dissoc options :instance-id)))))

(def test-spec
  (server-spec
   :extends [(node-js/server-spec settings-map)
             (forever/server-spec settings-map)]
   :phases {:settings (plan-fn
                       (assoc-settings :forever-test
                                       {:script-name "node-script.js"}))
            :configure (plan-fn
                        (remote-file "node-script.js" :content node-script))
            :up (plan-fn
                   (let [settings (get-settings :forever-test)]
                     (service settings {:action :start})))
            :down (plan-fn
                   (let [settings (get-settings :forever-test)]
                     (service settings {:action :stop})))
            :verify-up (plan-fn
                        (wait-for-http-status
                         "http://localhost:8080/" 200 :url-name "node server")
                        (exec-checked-script
                         "check node-script is running"
                         (pipe
                          ("wget" "-O-" "http://localhost:8080/")
                          ("grep" -i (quoted "Hello World")))))
            :verify-down (plan-fn
                          (exec-checked-script
                           "check node-script is not running"
                           (when
                               (pipe
                                ("wget" "-O-" "http://localhost:8080/")
                                ("grep" -i (quoted "Hello World")))
                             (println "node-script still running" ">&2")
                             ("exit" 1))))}
   :default-phases [:install :configure :up :verify-up :down :verify-down]))

;; (deftest live-test
;;   (live-test/test-for
;;    [image (live-test/exclude-images (live-test/images) forever-unsupported)]
;;    (live-test/test-nodes
;;     [compute node-map node-types]
;;     {:forever
;;      {:image image
;;       :count 1
;;       :phases {:bootstrap (plan-fn (automated-admin-user))
;;                :settings (plan-fn
;;                            (nodejs-settings
;;                             {:deb
;;                              {:url node-deb
;;                               :md5 "597250b48364b4ed7ab929fb6a8410b8"}})
;;                            (forever-settings settings-map))
;;                :configure (plan-fn
;;                             (install-nodejs)
;;                             (install-forever)
;;                             (remote-file "node-script.js" :content node-script)
;;                             (forever-service
;;                              (stevedore/script "node-script.js")
;;                              :name "test" :action :start :max 1))
;;                :down (plan-fn
;;                        (forever-service
;;                         (stevedore/script "node-script.js")
;;                         :name "test" :action :stop))
;;                :verify-up (plan-fn
;;                             (wait-for-http-status
;;                              "http://localhost:8080/" 200 :url-name "node server")
;;                             (exec-checked-script
;;                              "check node-script is running"
;;                              (pipe
;;                               (wget "-O-" "http://localhost:8080/")
;;                               (grep -i (quoted "Hello World")))))
;;                :verify-down (plan-fn
;;                               (exec-checked-script
;;                                "check node-script is not running"
;;                                (when
;;                                    (pipe
;;                                     (wget "-O-" "http://localhost:8080/")
;;                                     (grep -i (quoted "Hello World")))
;;                                  (println "node-script still running" ">&2")
;;                                  (exit 1))))}}}
;;     (lift (:forever node-types)
;;           :phase [:settings :configure :verify-up :down :verify-down]
;;           :compute compute))))
