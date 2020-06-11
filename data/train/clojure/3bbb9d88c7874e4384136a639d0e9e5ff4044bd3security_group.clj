(ns com.palletops.aws.security-group
  "Manage EC2 security groups using an async interface."
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

(defn ensure-security-group
  "Return the security-group name for key-name.  If it doesn't exist,
  create it with the given key-material.  Write a result map to ch
  with a :security-group-name key."
  [api credentials security-group-name {:keys [description] :as options} ch]
  (go-try ch
    (let [c (chan)]
      (aws/submit
       api
       (ec2/describe-security-groups-map
        credentials {:group-names [security-group-name]})
       c)
      (let [sgs (<! c)
            e (:exception sgs)]
        (debugf "ensure-security-group existing %s" (pr-str sgs))

        (if (or (and e (instance? com.amazonaws.AmazonServiceException e)
                     (= 400 (.getStatusCode e)))
                (and (not e) (empty? sgs)))
          (do
            (seq sgs)
            (infof "Security group '%s' not present. Creating it..."
                   security-group-name)
            (aws/submit
             api
             (ec2/create-security-group-map
              credentials
              (merge
               {:group-name security-group-name}
               options))
             c)
            (let [r (<! c)]
              (infof "Security group '%s' created." security-group-name)
              (>! ch (assoc r :group-name security-group-name))))
          (>! ch (merge (first (:security-groups sgs))
                        (select-keys sgs [:exception]))))))))

(defn open-security-group-port
  "Open a security group port to public access"
  [api credentials security-group-name port ch]
  (let [c (chan)]
    (infof "Opening security group %s port %s" security-group-name port)
    (aws/submit
     api
     (ec2/authorize-security-group-ingress-map
      credentials
      {:group-name security-group-name
       :ip-permissions [{:ip-protocol "tcp"
                         :from-port port
                         :to-port port
                         :ip-ranges ["0.0.0.0/0"]}]})
     c)
    (go-try ch
      (let [{:keys [exception] :as result} (<! c)]
        (>! ch
            (if (and exception
                     (instance? com.amazonaws.AmazonServiceException exception)
                     (= "InvalidPermission.Duplicate"
                        (.getErrorCode
                         ^com.amazonaws.AmazonServiceException exception)))
              (dissoc result :exception)
              result))))))
