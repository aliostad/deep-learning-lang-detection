(ns ftbot.models.facebook
  (:require [ftbot.util :as util]
            [ftbot.models.accounts :as acc-db]
            [clojure.java.io :as io]
            )
  (:import (facebook4j Facebook
             FacebookFactory Post
             PostUpdate Media PhotoUpdate)
            (facebook4j.auth AccessToken)
            (java.net URL)
           )
  )

(defn request-long-live-token-url
  [app_id secret token]
    (format "https://graph.facebook.com/oauth/access_token?client_id=%s&client_secret=%s&grant_type=fb_exchange_token&fb_exchange_token=%s"
          app_id secret token)
  )

(defn gen-facebook-simple [app-id secret]
  (doto ( .getInstance (FacebookFactory.))
    (.setOAuthAppId
      app-id
      secret)
    (.setOAuthPermissions "manage_pages,publish_actions,user_photos")
))

(defn gen-facebook [account]
  (let [[app-id secret]
          (map account [:fb_app_id :fb_secret_id ])
        ]
  (doto ( .getInstance (FacebookFactory.))
    (.setOAuthAppId
      app-id
      secret)
    (.setOAuthPermissions "manage_pages,publish_actions")
  )))

(defn oauth-url
 [facebook callback-url]
 (.getOAuthAuthorizationURL
   facebook callback-url))

(defn get-page
  [facebook page-id]
  (first
    (filter  #(= (.getId %) page-id)
        (.getAccounts facebook)
    )
  ))

(defn setup-page-token
  [account]
  (let [facebook (doto (gen-facebook account)
                        (.setOAuthAccessToken
                          (AccessToken. (:fb_token account))))
        page (get-page facebook (:fb_page_id account))]
    (if page
        (.getAccessToken page )
      nil
      )
    )
  )

(defn make-photo-update [article]
  (let [photo-name (or (:name article) "")
        photo (Media. photo-name
                  (io/input-stream
                   (URL. (:thumbnail_url article))))
        photo-update (PhotoUpdate. photo)
      ]

    (when-let [msg (:message article)]
      (.setMessage photo-update  msg))
    photo-update
))

(defn make-post-update [article]
  (let [[ name caption thumbnail description body]
          (map article [:name :caption
                        :thumbnail_url
                        :description
                        :body])
      ]
    (if-not (empty? thumbnail)
        (doto (PostUpdate. body)
              (.name name)
              (.caption caption)
              (.description description)
              (.picture (URL. thumbnail))
        )

      (PostUpdate. body))
))

(defn post-fb
  [article]
  (let [account (acc-db/find-by-id (:account_id article))
        page-token (setup-page-token account)
        facebook (doto (gen-facebook account)
                  (.setOAuthAccessToken (AccessToken. page-token)))
        ]
    (if-not page-token
      nil
      (if (:is_image_post article)
        (.postPhoto facebook (make-photo-update article))
        (.postFeed facebook (make-post-update article))))
    ))

