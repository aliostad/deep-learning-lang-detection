(ns adi-example.s1
  (:require [ring.util.response :refer [response]]
            [ring.middleware.session :refer [wrap-session]]
            [compojure.core :refer [defroutes GET]]
            [compojure.route :refer [resources]]
            [ribol.core :refer [manage on]]
            [cheshire.core :as json]
            [adi.core :refer :all :as adi]
            [org.httpkit.server :refer [run-server]]
            [vraja.http-kit :refer [with-clj-channel with-js-channel]]
            [clojure.core.async :refer [<! >! put! close! go]]))

(def DEFAULT_SCHEMA
  {:blog {:name [{:required true}]
          :id    [{:type :long}]
          :owner [{:type :ref
                   :ref {:ns :user
                         :rval :blog_owner_of}}]
          :authors [{:type :ref
                     :cardinality :many
                     :ref {:ns :user
                           :rval :blog_author_of}}]}
   :post {:blog [{:type :ref
                  :ref {:ns :blog}}]
          :author [{:type :ref
                    :ref {:ns :user}}]
          :tags [{:cardinality :many}]
          :text [{}]
          :title [{:required true}]}
   :comment {:post [{:type :ref
                     :ref {:ns :post}}]
             :text [{:required true}]
             :user [{:type :ref
                     :ref {:ns :user}}]}
   :user {:name [{:required true}]}})


(def student-schema
  {:class   {:type    [{:type :keyword}]
             :name    [{:type :string}]
             :accelerated [{:type :boolean}]
             :teacher [{:type :ref                  ;; <- Note that refs allow a reverse
                        :ref  {:ns   :teacher       ;; look-up to be defined to allow for more
                               :rval :teaches}}]}   ;; natural expression. In this case,
   :teacher {:name     [{:type :string}]            ;; we say that every `class` has a `teacher`
             :canTeach [{:type :keyword             ;; so the reverse will be defined as a
                         :cardinality :many}]       ;; a `teacher` `teaches` a class
             :pets     [{:type :keyword
                         :cardinality :many}]}
   :student {:name     [{:type :string}]
             :siblings [{:type :long}]
             :classes    [{:type :ref
                         :ref   {:ns   :class
                                 :rval :students}   ;; Same with students
                           :cardinality :many}]}})

(def student-data                      ;;; Lets See....
  [{:db/id (iid :Maths)
    :class {:type :maths             ;;; There's Math. The most important subject
            :name "Maths"            ;;; We will be giving all the classes ids
            :accelerated true}}      ;;; for easier reference

    {:db/id (iid :Science)           ;;; Lets add science
     :class {:type :science
             :name "Science"}}

    {:student {:name "Ivan"          ;;; And then Ivan, who does English, Science and Sports
           :siblings 2
           :classes #{{:+/db/id (iid :EnglishA)}
                      {:+/db/id (iid :Science)}
                      {:+/db/id (iid :Sports)}}}}

    {:teacher {:name "Mr. Blair"                       ;; Here's Mr Blair
               :teaches #{{:+/db/id (iid :Art)
                           :type :art                  ;; He teaches Art
                           :name "Art"
                           :accelerated true}
                          {:+/db/id (iid :Science)}}   ;; He also teaches Science
               :canTeach #{:maths :science}
               :pets    #{:fish :bird}}}               ;; And a fish and a bird

    {:teacher {:name "Mr. Carpenter"                   ;; This is Mr Carpenter
               :canTeach #{:sports :maths}
               :pets    #{:dog :fish :bird}
               :teaches #{{:+/db/id (iid :Sports)      ;; He teaches sports
                           :type :sports
                           :name "Sports"
                           :accelerated false
                           :students #{{:name "Jack"   ;; There's Jack
                                        :siblings 4    ;; Who is also in EnglishB and Maths
                                        :classes #{{:+/db/id (iid :EnglishB)
                                                    :students {:name  "Anna"  ;; There's also Anna in the class
                                                               :siblings 1
                                                               :classes #{{:+/db/id (iid :Art)}}}}
                                                                          {:+/db/id (iid :Maths)}}}}}
                          {:+/db/id (iid :EnglishB)
                           :type :english             ;; Now we revisit English B
                           :name "English B"          ;;  Here are all the additional students
                           :students #{{:name    "Charlie"
                                        :siblings 3
                                        :classes  #{{:+/db/id (iid :Art)}}}
                                       {:name    "Francis"
                                        :siblings 0
                                        :classes #{{:+/db/id (iid :Art)}
                                                   {:+/db/id (iid :Maths)}}}
                                       {:name    "Harry"
                                        :siblings 2
                                        :classes #{{:+/db/id (iid :Art)}
                                                   {:+/db/id (iid :Science)}
                                                   {:+/db/id (iid :Maths)}}}}}}}}

    {:db/id (iid :EnglishA)       ;; What about Engilsh A ?
     :class {:type :english
             :name "English A"
             :teacher {:name "Mr. Anderson" ;; Mr Anderson is the teacher
                       :teaches  {:+/db/id (iid :Maths)} ;; He also takes Maths
                       :canTeach :maths
                       :pets     :dog}
             :students #{{:name "Bobby"   ;; And the students are listed
                          :siblings 2
                          :classes  {:+/db/id (iid :Maths)}}
                         {:name "David"
                          :siblings 5
                          :classes #{{:+/db/id (iid :Science)}
                                     {:+/db/id (iid :Maths)}}}
                         {:name "Erin"
                          :siblings 1
                          :classes #{{:+/db/id (iid :Art)}}}
                         {:name "Kelly"
                          :siblings 0
                          :classes #{{:+/db/id (iid :Science)}
                                     {:+/db/id (iid :Maths)}}}}}}])



(def DATA
  {:user {:name "zcaudate"
          :blog_owner_of
          #{{:name "Something Same"
             :id 3
             :authors [{:+/db/id (adi/iid :Adam)
                        :name "Adam"} {:name "Bill"}]
             :posts [{:title "How To Flex Data" :tags #{"computing"}}
                     {:title "Cats and Dogs" :tags #{"pets"}
                      :comments {:text "This is a great article"
                                 :user (adi/iid :Adam)}}
                     {:title "How To Flex Data"}]}}}})




(def URI "datomic:mem://adi-example-s1")
(def ENV (connect-env! URI student-schema true))
;;(def ENV (connect-env! URI DEFAULT_SCHEMA true))
(insert! ENV student-data)

(comment
  (reset! (:model STATE)  {:hello "a" :hoeuo (fn [] nil)})
  )

;;(select ENV {:blog/owner '_})
(def STATE
  {:uri URI
   :env (atom ENV)
   :schema (atom (-> ENV :schema :tree))
   :model (atom nil)
   :access (atom nil)
   :return (atom nil)})



(def METHODS
  {:insert! insert!
   :delete! delete!
   :update! update!
   :retract! retract!
   :select select
   :update-in! update-in!
   :delete-in! delete-in!
   :retract-in! retract-in!})

(comment
  {:op-type "setup"
   :resource #{"schema" "model" "access"}
   :op #{"set" "clear" "return"}
   }
  (reset! (:schema STATE) {:account {:user [{}]}})

  )

(defn parse-clj-arg [s]
  (try (read-string s)
       (catch Throwable t
         #_(.printStackTrace t))))

(defn parse-js-arg [s]
  (try (json/parse-string s)
       (catch Throwable t
         #_(.printStackTrace t))))

(defn parse-arg [msg s]
  (condp = (get msg "lang")
    "clj"  (parse-clj-arg s)
    "js"   (parse-js-arg s)))

(defn handle-setup-request [msg]
  (let [op (get msg "op")
        resource (get msg "resource")
        res (STATE (keyword resource))
        arg (parse-clj-arg (get msg "arg"))]
    (cond (and (= op "set") (= resource "schema"))
          (let [env (connect-env! URI arg true)]
            (reset! (:env STATE) env)
            (reset! (:schema STATE) (-> env :schema :tree))
            @(:schema STATE))

          (= op "set")
          (do (reset! res arg)
              @res)

          (= op "view")
          @res

          (= op "clear")
          (do (reset! res nil)
              @res))))

(defn handle-standard-request [msg]
  #_(println "STANDARD REQUEST:" (get msg "op") (get msg "args"))
  (let [op    (get msg "op")
        nargs (get msg "nargs")
        args  (->> (get msg "args")
                   (map #(parse-arg msg %))
                   (take nargs))

        f     (METHODS (keyword op))
        res (apply f @(:env STATE)
                   (concat args [:transact :full]
                           (if (get msg "ids")
                             [:ids])
                           (if-let [ret @(:return STATE)]
                             [:return ret])
                           (if-let [acc @(:access STATE)]
                             [:access acc])
                           (if-let [mod @(:model STATE)]
                             [:model mod])))]
    (println "STANDARD REQUEST:" res)
    (if (not= op "insert!")
      res
      {:message "DONE"})))

(defn ws-handler [req]
  (let [req (assoc req :ws-session (atom {}))]
    (with-js-channel req ws
      (go
       (loop []
         (when-let [msg (<! ws)]
           (let [op-type (get msg "op-type")
                 output
                 (try
                   (manage
                    (cond
                     (= op-type "test") {:stuff (get msg "return")}
                     (= op-type "setup") (handle-setup-request msg)
                     (= op-type "standard") (handle-standard-request msg))
                    (on :data-not-in-schema [nsv]
                        {:error (str nsv " is not in the schema")}))
                   (catch clojure.lang.ExceptionInfo e
                     (ex-data e))
                   (catch Throwable t
                     (.printStackTrace t)))]
             (if output
               (>! ws output)
               (>! ws {}))
             (recur))))))))

(defroutes app
  (GET "/ws" [] (wrap-session ws-handler))
  (resources "/"))

(serv)
(def serv (run-server app {:port 8088}))



(comment

  )
