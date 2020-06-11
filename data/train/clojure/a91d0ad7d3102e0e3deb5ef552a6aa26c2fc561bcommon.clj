(ns konserver.model.common
  "Multimethod declarations for model operations"
  (:refer-clojure :exclude [list]))

(defn- dispatch
  "Common dispatch function for the model operations."
  [db res-id & data]
  (:type res-id))

(defmulti list
  "Lists resources in a collection resource. Extra arguments in the form of
   maps can be passed, each representing conditions for the attributes. The
   result is then limitied to only the resources whose attributes matches all
   the conditions in at least one of the maps."
  dispatch)

(defmulti add
  "Adds a resource to a collection resource."
  {:arglists '([db res-id data editor])}
  dispatch)

(defmulti exists?
  "Checks whether an entity resource exists."
  dispatch)

(defmulti retrieve
  "Retrieves an entity resource."
  dispatch)

(defmulti update
  "Updates an entity resource. data is a map with the updated attributes."
  {:arglists '([db res-id updates editor])}
  dispatch)

(defmulti delete
  "Deletes an entity resource."
  dispatch)