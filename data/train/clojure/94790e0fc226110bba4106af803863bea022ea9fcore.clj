(ns twitter-streaming-client.core
  "an asynchronous client for the twitter streaming api, using twitter.api.streaming
   for Twitter Streaming API calls, and adding support for recovery and retry and batch
   processing of results"
  (:use
   twitter-streaming-client.impl))

(defn create-twitter-stream 
  "set up a TwitterStream client in the :stopped state
   returns an Agent with a TwitterStream value... pass the Agent
   to start-twitter-stream to get things going
   method - a twitter.api.streaming method
   other-params - for the twitter.api.streaming method, e.g. :oauth-creds, :params etc"
  [method & other-params]
  (let [twitter-stream-agent (agent (twitter_streaming_client.impl.TwitterStream. :stopped {} "" nil nil nil nil)
;;                                    :error-handler twitter-stream-agent-error-handler
                                    )
        callbacks (async-streaming-callbacks twitter-stream-agent)
        request-fn (apply create-request-fn method callbacks other-params)]
    (alter-meta! twitter-stream-agent assoc :request-fn request-fn)
    twitter-stream-agent))

(defn start-twitter-stream 
  "asynchronously start the streaming client. it will keep on running it is cancelled.
   tweets and other messages will be delivered to the :queues map in the TwitterStream record"
  [twitter-stream-agent & {:keys [force?] :or {force? true}}]
  (send-off twitter-stream-agent start-twitter-stream-action (:request-fn (meta twitter-stream-agent)) :force? force?))

(defn cancel-twitter-stream 
  "asynchronously cancel the streaming client. 
   the http.async.client will be stopped, and the TwitterStream put into the :stopped state"
  [twitter-stream-agent]
  (send-off twitter-stream-agent cancel-twitter-stream-action))

(defn empty-queues
  "asynchronously call function f with the :queues map from the TwitterStream record, 
   then reset the :queues map to empty"
  [twitter-stream-agent f]
  (send twitter-stream-agent empty-queues-action f))

(defn retrieve-queues
  "synchronously retrieve the :queues map from the TwitterStream record, resetting the :queues map to empty.
   returns a map with zero or more of the keys [:tweet :delete :scrub_geo :limit :unknown] each of which
   has a vector value which is a queue of the decoded JSON messages of that type received on the stream since
   the request was started, or the queue was last emptied"
  [twitter-stream-agent]
  (let [qp (promise)]
    (empty-queues twitter-stream-agent #(deliver qp %))
    @qp))

