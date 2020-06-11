;; Copyright 2017 Jong-won Choi <oz.jongwon.choi@gmail.com>
;;
;; Licensed under the Apache License, Version 2.0 (the "License")
;; you may not use this file except in compliance with the License.
;; You may obtain a copy of the License at
;;
;;     http://www.apache.org/licenses/LICENSE-2.0
;;
;; Unless required by applicable law or agreed to in writing, software
;; distributed under the License is distributed on an "AS IS" BASIS,
;; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
;; See the License for the specific language governing permissions and
;; limitations under the License.

;;
;; Peer implementation of "Fabric SDK Design Spec"
;; 
;; The Peer class represents the remote Peer node and its network membership materials,
;; aka the ECert used to verify signatures. Peer membership represents organizations,
;; unlike User membership which represents individuals.
;;
;; When constructed, a Peer instance can be designated as an event source, in which case
;; a “eventSourceUrl” attribute should be configured. This allows the SDK to automatically
;; attach transaction event listeners to the event stream.
;;
;; It should be noted that Peer event streams function at the Peer level and not at the chain
;; and chaincode levels.

(ns clojure-fabric.peer
  (:import [clojure-fabric.core :as core]))

;;connectEventSource
(defn connect-event-source
  "Since practically all Peers are event producers, when constructing a Peer instance,
  an application can designate it as the event source for the application. Typically only
  one of the Peers on a Chain needs to be the event source, because all Peers on the Chain
  produce the same events. This method tells the SDK which Peer(s) to use as the event source
  for the client application. It is the responsibility of the SDK to manage the connection
  lifecycle to the Peer’s EventHub. It is the responsibility of the Client Application
  to understand and inform the selected Peer as to which event types it wants to receive and
  the call back functions to use.
  Params:
        None
  Result:
        Promise/Future: this gives the app a handle to attach “success” and “error” listeners"
  ([]
   (connect-event-source core/*peer*))
  ([peer]
   ;; TBD register to eventhub
   ))

;;is_event_listened
(defn event-listened?
  "A network call that discovers if at least one listener has been connected to the target Peer
  for a given event. This helps application instance to decide whether it needs to connect
  to the event source in a crash recovery or multiple instance deployment.

  NOTE: this requires enhancement on the Peer event producer.
  Params:
        eventName (string): required
        chain (Chain): optional
  Result:
        (boolean): whether the said event has been listened on by some application instance
        on that chain"
  ([event-name]
   (event-listened? core/*peer* event-name))
  ([peer event-name]
   (event-listened? peer event-name nil))
  ([peer event-name chain]
   ;; TBD
   ))

;;; addListener
(defn add-listener 
  "For a Peer that is connected to eventSource, the addListener registers an EventCallBack for
  a set of event types. addListener can be invoked multiple times to support differing EventCallBack
  functions receiving different types of events.
  
  Note that the parameters below are optional in certain languages, like Java, that constructs
  an instance of a listener interface, and pass in that instance as the parameter.
  
  Params:
        eventType : ie. Block, Chaincode, Transaction 
        eventTypeData : Object Specific for event type as necessary, currently needed for
                “Chaincode” event type, specifying a matching pattern to the event name set
                in the chaincode(s) being executed on the target Peer, and for “Transaction”
                event type, specifying the transaction ID
        eventCallback : Client Application class registering for the callback.
  Returns:
        [event-listener-ref] a reference to the event listener, some language uses an ID
        (javascript), others uses object reference (Java)"
  ([event-type event-type-data event-call-back]
   (add-listener core/*peer* event-type event-type-data event-call-back))
  ([peer event-type event-type-data event-call-back]
   ;; TBD
   ))

;;; removeListener
(defn remove-listener
  "Unregisters a listener.

  Params:
        [event-listener-ref] : reference returned by SDK for event listener 
  Returns:
        statusFlag: Success / Failure"
  ([event-listener-ref]
   (remove-listener core/*peer* event-listener-ref))
  ([peer event-listener-ref]
   ;; TBD
   ))

;;; get_name
(defn get-name 
  "Get the Peer name. Required property for the instance objects.

  Returns (str): 
        The name of the Peer"
  ([]
   (get-name core/*peer*))
  ([peer]
   (:name peer)))

;; set_name
;; Immutable in this implementation

;;get_roles
;; "Get the user’s roles the Peer participates in. It’s an array of possible values in “client”,
;; and “auditor”. The member service defines two more roles reserved for peer membership: 
;; “peer” and “validator”, which are not exposed to the applications.
;; Returns (str[]): 
;;       The roles for this user"
;;
;; User's method


;; set_roles
;; Immutable

;;;get_enrollment_certificate
;;;
;;; Implementation Note
;;;     User has this information, not peer

;;; set_enrollment_certificate
;;; Immutable
