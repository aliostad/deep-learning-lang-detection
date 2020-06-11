(ns documentation.hara-event
  (:use hara.test)
  (:require [hara.event :refer :all]))

[[:chapter {:title "Introduction"}]]

"[hara.event](https://github.com/zcaudate/hara/blob/master/src/hara/event.clj) aims to provide more loosely coupled code through two mechanisms:

- a signalling framework for normal operations
- a conditional restart framework for abnormal operations

The two paradigms have been combined into a single library because they share a number of similarities in terms of both the communication of system information as well as the need for passive listener. However, abnormal operations are alot trickier to resolve and requires more attention to detail."

[[:section {:title "Installation"}]]

"
Add to `project.clj` dependencies:

    [im.chit/hara.event \"{{PROJECT.version}}\"]
"

[[:section {:title "Other Libraries"}]]

"
There are currently three other conditional restart libraries for clojure:

- [errorkit](https://github.com/richhickey/clojure-contrib/blob/master/src/main/clojure/clojure/contrib/error_kit.clj)
- [swell](https://github.com/hugoduncan/swell) 
- [conditions](https://github.com/bwo/conditions) works with [slingshot](https://github.com/scgilardi/slingshot).
"

[[:chapter {:title "Index"}]]

[[:api {:title "Signal API"
        :namespace "hara.event"
        :display #{:tags}
        :only ["deflistener"
               "signal"
               "clear-listeners"
               "install-listener"
               "list-listeners"
               "uninstall-listener"
               "with-temp-listener"]}]]

[[:api {:title "Conditional API"
        :namespace "hara.event"
        :display #{:tags}
        :only ["choose"
               "continue"
               "default"
               "escalate"
               "fail"
               "manage"
               "option"
               "raise"]}]]

[[:chapter {:title "Signals"}]]

"`hara.event` contains a flexible signaling and listener framework. This allows for decoupling of side-effecting functions. In normal program flow, there may be instances where an event in a system requires additional processing that is adjunct to the core:

- logging
- printing on screen
- sending an email
- creating audio/visual effects
- writing to a queue, database or cache

The signalling framework allows for the specification of signals type. This enables loose coupling between the core and libraries providing functionality for side effects, enabling the most flexible implementation for signaling. As all information surrounding a signal is represented using data, listeners that provide actual resolution can be attached and detached without too much effort. In this way the core becomes lighter and is stripped of dependencies."

[[:image {:src "img/hara_event/signal_pathway.png"}]]

[[:section {:title "Basics"}]]

"`signal` typically just informs its listeners with a given set of information. An example of this can be seen here:"

(comment
  (signal {:web true :log true :msg "hello"})
  => ())

"It can also be written like this for shorthand:"

(comment
  (signal [:web :log {:msg "hello"}])
  => ())

"A signal by itself does not do anything. It requires a listener to be defined in order to process the signal:"

(comment
  (deflistener log-print-listener :log
    e
    (println "LOG:" e))

  (signal [:web :log {:msg "hello"}])
  => ({:result nil,
       :id documentation.hara-event/log-print-listener})
  ;; LOG: {:web true, :log true, :msg hello}
  )

"A second listener will result in `signal` triggering two calls"

(comment
  (deflistener web-print-listener :web
    e
    (println "WEB:" e))

  (signal [:web :log {:msg "hello"}])
  => ({:result nil, :id documentation.hara-event/web-print-listener}
      {:result nil, :id documentation.hara-event/log-print-listener})
  ;; LOG: {:web true, :log true, :msg hello}
  ;; WEB: {:web true, :log true, :msg hello}
  )

"Whereas another signal without an attached data listener will not trigger:"

(comment
  (signal [:db {:msg "hello"}])
  => ())

"This can be resolved by adding another listener:"

(comment
  (deflistener db-print-listener :db
    e
    (println "DB:" e)))

(comment
  (signal [:db {:msg "hello"}])
  => ({:result nil, :id documentation.hara-event/db-print-listener})
  ;; DB: {:db true, :msg hello}
)

[[:section {:title "API"}]]

[[:api {:title ""
        :namespace "hara.event"
        :only ["deflistener"
               "signal"
               "clear-listeners"
               "install-listener"
               "list-listeners"
               "uninstall-listener"
               "with-temp-listener"]}]]

[[:chapter {:title "Conditionals"}]]

"`hara.event` also provides for a conditional framework. It also can be thought of as an issue resolution system or `try++/catch++`. There are many commonalities between the signalling framework as well as the conditional framework. Because the framework deals with abnormal program flow, there has to berichness in semantics in order to resolve the different types of issues that may occur. The diagram below shows how the two frameworks fit together."

[[:image {:src "img/hara_event/event_pathway.png" :width "100%"}]]

[[:section {:title "API"}]]

[[:api {:title ""
        :namespace "hara.event"
        :only ["choose"
               "continue"
               "default"
               "escalate"
               "fail"
               "manage"
               "raise"]}]]

[[:section {:title "Basics"}]]

"In this demonstration, we look at how code bloat problems using `throw/try/catch` could be reduced using `raise/manage/on`. Two functions are defined:

- `value-check` which takes a number as input, throwing a `RuntimeException` when it sees an input that it doe not like. 
- `value-to-string` which takes a number as input, and returns it's string"

(defn value-check [n]
  (cond (= n 13)
        (raise {:type :unlucky
                :value n})

        (= n 7)
        (raise {:type :lucky
                :value n})
        
        (= n 666)
        (raise {:type :the-devil
                :value n})

        :else n))

(defn value-to-string [n]
  (str (value-check n)))

"uses of `value-to-string` are as follows:"

(fact
  (value-to-string 1)
  => "1"

  (value-to-string 666)
  => (throws-info {:value 666
                   :type :the-devil}))

"The advantage of using conditionals instead of the standard java `throw/catch` framework is that problems can be isolated to a particular scope without affecting other code that had already been built on top. When we map `value-to-string` to a range of values, if the inputs are small enough then there is no problem:"

(fact
  (mapv value-to-string (range 3))
  => ["0" "1" "2"])

"However, if the inputs are wide enough to contain something out of the ordinary, then there is an exception."

(fact
  (mapv value-to-string (range 10))
  => (throws-info {:value 7
                   :type :lucky}))

[[:section {:title "Exceptions"}]]

"`manage` is the top level form for handling exceptions to normal program flow. The usage of this form is:"

(fact
  (manage
   (mapv value-to-string (range 10))
   (on {:type :lucky} e
       "LUCKY-NUMBER-FOUND"))
  => "LUCKY-NUMBER-FOUND")

"This is the same mechanism as `try/catch`, which `manage` replacing `try` and `on` replacing `catch`. The difference is that there is more richness in semantics. The key form being `continue`:"

(fact
  (manage
   (mapv value-to-string (range 10))
   (on {:type :lucky}
       []
       (continue "LUCKY-NUMBER-FOUND")))
  => ["0" "1" "2" "3" "4" "5" "6"
      "LUCKY-NUMBER-FOUND" "8" "9"])

"`continue` is special because it operates at the scope where the exception was raised. This type of handling cannot be replicated using the standard `try/catch` mechanism. Generally, exceptions that occur at lower levels propagate to the upper levels. This usually results in a complete reset of the system. `continue` allows for lower-level exceptions to be handled with much more grace because the scope is pin-pointed to where `raise` was called."

"Furthermore, there may be exceptions that require more attention and so `continue` can only be used when it is needed."

(defn values-to-string [inputs]
  (manage
   (mapv value-to-string inputs)
   (on :value
       [type value]
       (cond (= type :the-devil)
             "OH NO!"

             :else (continue type)))))

(fact
  (values-to-string (range 6 14))
  => ["6" ":lucky" "8" "9" "10" "11" "12" ":unlucky"]
  
  (values-to-string [1 2 666])
  => "OH NO!")

[[:chapter {:title "Strategies"}]]

[[:file {:src "test/documentation/hara_event/strategies.clj"}]]
