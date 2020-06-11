(ns documentation.spirit-walkthrough.step-2
  (:use hara.test)
  (:require [spirit.core.datomic :as datomic]
            [spirit.core.datomic.api.select :as select]
            [datomic.api :as raw]))

[[:chapter {:title "Step Two"}]]

[[:section {:title "Enums"}]]

"There is an intrinsic concept of enums in datomic, seen in the website's [schema documentation](http://docs.datomic.com/schema.html).
`spirit` just takes this explicitly and incorporates it into the schema. We see that there is a new entry for the schema - the `account/type`
attribute which is of type :enum:"

(def schema-2
  {:account {:user     [{:required true
                         :unique :value}]
             :password [{:required true
                         :restrict ["password needs an integer to be in the string"
                                    #(re-find #"\d" %)]}]
             :credits  [{:type :long
                         :default 0}]
             :type     [{:type :enum        ;; (2)
                         :default :free
                         :enum {:ns :account.type
                                :values #{:admin :free :paid}}}]}})

"Some comments regarding this particular definition compared to the one in Step One:

  1. Note that instead of using `:account/<attr>` to specify attributes in a flat hashmap, we can just nest the
attributes under the `:account` namespace. This allows for much better readability and saves a couple of characters.
  * The `:enum` type is a special `:ref` type that is defined [here](http://docs.datomic.com/schema.html#sec-3). The
library provides it easy to install and manage them. We put them under a common namespace (`:account.type`) and give
them allowed values `#{:admin :free :paid}`"


(facts
  [[:section {:title "Updating"}]]

  "Lets connect to a brand new database and insert some data. Note the different ways of nesting data. There is
a correspondence between a nested hashmap and a flat hashmap having keys representing data-paths. `spirit` takes
advantage of this correspondence to give allow users more semantic freedom of how to represent their data:"

  (def ds (datomic/connect!
           {:uri "datomic:mem://spirit-example-step-2"
            :schema schema-2
            :options {:reset-db true
                      :install-schema true}}))

  (datomic/insert! ds {:account {:user "spirit1"
                             :password "hello1"}
                   :account/type :paid})
  (datomic/insert! ds [{:account {:password "hello2"
                              :type :account.type/admin}
                    :account/user "spirit2"}
                   {:account {:user "spirit3"
                              :credits 1000}
                    :account/password "hello3"}])

  "Lets take a look at all the `:admin` accounts:"

  (datomic/select ds {:account/type :admin})
  => #{{:account {:user "spirit2", :password "hello2", :credits 0, :type :admin}}}

  "We can make `spirit1` into an :admin and then do another listing:"

  (datomic/update! ds {:account/user "spirit1"} {:account/type :admin})
  (datomic/select ds {:account/type :admin})
  => #{{:account {:user "spirit1", :password "hello1", :credits 0, :type :admin}}
       {:account {:user "spirit2", :password "hello2", :credits 0, :type :admin}}}

  "If we attempt to add an value of `:account.type/<value>` that is not listed, an exception will be thrown:"

  (datomic/insert! ds {:account {:user "spirit4"
                             :password "hello4"
                             :type :vip}})
  => throws

  [[:section {:title "Selection"}]]

  "There are many ways of selecting data. We have already seen the basics:"

  (datomic/select ds {:account/credits 1000} :first)
  => {:account {:user "spirit3", :password "hello3", :credits 1000, :type :free}}

  "Adding a `:pull` model will filter out selection options:"

  (datomic/select ds {:account/type :free} :first
              :pull {:account {:credits :unchecked
                                 :type :unchecked}})
  => {:account {:user "spirit3", :password "hello3"}}

  "Another feature is that a list can be used to input an expression. In the examples below, the `'(> ? 10)` predicate
  acts as the `spirit` equivalent of using an actual predicate `#(> % 10)`. If there is no `?`, it is
  assumed that the first argument is `?`.  Note that all the three queries below give the same results:"

  (datomic/select ds {:account/credits '(> 10)} :first)
  => {:account {:user "spirit3", :password "hello3", :credits 1000, :type :free}}

  (datomic/select ds {:account/credits '(> ? 10)} :first)
  => {:account {:user "spirit3", :password "hello3", :credits 1000, :type :free}}

  (datomic/select ds {:account/credits '(< 10 ?)} :first)
  => {:account {:user "spirit3", :password "hello3", :credits 1000, :type :free}})


(facts
  [[:section {:title "Java"}]]

  "Java expressions can also be used because these functions are executed at the transactor end:"

  (datomic/select ds {:account/user '(.contains "2")} :first)
  => {:account {:user "spirit2", :password "hello2", :credits 0, :type :admin}}

  (datomic/select ds {:account/user '(.contains ? "2")} :first)
  => {:account {:user "spirit2", :password "hello2", :credits 0, :type :admin}}

  (datomic/select ds {:account/user '(.contains "spirit222" ?)} :first)
  => {:account {:user "spirit2", :password "hello2", :credits 0, :type :admin}})
