(ns recipi.app
  (:require [clojure.tools.logging :as log]
            [compojure.route :as route]
            [compojure.api.sweet :refer :all]
            [compojure.api.swagger :refer [validate]]
            [compojure.api.middleware :refer [api-middleware-defaults]]
            [ring.middleware.json :refer [wrap-json-response wrap-json-body]]
            [ring.util.response :refer [response]]
            [ring.util.http-response :refer :all]
            [schema.core :as schema]
            [clojurewerkz.elastisch.native :as es]
            [clojurewerkz.elastisch.native.document :as doc]
            [clojurewerkz.elastisch.query :as q]))

(schema/defschema Ingredient
  {:item schema/Str
   :quantity schema/Int
   :measure schema/Str})                ; FIXME should be an enum

(schema/defschema Step
  {:description schema/Str
   :minutes schema/Int})

(schema/defschema Recipe
  {:ingredients [Ingredient]
   :instructions [Step]
   (schema/optional-key :id) schema/Str})

(defn connect-es 
  "Connect to the elasticsearch cluster"
  []
  (es/connect [["127.0.0.1" 9300]]
    {"cluster.name" "elasticsearch"}))

(defn create-recipe 
  "Store a recipe to the server."
  [recipe]
  (let [conn (connect-es)
        res (doc/create conn "recipes" "recipe" recipe)]
    (if
      (nil? (:error res)) (created {:id (:id res) :recipe recipe})
      (internal-server-error {:error (:error res) :recipe recipe}))))

(defn get-recipe-list
  "Returns a list of recipes"
  []
  (let [conn (connect-es)
        res (doc/search conn "recipes" "recipe")]
    (if
      (nil? (:error res)) (ok (map :_source (:hits (:hits res))))
      (not-found {:error "Recipe list could not be retrieved."}))))

(defn get-recipe
  "Returns a specific recipe"
  [id]
  (let [conn (connect-es)
        res (doc/get conn "recipes" "recipe" id)]
    (if
      (true? (:found res)) (ok (:source res))
      (not-found {:error (str "Recipe with id " id " not found!")}))))

(defn log-on-receive
  "Logs all incoming requests to the console."
  [handler]
  (fn [req]
    (log/info (str "Incoming request to '" (:uri req) "' received."))
    (handler req)))

(defapi app
  (middlewares [log-on-receive]
    (swagger-ui "/swagger")
    (swagger-docs
      {:info {:version "0.1.0"
              :title "Recipi"
              :description "A web server to manage delicious recipes!"}}
      :consumes ["application/json"]
      :produces ["application/json"])

    (GET* "/" []
      :no-doc true
      (-> 
        (ok "<h1>Web page!</h1>")
        (content-type "text/html; charset=utf-8")))

    (context "/recipes" []
      (GET* "/" []
        :description "Returns an unsorted list of most recently added recipes."
        :responses {404 {:schema {:error schema/Str}
                         :description "Either no recipes are loaded, or a 
                                       connection to the elasticsearch server
                                       was not established."}}
        :return [Recipe]
        (get-recipe-list))

      (POST* "/" []
        :description "Adds a new recipe to your growing collection."
        :body [recipe Recipe]
        :responses {201 {:schema {:id schema/Str :recipe Recipe}
                         :description "The recipe was successfully added to
                                       the database."}
                    500 {:schema {:error schema/Str :recipe Recipe}
                         :description "An error occurred while trying to save 
                                       the recipe to the server."}}
        (create-recipe recipe))

      (context "/:id" [id]
        (GET* "/" []
          :description "Returns the recipe for the given `id`"
          :responses {404 {:schema {:error schema/Str}
                           :description "The recipe for that given id
                                         could not be found."}}
          :return Recipe
          (get-recipe id))

        (PUT* "/" []
          :description "Update an existing recipe."
          :body [recipe Recipe]
          :responses {201 {:schema {:id schema/Str :recipe Recipe}
                           :description "The recipe was successfully added to
                                         the database."}
                      500 {:schema {:error schema/Str :recipe Recipe}
                           :description "An error occurred while trying to save 
                                         the recipe to the server."}}
          (ok {:message (str "Updading " id " recipe")}))

        (DELETE* "/" []
          :description "Remove a recipe from the server."
          (ok {:message (str "Deleting " id " recipe")}))))

    (route/not-found
      (not-found {:message "Invalid URI"}))))

(validate app)
