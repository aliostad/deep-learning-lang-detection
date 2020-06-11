;
; Copyright © 2017 Symphony Software Foundation
; SPDX-License-Identifier: Apache-2.0
;
; Licensed under the Apache License, Version 2.0 (the "License");
; you may not use this file except in compliance with the License.
; You may obtain a copy of the License at
;
;     http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.
;

(ns clj-symphony.stream
  "Operations related to 'streams'.  A 'stream' is the generic term for any kind of message channel in the Symphony platform, and come in several flavours:
1. 1:1 chat
2. M:M chat
3. room
4. wall post

The primary difference between chats and rooms is that rooms have dynamic membership whereas the membership of a chat is fixed at creation time.

In addition, each type of stream can be 'internal' (intra-pod) or 'external' (include users from 1 other pod)."
  (:require [clj-symphony.user :as syu]))


(def stream-types
  "The set of possible stream types in Symphony, as keywords."
  (set (map #(keyword (str %)) (org.symphonyoss.symphony.clients.model.SymStreamTypes$Type/values))))


(defn streamobj->map
  "Converts a org.symphonyoss.symphony.clients.model.SymStreamAttributes object into a map."
  [^org.symphonyoss.symphony.clients.model.SymStreamAttributes stream]
  (if stream
    {
      :stream-id          (.getId               stream)
      :name               (if-let [room-attrs (.getSymRoomSpecificStreamAttributes stream)]
                            (.getName room-attrs))
      :active             (.getActive           stream)
      :type               (when-not (nil? (.getSymStreamTypes stream))
                            (keyword (str (.getType (.getSymStreamTypes stream)))))
      :cross-pod          (.getCrossPod         stream)
      :member-user-ids    (if-let [chat-attrs (.getSymChatSpecificStreamAttributes stream)]
                            (vec (.getMembers chat-attrs)))
    }))


(defmulti stream-id
  "Returns the stream id of the given item."
  {:arglists '([stream])}
  type)

(defmethod stream-id nil
  [stream]
  nil)

(defmethod stream-id String
  [^String stream]
  stream)

(defmethod stream-id java.util.Map
  [{:keys [stream-id]}]
  stream-id)

(defmethod stream-id org.symphonyoss.symphony.clients.model.SymStreamAttributes
  [^org.symphonyoss.symphony.clients.model.SymStreamAttributes stream]
  (.getId stream))

(defmethod stream-id org.symphonyoss.client.model.Chat
  [^org.symphonyoss.client.model.Chat stream]
  (.getStreamId stream))

(defmethod stream-id org.symphonyoss.symphony.clients.model.SymRoomDetail
  [^org.symphonyoss.symphony.clients.model.SymRoomDetail stream]
  (.getId (.getRoomSystemInfo stream)))

(defmethod stream-id org.symphonyoss.symphony.clients.model.SymMessage
  [^org.symphonyoss.symphony.clients.model.SymMessage stream]
  (.getStreamId stream))


(defn streamobjs
  "Returns a list of org.symphonyoss.symphony.clients.model.SymStreamAttributes objects visible to the authenticated connection user."
  [^org.symphonyoss.client.SymphonyClient connection]
  (.getStreams (.getStreamsClient connection)
               nil
               nil
               (org.symphonyoss.symphony.clients.model.SymStreamFilter.)))


(defn streams
  "Returns a lazy sequence of streams visible to the authenticated connection user."
  [connection]
  (map streamobj->map (streamobjs connection)))


; Note: currently SJC doesn't seem to offer any way to get stream information
; for a single stream, so we emulate it here until such time as it does
(defn streamobj
  "Returns the given stream identifier as a org.symphonyoss.symphony.clients.model.SymStreamAttributes object, or nil if it doesn't exist / isn't accessible to the authenticated connection user."
  [^org.symphonyoss.client.SymphonyClient connection stream]
  (.getStreamAttributes (.getStreamsClient connection) (stream-id stream)))


(defn stream
  "Returns the given stream identifier as a map, or nil if it doesn't exist / isn't accessible to the authenticated connection user."
  [connection stream]
  (streamobj->map (streamobj connection stream)))


(defn usersobjs-from-stream
  "Returns all org.symphonyoss.symphony.clients.model.SymUser objects participating in the given stream."
  [^org.symphonyoss.client.SymphonyClient connection stream]
  (.getUsersFromStream (.getUsersClient connection) (stream-id stream)))


(defn users-from-stream
  "Returns all users participating in the given stream, as maps (see clj-symphony.user/userobj->map for details)."
  [connection stream]
  (map syu/userobj->map (usersobjs-from-stream connection stream)))
