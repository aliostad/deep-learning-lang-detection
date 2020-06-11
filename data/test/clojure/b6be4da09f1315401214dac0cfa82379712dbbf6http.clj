(ns clj-common.http)

(require '[clj-http.client :as clj-http])

(def ^:dynamic *throw-exception* false)

(defn get-as-stream [url]
  (let [response (clj-http/get url {:as :stream :throw-exceptions false})]
    (if (= (:status response) 200)
      (:body response)
      nil)))

(defn get-raw-as-stream
  "Returns status, headers and body ( as stream )"
  [url]
  (let [response (clj-http/get
                   url
                   {
                     :as :stream
                     :throw-exceptions false})]
    (update-in
      response
      [:headers]
      (fn [raw-headers]
        (into
          {}
          (map (fn [[k v]] [(keyword k) v]) raw-headers))))))

(def url->response get-raw-as-stream)

(defn post-as-stream [url body-stream]
  (let [response (clj-http/post
                   url
                   {
                     :body body-stream
                     :as :stream
                     :throw-exceptions false})]
    (if (= (:status response) 200)
      (:body response)
      nil)))
