^{:cljs
  '(ns savant.test.store.memory-test
     (:require [buster-cljs.core :refer [is]]
               [savant.test.store-spec
                :refer
                [IEventStreamReload
                 get-event-store-constructor-tests
                 event-store-protocol-tests
                 event-stream-protocol-tests]]
               [savant.store.memory :as m])
     (:require-macros [buster-cljs.macros
                       :refer [initialize-buster deftest describe]]))}
(ns savant.test.store.memory-test
  (:require [clojure.test :refer :all]
            [buster-cljs.clojure :refer [describe]]
            [savant.test.store-spec :refer :all]
            [savant.store.memory])
  (:import [savant.store.memory MemoryEventStream]))

#_(:cljs
   (initialize-buster))

(extend-protocol IEventStreamReload
  savant.store.memory.MemoryEventStream
  (-reset-stream [stream]
    (reset! (.-state-atom stream) {})))

(deftest memory-event-store-tests
  (describe "testing memory event store:"
    (let [ns ^{:cljs '(js* "savant.store.memory")}
             'savant.store.memory
          valid-opts {:name "foo"}
          invalid-opts {:invalid "option"}]
      (get-event-store-constructor-tests ns valid-opts invalid-opts)
      (event-store-protocol-tests ns valid-opts)
      (event-stream-protocol-tests ns valid-opts))))
