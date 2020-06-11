(ns theladders.bluehornet-client.api.legacy
  (:require [theladders.bluehornet-client.core :as core]))

(defn bulk-sync [reply-email number ftp-server ftp-username ftp-password filename file-type source & {:as optional}]
  (core/make-method "legacy.bulk_sync" 
                    :reply_email reply-email
                    :file_type file-type
                    :number number
                    :source source
                    :ftp_server ftp-server
                    :ftp_user_name ftp-username
                    :ftp_user_pass ftp-password
                    :filename filename
                    :optional optional))

(defn delete-subscribers [reply-email ftp-server ftp-username ftp-password filename & {:as optional}]
  (core/make-method "legacy.delete_subscribers"
                    :reply_email reply-email
                    :ftp_server ftp-server
                    :ftp_user_name ftp-username
                    :ftp_user_pass ftp-password
                    :filename filename
                    :optional optional))

(defn retrieve-active [& {:as optional}]
  (core/make-method "legacy.retrieve_active" :optional optional))

(defn manage-subscriber [email & {:as optional}]
  (core/make-method "legacy.manage_subscriber" :email email :optional optional))
