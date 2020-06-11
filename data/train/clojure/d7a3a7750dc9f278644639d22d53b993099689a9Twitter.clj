(ns TwitterMemorizerLib.Twitter
  (:import [twitter4j.TwitterFactory])
  (:import [twitter4j.TwitterStreamFactory])
  (:import [java.io ObjectInputStream ObjectOutputStream FileInputStream FileOutputStream File]))

(defn create-twitter-instance
  "Return twitter4j.Twitter Instance with setting consumer key and consumer secret"
  [consumer-key
   consumer-secret]
  (doto (. (twitter4j.TwitterFactory.) getInstance)
    (.setOAuthConsumer consumer-key consumer-secret)))

(defn create-twitter-stream-instance
  "Return twitter4j.TwitterStream Instance"
  [consumer-key
   consumer-secret]
  (doto (. (twitter4j.TwitterStreamFactory.) getInstance)
    (.setOAuthConsumer consumer-key consumer-secret)))

(defn add-stream-listener
  "Add Listener to Stream Instance"
  [stream
   stream-adapter]
  (. stream addListener stream-adapter))

(defn authorize-oauth
  "Return access token with oauth-authorization"
  [twitter
   output-url-fun
   input-pin]
  (let [token (. twitter getOAuthRequestToken)]
    (do
      (output-url-fun (. token getAuthorizationURL))
      (. twitter getOAuthAccessToken token (if (fn? input-pin) (input-pin) input-pin)))))

(defn save-access-token
  "Save AccessToken"
  [access-token
   file-name]
  (with-open [os (new ObjectOutputStream (new FileOutputStream (new File file-name)))]
    (. os writeObject access-token)))

(defn- cast-to-access-token
  "Cast to Access token"
  [#^twitter4j.auth.AccessToken obj]
  obj)

(defn load-access-token
  "Load AccessToken"
  [file-name]
  (with-open [is (new ObjectInputStream (new FileInputStream (new File file-name)))]
    (cast-to-access-token (. is readObject))))

(defn set-oauth-access-token
  "Set AccessToken to Twitter Instance"
  [twitter
   access-token]
  (. twitter setOAuthAccessToken access-token))