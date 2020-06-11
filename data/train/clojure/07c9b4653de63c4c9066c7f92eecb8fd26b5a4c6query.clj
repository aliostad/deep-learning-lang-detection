(ns travesedo.query
  "Manages query execution for both simple and AQL queries. Most of the
  queries allow the :batch-size k-v in the :payload. If used and there are more
  documents than batch size, the server will return a :cursor-id. Use
  (next-batch) to get the remainer."
  (:require [travesedo.common :refer :all]
            [clojure.set :as cset]))

(defn calc-cursor-base 
  "Generates the root resource for cursor activities.
  Similar to  /_db/testing/_api/curor"
  [ctx]
  (derive-resource ctx "/cursor") )

(defn map-payload-keys
  "Converts idomatic Clojure keyword to ArangoDB camelcase for :payload values."
  [{payload :payload :as ctx}]
  (let [mapped-payload (cset/rename-keys payload {:batch-size "batchSize", 
                                                  :bind-vars "bindVars"} )]
    (assoc ctx :payload mapped-payload)))

(defn map-response-keys [response]
  (cset/rename-keys response {:hasMore :has-more :id :cursor-id}))

(defn- manage-cursor 
  "Executes the call allowing the method to drive targeted resource."
  [ctx method]
  (map-response-keys (call-arango method 
                                  (str (calc-cursor-base ctx) 
                                       "/" 
                                       (:cursor-id ctx)) 
                                  (map-payload-keys ctx))))

(defn next-batch
  "Finds the next batch for a :cursor-id. Returns 404, if the cursor is 
  exhausted."
  [ctx]
  (manage-cursor ctx :put))

(defn delete
  "Deletes the cursor designated at :cursor-id."
  [ctx]
  (manage-cursor ctx :delete))

(defn call-simple
  "Helper function to coordinate mapping task."
  [ctx resource]
  (map-response-keys (call-arango :put 
                                  (derive-resource ctx resource) 
                                  (map-payload-keys ctx))))

(defn return-all
  "Returns all of the docs for a collection.
  :payload {:collection :skip :limit}. :skip and :limit are optional."
  [ctx]
  (call-simple ctx "/simple/all"))

(defn by-example
  "Queries a collection using an example document as the payload."
  [ctx]
  (call-simple ctx "/simple/by-example"))

(defn by-keys 
  "Queries for a collection of documents by a list of keys. 

   You must provide a :collection key with either a string or keyword for the 
   collection the keys go with. The :payload value is a simple map 
   {:keys [\"_k\"]}

   Example input: (def ctx {....standard config.....
                            :collection :persons, 
                            :payload {:keys [\"somthing1\"]} 

   The output for a successful request is a map with three keys. 
   :documents which is a list of documents with matching keys. Missing keys
   are ignored.
   :error true/false if successful call,
   :code an int of the response code.

   Example output:
   {:error false, :code 200, :documents [{:_id person/123123, ....}]"
  [ctx]
  (call-simple 
    (assoc-in ctx [:payload :collection] (:collection ctx)) 
    "/simple/lookup-by-keys"))

(defn remove-by-keys
  "Deletes from a collection of documents by a list of keys. 

   You must provide a :collection key with either a string or keyword for the 
   collection the keys go with. The :payload value is a simple map 
   {:keys [\"_k\"]}

   Example input: (def ctx {....standard config.....
                            :collection :persons, 
                            :payload {:keys [\"somthing1\"]} 

   The output for a successful deletion has four keys.
   :removed is the number of deleted entries.
   :ignored is the number of keys that didn't match.
   :error true/false if error occured.
   :code is the http code for the operation.

   Example output:
   {:error false, :code 200, :removed 10, :ignored 3]"
  [ctx]
  (call-simple 
    (assoc-in ctx [:payload :collection] (:collection ctx)) 
    "/simple/remove-by-keys"))

(defn by-example-first
  "Queries a collection by example, returning the first document that matches."
  [ctx]
  (call-simple ctx "/simple/first-example"))

(defn by-example-hash-index
  "Queries for documents by example using a hash index."
  [ctx]
  (call-simple ctx "/simple/by-example-hash"))

(defn by-example-skiplist-index 
  "This will find all documents matching a given example, using the specified 
  skiplist index."
  [ctx]
  (call-simple ctx "/simple/by-example-skiplist"))

(defn by-example-bitarray-index
  "This will find all documents matching a given example, using the specified 
  bitarray index."
  [ctx]
  (call-simple ctx "/simple/by-example-bitarray"))

(defn by-condition-skiplist
  "This will find all documents matching a given condition, using the specified
  skiplist index."
  [ctx]
  (call-simple ctx "/simple/by-condition-skiplist"))

(defn by-condition-bitarray
  "This will find all documents matching a given condition, using the specified 
  skiplist index."
  [ctx]
  (call-simple ctx "/simple/by-condition-bitarray"))

(defn any
  "Returns a random document from a collection" 
  [ctx]
  (call-simple ctx "/simple/any"))

(defn within-range
  "Finds all documents within a given range. A skip-list index is required."
  [ctx]
  (call-simple ctx "/simple/range"))

(defn near
  "The default will find at most 100 documents near the given coordinate.
  The returned list  is sorted according to the distance, with the nearest
  document being first in the list. If  there are near documents of equal
  distance, documents are chosen randomly from this  set until the limit is
  reached."
  [ctx]
  (call-simple ctx "/simple/near"))

(defn within 
  "This will find all documents within a given radius around the
  coordinate (latitude, longitude). The returned list is sorted by distance.
  
  In order to use the within operator, a geo index must be defined for the
  collection. This index also defines which attribute holds the coordinates
  for the document. If you have more then one geo-spatial index, you can
  use the geo field to select a particular index."
  [ctx]
  (call-simple ctx "/simple/within"))

(defn fulltext
  "This will find all documents from the collection that match the fulltext
  query specified in query.
  
  In order to use the fulltext operator, a fulltext index must be defined for
  the collection and the specified attribute."
  [ctx]
  (call-simple ctx "/simple/fulltext"))

(defn remove-by-example 
  "This will find all documents in the collection that match the specified
  example object. Supports :wait-for-sync."
  [ctx]
  (call-simple ctx "/simple/remove-by-example"))

(defn replace-by-example
  "This will find all documents in the collection that match the specified
  example object, and replace the entire document body with the new
  value specified. Note that document meta-attributes such as _id,
  _key, _from, _to etc. cannot be replaced. Supports :wait-for-sync"
  [ctx]
  (call-simple ctx "/simple/replace-by-example"))

(defn update-by-example 
  "This will find all documents in the collection that match the specified
  example object, and partially update the document body with the new
  value specified. Note that document meta-attributes such as _id, _key,
  _from, _to etc. cannot be replaced."
  [ctx]
  (call-simple ctx "/simple/update-by-example"))

(defn first-nth
  "This will return the first document(s) from the collection, in the order
  of insertion/update time. When the count argument is supplied, the result
  will be a list of documents, with the \"oldest\" document being first in the
  result list. If the count argument is not supplied, the result is the 
  \"oldest\" document of the collection, or null if the collection is empty."
  [ctx]
  (call-simple ctx "/simple/first"))

(defn last-nth
  "This will return the last documents from the collection, in the order of
  insertion/update time. When the count argument is supplied, the result
  will be a list of documents, with the \"latest\" document being first in the
  result list."
  [ctx]
  (call-simple ctx "/simple/last"))

(defn aql-query
  "Execute a query against ArangoDB. The query map should be in the :payload 
  slot in the ctx.
  The query map can have the following form:
  {:query \"String of AQL\",
  :count :true/:false,
  :batch-size number,
  :ttl (time to live for cursor in seconds),
  :bind-vars a map of k-v pairs,
  :options (k-v list of options)}
  Everything but :query is optional.
  
  Upon successful execution, the response will look like this
  {:error false,
  :code http_code_number,
  :result [{...}],
  :has-more true/false,
  :count total_number_of_docs,
  :cursor-id \"cursor id for future calls\",
  :extra {...}}"
  [ctx]
  (map-response-keys (call-arango :post 
                                  (calc-cursor-base ctx) 
                                  (map-payload-keys ctx))))

(defn aql-query-all
  "Executes a query and reads all of the results into the :result field. This 
  is presently an eager operation. Can return a partial load if the server 
  failed part way through."
  [ctx]
  (let [q (aql-query ctx)
        clean-ctx (conj (dissoc ctx :query) (select-keys q [:cursor-id]))]
    (loop [continue? (:has-more q) res (:result q)]
      (if  continue?
        (let [nb (next-batch clean-ctx)]
          (recur (:has-more nb) (conj (:result nb) res)))
        (conj {:result (vec (flatten res)), :has-more false, 
               :count (count res)} (select-keys q [:error :code]))))))


(defn parse-aql-query  
  "Like aql-query but only checks the query for syntaxic correctness. 
  Does not execute the query."
  [ctx]
  (map-response-keys (call-arango :post (derive-resource ctx "/query")
                                  (map-payload-keys ctx))))

