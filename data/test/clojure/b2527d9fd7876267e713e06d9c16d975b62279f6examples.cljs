(ns firelisp.tests.examples
  (:require
    [devcards.core :refer-macros [deftest]]
    [firelisp.common :refer [append]]
    [firelisp.db :as db :include-macros true]
    [firelisp.compile :as c]
    [firelisp.core :as f :refer [compile] :refer-macros [at]])
  (:require-macros
    [cljs.test :refer [is testing]]))

(defn log [s]
  (cljs.pprint/pprint s))


(deftest examples

  (testing "auth"

    (let [db (atom (-> db/blank

                       (db/macro role [uid]
                                 "Get role for user"
                                 '(get-in prev-root ["users" ~uid "role"]))

                       (db/macro has-permission? [uid action]
                                 '(= true (get-in prev-root ["roles" (role ~uid) "permissions" ~action])))

                       (db/rules

                         {"users" {'uid {"role" {:write (or (and (nil? next-data) (= $uid auth.uid))
                                                            (has-permission? auth.uid "manage-roles"))}}}
                          "roles" {'role {"permissions" {'permission {:validate (boolean? next-data)}}}}}

                         #_'{["users" uid "role"] {:write '()}}



                         (at ["users" uid "role"]
                             {:write (or (and (nil? next-data) (= $uid auth.uid))
                                         (has-permission? auth.uid "manage-roles"))})

                         (at ["roles" role "permissions" permission]
                             {:validate (boolean? next-data)}))

                       (db/set! "/" {"roles" {"admin"  {:permissions {:read         true
                                                                      :write        true
                                                                      :manage-roles true}}
                                              "editor" {:permissions {:read  true
                                                                      :write true}}
                                              "member" {:permissions {:read true}}}
                                     "users" {:el-hefe {:role "admin"}
                                              :franco  {:role "member"}}})))]


      (is (thrown? js/Error (-> (db/auth! @db {:uid "franco"})
                                (db/set "users/franco/role" "admin")))
          "Member cannot set own role")

      (is (-> (db/auth! @db {:uid "el-hefe"})
              (db/set "users/franco/role" "admin"))
          "Admin can set roles")
      (do (-> (db/auth! @db {:uid "franco"})
              (db/set "users/franco/role" nil))
          "Member can delete own role")
      (is (thrown? js/Error (-> (db/auth! @db {:uid "my-uid"})
                                (db/set "users/my-uid/roles/x" true)))
          "Role must exist")
      (is (thrown? js/Error (-> (db/auth! @db {:uid "my-uid"})
                                (db/set "users/my-uid/roles/editor" "true")))
          "Role must be boolean")

      ))

  (testing "Read-example"

    (let [db (-> db/blank
                 (db/rules (at ["orders"]
                               {:read (or (not= nil (get-in root ["technicians" auth.uid]))
                                          (= "server" auth.uid))})))]

      (is (false? (db/read? db "/orders/")))

      (is (true? (->
                   (db/auth! db {:uid "server"})
                   (db/read? "/orders/"))))

      (is (true? (-> db
                     (db/set! "/technicians/123" true)
                     (db/auth! {:uid "123"})
                     (db/read? "/orders/"))))))


  (testing "Authenticated Chat"

    (let [db (atom (-> db/blank

                       (db/macro signed-in? []
                                 '(not= auth nil))

                       (db/macro name-string? []
                                 '(and (string? next-data)
                                       (between (length next-data) 0 20)))

                       (db/macro room-name [id]
                                 '(get-in prev-root ["room_names" ~id]))

                       (db/macro room-member? [room-id]
                                 '(and (signed-in?)
                                       (exists? (get-in prev-root ["members" ~room-id auth.uid]))))
                       (db/rules (at []
                                     {:read true}

                                     (at ["room_names"]
                                         {:validate object?}
                                         (at "$name"
                                             {:validate string?}))

                                     (at ["members" roomId]
                                         {:read (room-member? $roomId)}
                                         (at "$user_id"
                                             {:validate name-string?
                                              :write    (= auth.uid $user_id)
                                              :update   (unchanged?)}))

                                     (at ["messages" roomId]
                                         {:read     (room-member? $roomId)
                                          :validate (exists? (room-name $roomId))}
                                         (at [message-id]
                                             {:write    (= (get-in next-root ["members" $roomId auth.uid])
                                                           (get next-data "name"))
                                              :update   false
                                              :delete   false
                                              :validate {"name"      name-string?
                                                         "message"   (and (string? next-data)
                                                                          (between (length next-data) 0 50))
                                                         "timestamp" (= next-data now)}}))))
                       (db/auth! {:uid "bob"})))]

      (is (swap! db db/set! "/room_names/y" "my-great-room"))

      (is (swap! db db/set "members/y/bob" "Bob"))
      (is (swap! db db/set "messages/y/1" {:name      "Bob"
                                           :message   "My message"
                                           :timestamp {".sv" "timestamp"}}))

      ))

  (testing "Throttle"

    ; "From [this example by katowulf,](http://jsfiddle.net/firebase/VBmA5/) 'throttle messages to no more than one every 5,000 milliseconds'"

    (let [db (atom (-> db/blank
                       (db/rules (at []
                                     {"last_message/$user"
                                      {:write  (= $user auth.uid)
                                       :create (= next-data now)
                                       :update (and (= next-data now)
                                                    (> next-data (+ 5000 prev-data)))
                                       :delete false}

                                      "messages/$message-id"
                                      {:write    (= (get next-data "sender") auth.uid)
                                       :validate {:timestamp (= next-data (get-in next-root ["last_message" auth.uid]))
                                                  :sender    true
                                                  :message   (and (string? next-data)
                                                                  (< (length next-data) 500))}}
                                      "what/$ever"
                                      {:write (= next-data (child next-root auth.uid auth.uid))}}))
                       (db/auth! {:uid "frank"})))]

      (is (swap! db db/set "last_message/frank" {".sv" "timestamp"})
          "Write timestamp to blank db")

      (is (false? (db/set? @db "last_message/frank" {:last_message {:frank (- (.now js/Date) 4700)}} {".sv" "timestamp"}))
          "false: Write another timestamp less than 5000 ms after the previous")


      (is (-> @db
              (db/set! "/" {:last_message {:frank (- (.now js/Date) 5300)}})
              (db/set? "last_message/frank" {".sv" "timestamp"}))
          "Write another timestamp more than 5000 ms after the previous")

      (is (not (-> @db
                   (db/set! "/" {:last_message {:frank (.now js/Date)}})
                   (db/set? "last_message/frank" nil)))
          "false: Delete a timestamp")

      (is
        (-> @db
            (db/set! "/" {})
            (db/update? "/" {"last_message/frank" {".sv" "timestamp"}
                             "messages/1"         {:timestamp {".sv" "timestamp"}
                                                   :sender    "frank"
                                                   :message   "Hello, there!"}}))
        "Write message")

      (is (-> @db
              (db/set! "/" {:last_message {:frank 100}
                            :messages     {"1" {:timestamp 100
                                                :sender    "frank"
                                                :message   "Hello, there!"}}})

              (db/update? "/" {"last_message/frank" {".sv" "timestamp"}
                               "messages/2"         {:timestamp {".sv" "timestamp"}
                                                     :sender    "frank"
                                                     :message   "Hello?"}}))
          "Write second message long into the future")


      (is (false? (-> @db
                      (db/set! "/" {:last_message {:frank (- (.now js/Date) 100)}
                                    :messages     {"1" {:timestamp (- (.now js/Date) 100)
                                                        :sender    "frank"
                                                        :message   "Hello, there!"}}})
                      (db/update? "/" {"last_message/frank" {".sv" "timestamp"}
                                       "messages/2"         {:timestamp {".sv" "timestamp"}
                                                             :sender    "frank"
                                                             :message   "Hello?"}})))

          "Write second message almost immediately")))

  (testing "Timestamps"
    (let [db (-> db/blank
                 (db/rules (at [] {:write (= next-data now)})))]
      (is (true? (db/set? db "/" {:.sv "timestamp"})))
      (is (true? (db/set? db "/" (.now js/Date))))
      (is (false? (db/set? db "/" (dec (.now js/Date))))))


    (let [Post '{:message  string?
                 :modified (= next-data now)
                 :created  (= next-data (if (new?)
                                          now
                                          prev-data))}
          db (-> db/blank
                 (db/rules (at ["posts" id]
                               {:read     true
                                :write    true
                                :validate ~Post})))]

      (is (db/set? db "/posts/123" {:message  ""
                                    :modified {:.sv "timestamp"}
                                    :created  {:.sv "timestamp"}}))

      (is (false? (db/set? db "/posts/123" {:message  ""
                                            :modified (- (.now js/Date) 100)
                                            :created  (- (.now js/Date) 100)})))


      (let [DB (db/set! db "/" {:posts {"123" {:message  ""
                                               :created  (dec (.now js/Date))
                                               :modified (dec (.now js/Date))}}})]

        (is (db/set DB "/posts/123/modified" {:.sv "timestamp"}))

        (doseq [not-now [(dec (.now js/Date)) (+ 10 (.now js/Date))]]
          (is (false? (db/set? DB "/posts/123/modified" not-now))))

        (is (false? (db/set? DB "/posts/123/created" {:.sv "timestamp"})))))))