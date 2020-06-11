(ns shale.resources
  (:require clojure.walk
            [cheshire [core :as json]]
            [clojure.java.io :as io]
            [camel-snake-kebab.core :refer :all]
            [camel-snake-kebab.extras :refer [transform-keys]]
            [schema.core :as s]
            [schema.coerce :as coerce]
            [liberator.core :refer [defresource]]
            [compojure.core :refer [context ANY GET routes]]
            [compojure.route :refer [resources not-found]]
            [hiccup.page :refer [include-js include-css html5]]
            [clojure.set :refer [rename-keys]]
            [shale.utils :refer :all]
            [shale.logging :as logging]
            [shale.nodes :as nodes]
            [shale.proxies :as proxies]
            [shale.sessions :as sessions])
  (:import java.net.URL
           [schema.core Schema EqSchema Predicate]))

(defn json-keys [m]
  (transform-keys ->snake_case_string m))

(defn clojure-keys [m]
  (transform-keys ->kebab-case-keyword m))

(defn name-keys [m]
  (transform-keys name m))

(defn truth-from-str-vals [m]
  (map-walk (fn [[k v]]
              [k (if (#{"True" "1" 1 "true" true} v) true false)])
            m))

(defn jsonify [m]
  (-> (json-keys m)
      json/generate-string
      (str "\n")))

(defn is-json-content? [context]
  (if (#{:put :post} (get-in context [:request :request-method]))
    (or
     (re-matches #"application/json(?:;.*)?"
                 (or (get-in context [:request :headers "content-type"]) ""))
     [false {:message "Unsupported Content-Type"}])
    true))

(defn is-json-or-unspecified? [context]
  (or (nil? (get-in context [:request :headers "content-type"]))
      (is-json-content? context)))

(defn body-as-string [context]
  (if-let [body (get-in context [:request :body])]
    (condp instance? body
      java.lang.String body
      (slurp (io/reader body)))))

(defn ->boolean-params-data [context]
  (name-keys (truth-from-str-vals (get-in context [:request :params]))))

(defn request-data-coercion
  "A schema.coerce inspired walker to coerce request data to a matching schema.

  As well as the basic coercions (keyword -> string, string -> int) it also
  converts snake_cased_strings to kebab-cased-keywords."
  [schema]
  (s/start-walker
   (fn [sub]
     (let [walk (s/walker sub)]
       (fn [x]
         (if-let [keywords (and (not (instance? schema.core.Schema sub))
                                (map? sub)
                                (map? x)
                                (->> (keys sub)
                                     (map s/explicit-schema-key)
                                     (filter identity)))]
           (walk (->> keywords
                      (map (fn [k] (vec [(->snake_case_string k) k])))
                      (into {})
                      (rename-keys x)))
           (cond
             (and
               (vector? sub)
               (sequential? x)) (walk (vec x))
             (and
               (set? sub)
               (sequential? x)) (walk (into #{} x))
             (and
               (instance? EqSchema sub)
               (keyword? (.-v sub))
               (string? x)) (walk (->kebab-case-keyword x))
             (and
               (instance? schema.core.Predicate sub)
               (= (.pred-name sub) 'keyword?)
               (string? x)) (walk (keyword x))
            (and
              (instance? schema.core.EnumSchema sub)
              (every? keyword? (.vs sub))) (walk (keyword x))
            :else (walk x))))))
   schema))

(defn parse-request-data
  "Parse JSON bodies in PUT and POST requests according to an optional schema.

  If include-boolean-params is true, and the body data is a map, merge any
  boolean param variables into the returned map as well."
  [& {:keys [context k include-boolean-params schema]
      :or {k ::data schema s/Any}}]
  (when (#{:put :post :patch} (get-in context [:request :request-method]))
    (try
      (if-let [body (body-as-string context)]
        (let [body-data (json/parse-string body)
              params-data (if include-boolean-params
                            (->boolean-params-data context))
              data (if (map? body-data)
                     (merge body-data params-data)
                     (if (sequential? body-data)
                       (vec body-data)
                       body-data))
              coerced ((request-data-coercion schema) (if (sequential? data)
                                                        (vec data)
                                                        data))]
          (if (instance? schema.utils.ErrorContainer coerced)
            (do
              (logging/warn
                (format (str "Client data doesn't match schema:\n%s\n"
                             "Schema: %s\n"
                             "Error: %s")
                        data
                        schema
                        (pretty coerced)))
              {:message (:error coerced)})
            [false {k coerced}]))
        {:message "Empty body."})
      (catch com.fasterxml.jackson.core.JsonParseException e
        {:message "Malformed JSON."}))))

(defn handle-exception [context]
  (let [exc (:exception context)
        _ (logging/error exc)
        info (ex-data exc)
        message (if (:user-visible info)
                  (.getMessage exc)
                  "Internal server error.")]
    (jsonify {:error message})))

(defn ->session-pool
  [context]
  (get-in context [:request :state :session-pool]))

(defn ->node-pool
  [context]
  (get-in context [:request :state :node-pool]))

(defn ->proxy-pool
  [context]
  (get-in context [:request :state :proxy-pool]))

(defn ->session-id
  [context]
  (or (::id context) (get-in context [:request :params :id])))

(defresource sessions-resource [params]
  :allowed-methods  [:get :post :delete]
  :available-media-types  ["application/json"]
  :known-content-type? is-json-or-unspecified?
  :malformed? #(parse-request-data
                 :context %
                 :include-boolean-params true
                 :schema sessions/GetOrCreateArg)
  :handle-ok (fn [context]
               (jsonify (sessions/view-models (->session-pool context))))
  :handle-exception handle-exception
  :post! (fn [context]
           {::session (sessions/get-or-create-session
                        (->session-pool context)
                        (clojure-keys (::data context)))})
  :delete! (fn [context]
             (let [immediately (get (->boolean-params-data context) "immediately")
                   destroy sessions/destroy-session
                   session-pool (->session-pool context)]
               (doall
                 (map #(destroy session-pool (:id %) :immediately immediately)
                      (sessions/view-models session-pool)))))
  :handle-created (fn [context]
                    (jsonify (get context ::session))))

(defn build-session-url [request id]
  (URL. (format "%s://%s:%s/sessions/%s"
                (name (:scheme request))
                (:server-name request)
                (:server-port request)
                (str id))))

(def shared-session-resource
  {:allowed-methods [:get :patch :delete]
   :available-media-types ["application/json"]
   :known-content-type? is-json-or-unspecified?
   :malformed? #(parse-request-data
                  :context %
                  :schema [sessions/ModifyArg])
   :handle-ok (fn [context]
                (jsonify (::session context)))
   :handle-exception handle-exception
   :delete! (fn [context]
              (let [immediately (get (->boolean-params-data context) "immediately")]
                (sessions/destroy-session
                  (->session-pool context)
                  (->session-id context)
                  :immediately immediately))
              {::session nil})
   :patch! (fn [context]
           {::session
            (let [session-pool (->session-pool context)
                  id (->session-id context)
                  modifications (clojure-keys (::data context))]
              (sessions/modify-session session-pool id modifications))
            ::new? false})
   :respond-with-entity? (fn [context]
                           (contains? context ::session))
   :new? (fn [context]
           (and (not (false? (::new? context)))
                (::session context)))
   :exists? (fn [context]
              (let [session-pool (->session-pool context)
                    session-id (->session-id context)]
                (if (sessions/view-model-exists? session-pool session-id)
                  (if-let [session (sessions/view-model session-pool session-id)]
                    {::session session
                     ::id (:id session)}))))})

(defresource session-resource [id] shared-session-resource)

(defresource session-by-webdriver-id [webdriver-id]
  shared-session-resource
  :location (fn [context]
              (build-session-url (:request context)
                                 (get-in context [::session :id])))
  :exists?  (fn [context]
              (let [pool (->session-pool context)
                    by-webdriver-id sessions/view-model-by-webdriver-id
                    session (by-webdriver-id pool webdriver-id)]
                (if-not (nil? session)
                  {::session session
                   ::id (:id session)}))))

(defresource sessions-refresh-resource [id]
  :allowed-methods [:post]
  :available-media-types ["application/json"]
  :handle-exception handle-exception
  :post! (fn [context]
           (sessions/refresh-sessions (->session-pool context)
                                      (if (nil? id) id [id]))))

(defresource nodes-resource [params]
  :allowed-methods  [:get]
  :available-media-types  ["application/json"]
  :known-content-type? is-json-or-unspecified?
  :handle-ok (fn [context]
               (jsonify (nodes/view-models (->node-pool context))))
  :handle-exception handle-exception)

(defresource nodes-refresh-resource []
  :allowed-methods [:post]
  :available-media-types ["application/json"]
  :handle-exception handle-exception
  :post! (fn [context]
           (nodes/refresh-nodes (->node-pool context))))

(defresource node-resource [id]
  :allowed-methods [:get :patch :delete]
  :available-media-types ["application/json"]
  :known-content-type? is-json-or-unspecified?
  :malformed? #(parse-request-data
                 :context %
                 :schema {(s/optional-key :tags) [s/Str]
                          (s/optional-key :max-sessions) s/Int})
  :handle-ok (fn [context]
               (jsonify (get context ::node)))
  :handle-exception handle-exception
  :delete! (fn [context]
             (nodes/destroy-node (->node-pool context) id))
  :patch! (fn [context]
            {::node
             (nodes/modify-node (->node-pool context) id (clojure-keys
                                                           (::data context)))})
  :exists? (fn [context]
             (let [node-pool (->node-pool context)]
               (if (nodes/view-model-exists? node-pool id)
                 (if-let [node (nodes/view-model node-pool id)]
                   {::node node})))))

(s/defschema ProxyCreate
  {(s/optional-key :active)    s/Bool
   (s/optional-key :public-ip) s/Str
   (s/optional-key :shared)    s/Bool
   (s/required-key :host)      s/Str
   (s/required-key :port)      s/Int
   (s/required-key :type)      (s/enum :socks5 :http)})

(s/defschema ProxyModification
  {(s/optional-key :active) s/Bool
   (s/optional-key :shared) s/Bool})

(defresource proxy-resource [id]
  :allowed-methods [:get :delete :patch]
  :available-media-types ["application/json"]
  :known-content-type? is-json-or-unspecified?
  :malformed? (fn [context]
                (parse-request-data
                  :context context
                  :schema ProxyModification))
  :handle-ok (fn [context]
               (jsonify (get context ::proxy)))
  :handle-exception handle-exception
  :delete! (fn [context]
             (proxies/delete-proxy! (->proxy-pool context) id))
  :patch! (fn [context]
            (proxies/modify-proxy! (->proxy-pool context)
                                   id
                                   (clojure-keys (::data context))))
  :exists? (fn [context]
             (let [proxy-pool (->proxy-pool context)]
               (if (proxies/view-model-exists? proxy-pool id)
                 (if-let [prox (proxies/view-model proxy-pool id)]
                   {::proxy prox})))))

(defresource proxies-resource [params]
  :allowed-methods [:get :post]
  :available-media-types ["application/json"]
  :known-content-type? is-json-or-unspecified?
  :malformed? (fn [context]
                (parse-request-data
                  :context context
                  :schema ProxyCreate))
  :respond-with-entity? (fn [context]
                          (contains? context ::proxy))
  :post! (fn [context]
           (let [prox-spec (-> (::data context)
                               clojure-keys
                               (update-in [:type]
                                          #(if-not (nil? %)
                                             (keyword %))))]
             {::proxy (proxies/create-proxy!
                        (->proxy-pool context)
                        prox-spec)}))
  :handle-created (fn [context]
                    (jsonify (::proxy context)))
  :handle-ok (fn [context]
               (jsonify (proxies/view-models (->proxy-pool context))))
  :handle-exception handle-exception)

(def mount-target
  [:div#app
      [:h3 "ClojureScript has not been compiled!"]
      [:p "please run "
       [:b "lein figwheel"]
       " in order to start the compiler"]])

(def loading-page
  (html5
   [:head
     [:meta {:charset "utf-8"}]
     [:meta {:name "viewport"
             :content "width=device-width, initial-scale=1"}]
     (include-css "/css/site.css")
     (include-css "/lib/bootstrap-3.3.6/css/bootstrap.min.css")
     (include-css "/lib/font-awesome-4.5.0/css/font-awesome.css")]
    [:body
     mount-target
     (include-js "/js/app.js")]))

(defn assemble-routes []
  (routes
    (GET "/" [] loading-page)
    (GET "/manage" [] loading-page)
    (GET ["/manage/node/:id", :id #"(?:[a-zA-Z0-9\-])+"] [] loading-page)
    (GET ["/manage/session/:id", :id #"(?:[a-zA-Z0-9\-])+"] [] loading-page)
    (GET "/docs" [] loading-page)
    (ANY "/sessions" {params :params} sessions-resource)
    (ANY "/sessions/refresh" [] (sessions-refresh-resource nil))
    (ANY ["/sessions/:id", :id #"(?:[a-zA-Z0-9]{4,}-)*[a-zA-Z0-9]{4,}"]
      [id]
      (session-resource id))
    (ANY ["/sessions/webdriver/:webdriver-id",
          :webdriver-id #"(?:[a-zA-Z0-9]{4,}-)*[a-zA-Z0-9]{4,}"]
      [webdriver-id]
      (session-by-webdriver-id webdriver-id))
    (ANY ["/sessions/:id/refresh", :id #"(?:[a-zA-Z0-9]{4,}-)*[a-zA-Z0-9]{4,}"]
      [id]
      (sessions-refresh-resource id))
    (ANY "/nodes" {params :params} nodes-resource)
    (ANY "/nodes/refresh" [] (nodes-refresh-resource))
    (ANY ["/nodes/:id", :id #"(?:[a-zA-Z0-9\-])+"]
      [id]
      (node-resource id))
    (ANY "/proxies" {params :params} proxies-resource)
    (ANY ["/proxies/:id", :id #"(?:[a-zA-Z0-9\-])+"]
         [id]
         (proxy-resource id))
    (resources "/")
    (not-found "Not Found")))
