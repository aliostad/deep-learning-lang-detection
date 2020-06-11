(ns com.palletops.aws.keypair
  "Manage EC2 keypairs using an async interface."
  (:require
   [clojure.core.async :refer [<! >! chan put!]]
   [clojure.string :refer [join]]
   [com.palletops.awaze.ec2 :as ec2]
   [com.palletops.aws.api :as aws]
   [com.palletops.aws.core :refer [go-try]]
   [taoensso.timbre :refer [debugf warnf infof tracef]])
  (:import
   [java.security MessageDigest NoSuchAlgorithmException]
   [org.apache.commons.codec.binary Base64]))

(defn ensure-keypair
  "Return the keypair name for key-name.  If it doesn't exist,
  create it with the given key-material.  Write a result map to ch
  with a :key-name key."
  [api credentials key-name key-material ch]
  (go-try ch
    (let [c (chan)]
      (aws/submit api (ec2/describe-key-pairs-map
                       credentials {:key-names [key-name]})
                  c)
      (let [key-pairs (<! c)]
        (debugf "keypair existing keypairs %s" key-pairs)
        (if (:exception key-pairs)
          (>! ch key-pairs)
          (let [k (first key-pairs)]
            (if k
              (>! ch k)
              (do
                (infof "Keypair '%s' not present. Creating it..." key-name)
                (aws/submit
                 api
                 (ec2/import-key-pair-map
                  credentials
                  {:key-name key-name
                   :public-key-material key-material})
                 c)
                (let [res (<! c)]
                  (infof "Keypair '%s' created." key-name)
                  (>! ch {:key-name key-name}))))))))))
