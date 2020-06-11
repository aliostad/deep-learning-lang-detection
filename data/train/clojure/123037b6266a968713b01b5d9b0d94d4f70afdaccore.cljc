(ns quantum.apis.google.youtube.core
  #_(:require-quantum [:lib auth http url])
  (:require [quantum.apis.google.auth :as gauth]))

#_(def api-auth (:api-auth gauth/urls))
#_(defn access-token []
  (->> (auth/auth-keys :google) :youtube :access-tokens :current :access-token))

; https://developers.google.com/youtube/v3/guides/auth/server-side-web-apps
#_(assoc! gauth/scopes :youtube
  {; Manage your YouTube account.
   ; This scope requires communication with the API server to happen over an SSL connection.
   :force-ssl       (io/path api-auth "youtube.force-ssl")
   ; Manage your YouTube account.
   ; This scope is functionally identical to the youtube.force-ssl scope
   ; because the YouTube API server is only available via an HTTPS endpoint.
   ; As a result, even though this scope does not require an SSL connection,
   ;mthere is actually no other way to make an API request.
   :account         (io/path api-auth "youtube")
   ; View your YouTube account.
   :read            (io/path api-auth "youtube.readonly")
   ; Upload YouTube videos and manage your YouTube videos.
   :upload          (io/path api-auth "youtube.upload")
   ;Retrieve the auditDetails part in a channel resource.
   :channel-audit   (io/path api-auth "youtubepartner-channel-audit")
   :channel-partner (io/path api-auth "youtubepartner")})


#_(defn list-channels []
  (-> (http/request!
        {:url "https://www.googleapis.com/youtube/v3/channels"
         :handlers {401 
                    (fn [req resp]
                      (gauth/access-token-refresh! :youtube)
                      (http/request!
                        (assoc req :oauth-token (access-token))))}
         :query-params {"part" "id" "mine" true}
         :oauth-token (access-token)})
      :body (json/parse-string str/keywordize)))

#_(defn delete-playlist! [id]
  (-> (http/request!
        {:method :delete
         :url          "https://www.googleapis.com/youtube/v3/playlists"
         :query-params {"id" id}
         :oauth-token  (access-token)})))



; (defn playlist-items [playlist-id]
;   (let [req {:url          "https://www.googleapis.com/youtube/v3/playlistItems"
;              :query-params {"part" "snippet" "playlistId" playlist-id "maxResults" 50}
;              :oauth-token  (access-token)}]
;     (->> (http/request! req)
;          :body
;          (<- json/parse-string str/keywordize)
;          (get-all-pages req))))


; (defn list-videos []
;   (-> (http/request!
;         {:url "https://www.googleapis.com/youtube/v3/search"
;          :query-params {"part" "id" "channelId" true "maxResults" 50} ; I think max may be 50
;          :oauth-token (->> (auth/auth-keys :google) :youtube :access-tokens :offline :access-token)})
;       :body (json/parse-string str/keywordize)))

