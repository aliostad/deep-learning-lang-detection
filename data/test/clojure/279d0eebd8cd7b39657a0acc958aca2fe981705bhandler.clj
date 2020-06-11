(ns schema-fun.handler
  (:require [compojure.api.sweet :refer :all]
            [ring.util.http-response :refer :all]
            [ring.adapter.jetty]
            [schema.core :as s]
            [schema-fun.calendar :as cal])
  (:import  org.joda.time.DateTime))



(s/defschema Message
  "A response message, with a language identifier"
  {:message  String
   :language String})


(def hello-format-strings
  "A map of format strings, keyed by a language code"
  {"en" "Hello %s"
   "es" "Hola %s"
   "fi" "Terve %s"
   "fr" "Bonjour %s"
   "de" "Hallo %s"
   "it" "Ciao %s"
   "ja" "こんにちは %s"
   "oj" "ᐋᓃᓐ %s"
   "sv" "Hallå %s"})



(s/defschema LanguageCode
  "Valid Language Codes"
  (apply s/enum (keys hello-format-strings)))


(s/defschema EnumMessage
  "A response message, with a language identifier"
  {:message  String
   :language LanguageCode})


(s/defschema MissingEvent
  {:error (s/eq "not-found")
   :event cal/EventId})


(defn event-not-found [event-id]
  (not-found {:error "not-found"
              :event event-id}))


(defn hello
  [language name]
  (when-some [hello-fmt (hello-format-strings language)]
    {:message  (format hello-fmt name)
     :language language}))



(defonce CALENDAR_DB
  (cal/fresh-calendar-db))


(def app
  (api
   {:swagger
    {:ui "/"
     :spec "/swagger.json"
     :data {:info {:title "Fun with Schema"
                   :description "Compojure API Example"}
            :tags [{:name "hello", :description "Says \"hello\""}
                   {:name "calendar", :description "Manage Events"}]}}}

   (context "/hello" []
     :tags ["hello"]
     (GET "/string/:language" []
       :return       Message
       :responses    {404 {:schema Message
                           :description "An error Message"}}
       :path-params  [language :- String]
       :query-params [name :- String]
       :summary "Say 'hello' in a particular language"
       (if-some [msg (hello language name)]
         (ok msg)
         (not-found
           {:message  (format "I don't speak '%s'." language)
            :language "en"})))

     (GET "/enum/:language" []
       :return       EnumMessage
       :responses    {404 {:schema EnumMessage
                           :description "An error Message"}}
       :path-params  [language :- LanguageCode]
       :query-params [name :- String]
       :summary "Say 'hello' in a particular language"
       (if-some [msg (hello language name)]
         (ok msg)
         (not-found
           {:message  (format "I don't speak '%s'." language)
            :language "en"}))))

   
   (context "/calendar" []
     :tags ["calendar"]
     (POST "/event" []
       :return  cal/Event
       :body    [new-event cal/EventRequest]
       :summary "Create an event"
       (ok (cal/create-event CALENDAR_DB new-event)))

     (GET "/event/:event-id" []
       :return      cal/Event
       :responses   {404 {:schema MissingEvent
                          :description "A non-event"}}
       :path-params [event-id :- cal/EventId]
       :summary     "Retrieve an event"
       (if-let [event (cal/get-event CALENDAR_DB event-id)]
         (ok event)
         (event-not-found event-id)))

     (PUT "/event/:event-id" []
       :return      cal/Event
       :responses   {404 {:schema MissingEvent
                          :description "A non-event"}}
       :path-params [event-id :- cal/EventId]
       :body        [upd-event cal/EventRequest]
       :summary     "Update an event"
       (if-let [event (cal/update-event CALENDAR_DB event-id upd-event)]
         (ok event)
         (event-not-found event-id)))

     (DELETE "/event/:event-id" []
       :return      cal/Event
       :responses   {404 {:schema MissingEvent
                          :description "A non-event"}}
       :path-params [event-id :- cal/EventId]
       :summary     "Delete an event"
       (if-let [event (cal/delete-event CALENDAR_DB event-id)]
         (ok event)
         (event-not-found event-id)))

     (GET "/list" []
       :return       cal/Schedule
       :query-params [from :- DateTime
                      to   :- DateTime]
       :summary      "Return the schedule for a specified time frame"
       (ok (cal/schedule-for CALENDAR_DB from to)))
     )
   ))


(comment
  (def server
    (ring.adapter.jetty/run-jetty #'app
      {:host "0.0.0.0" :port 8080 :join? false}))
  )