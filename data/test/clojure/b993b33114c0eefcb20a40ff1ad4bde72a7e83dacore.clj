(ns mosql.core
  "A simple wrapper around clojure.java.jdbc that provides a monadic (either)
  interface.
  
  The idea behind this library is to provide a monadic interface around sql dml
  operations that could be chained.
  
  It is and experiment to manage hand made sql but facilitating common
  operations while it is flexible enough to manage special cases."
  
  (:require [cats.core :as m :refer
             [fmap bind return pure
              unless ap ap-> ap->> as-ap-> curry lift-m lift-a
              ->= ->>= <$> <*> <=< =<< >=> >> >>=
              curry-lift-m 
              extract]]
            [cats.monad.either :as e :refer 
             [branch branch-left branch-right either? first-left first-right
              left left? right right? try-either]]
            [cats.context :as ctx :refer [with-context]]
            ;[cats.builtin]
            [clojure.java.jdbc :as j]
            [mosql.fun :refer :all]
            [mosql.generators :as g :refer [gen-insert gen-update]]))

(defn insert!
  ([conn table data]
   (insert! {} conn table data))
  ([options conn table data]
   (let [new-id (:new-id options)
         fres
         (try-either
           (let [sql (gen-insert options table data)
                  res (j/execute! conn sql)]
             (:generated_key res)))]
     (if (right? fres)
       (right (if new-id
                (assoc data new-id (extract fres))
                data))
       (left {:error (extract fres)
              :operation :insert!
              :table table
              :data data})))))

(defn update!
  ([conn table ids data]
   (update! {} conn table ids data))
  ([options conn table ids data]
   nil))
