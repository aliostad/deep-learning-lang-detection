(ns calendario.user-service-test
  (:require [clojure.test :refer :all]
            [calendario.user-service :refer :all]))


; get-user-profile - http-client siteid tuid
; get-user-by-email http-client email (list tuids for account)

; happy path returns profile, email lookup returns at least one account
; http exceptions
; what happens if user not found or error in xml response

(deftest get-user-by-email-test
  (testing "retrieve siteid/tuid combos for an email"
    (with-redefs [post-url (fn [url opts meta-data reg] {:status 200
                                           :body "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?><listTUIDsForExpAccountResponse success=\"true\" xmlns=\"urn:com:expedia:www:services:user:messages:v3\"><expUser id=\"301078\" emailAddress=\"jmadynski@expedia.com\"/><expUserTUIDMapping tpid=\"1\" tuid=\"5363093\" singleUse=\"true\" updateDate=\"2014-04-25T09:55:00.000-07:00\"/><expUserTUIDMapping tpid=\"1\" tuid=\"577015\" singleUse=\"false\" updateDate=\"2014-05-30T22:26:00.000-07:00\"/><authRealmID>1</authRealmID></listTUIDsForExpAccountResponse>"
                                                         })
                  update-metrics-user-by-email-success! (fn [reg time] nil)]
      (is (= {:expuserid "301078", :email "jmadynski@expedia.com", :tuidmappings [{:tpid "1", :tuid "5363093", :single-use "true"} {:tpid "1", :tuid "577015", :single-use "false"}]}
             (get-user-by-email {:user-service-endpoint "someurl"
                                   :conn-timeout 10
                                   :socket-timeout 10
                                   :conn-mgr true} {} "jeffmad@gmail.com"))))))

(deftest get-user-profile-test
  (testing "retrieve user profile for a siteid tuid"
    (with-redefs [post-url (fn [url opts meta-data reg] {:status 200
                                                     :body "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?><getUserProfileResponse success=\"true\" xmlns=\"urn:com:expedia:www:services:user:messages:v3\"><user passengerType=\"2\" emailAddress=\"jmadynski@expedia.com\" loginName=\"577015_EmailSignIn\" hasGroups=\"false\" locale=\"en_US\"><personalName titleID=\"0\" first=\"Elmer\" middle=\"\" last=\"Fudd\"/><preferredPhone countryCode=\"1\" phoneNumber=\"(415) 5050490\"/><paymentInstrument paymentInstrumentID=\"75F85DBA-9274-4FC3-B7D6-E24BE4C5580C\"><description>myvisa</description></paymentInstrument><paymentInstrument paymentInstrumentID=\"35DA0E90-A3DC-4C48-93AD-415B1B1D59E0\"><description>otre Visa</description></paymentInstrument></user></getUserProfileResponse>"
                                                         })
                  update-metrics-user-profile-success! (fn [reg time] nil)]
      (is (= {:email "jmadynski@expedia.com", :locale "en_US", :first "Elmer", :last "Fudd", :country-code "1", :phone "(415) 5050490"}
             (get-user-profile {:user-service-endpoint "someurl"
                                   :conn-timeout 10
                                   :socket-timeout 10
                                :conn-mgr true} {} 1 577015)))))
  (testing "retrieve user profile for non existent traveler"
    (with-redefs [post-url (fn [url opts meta-data reg] {:status 200
                                                     :body "<?xml version=\"1.0\" encoding=\"utf-8\" standalone=\"yes\"?><getUserProfileResponse success=\"false\" xmlns=\"urn:com:expedia:www:services:user:messages:v3\"><errorMessage errorCode=\"IllegalArguments\">Invalid traveler (LoggedInTUID: 577015 or ActAsTUID: 577015).</errorMessage></getUserProfileResponse>"
                                                         })
                  update-metrics-user-profile-success! (fn [reg time] nil)
                  user-profile-from-cache (fn [siteid tuid] nil)]
      (is (thrown-with-msg? clojure.lang.ExceptionInfo #"profile response not successful"
             (get-user-profile {:user-service-endpoint "someurl"
                                   :conn-timeout 10
                                   :socket-timeout 10
                                :conn-mgr true} {} 1 577015)))))
  (testing "retrieve user profile but exception occurs"
    (with-redefs [post-url (fn [url opts meta-data reg] (throw (ex-info "could not connect to user service" {:cause :service-unavailable :error {:reason "something bad happened"
                                                                                                                                             :data meta-data
                                                                                                                                                 :url url}})))
                  user-profile-from-cache (fn [siteid tuid] nil)]
      (is (thrown? clojure.lang.ExceptionInfo
             (get-user-profile {:user-service-endpoint "someurl"
                                :conn-timeout 10
                                :socket-timeout 10
                                :conn-mgr true} {} 1 577015))))))

;<?xml version="1.0" encoding="utf-8" standalone="yes"?><listTUIDsForExpAccountResponse success="true" xmlns="urn:com:expedia:www:services:user:messages:v3"><expUser id="301078" emailAddress="jmadynski@expedia.com"/><expUserTUIDMapping tpid="1" tuid="5363093" singleUse="true" updateDate="2014-04-25T09:55:00.000-07:00"/><expUserTUIDMapping tpid="1" tuid="577015" singleUse="false" updateDate="2014-05-30T22:26:00.000-07:00"/><authRealmID>1</authRealmID></listTUIDsForExpAccountResponse>
; curl -v -k -H "Content-Type: text/xml" -X POST -d '<?xml version="1.0" encoding="utf-8"?><usr:getUserProfileRequest xmlns:usr="urn:com:expedia:www:services:user:messages:v3"><usr:user actAsTuid="577015" loggedInTuid="577015"/><usr:pointOfSale tpid="1" eapid="0"/><usr:messageInfo enableTraceLog="false" clientName="localhost" transactionGUID="a2192179-d5b7-4234-918c-8f662aaaf545"/></usr:getUserProfileRequest>' 'https://userservicev3.integration.karmalab.net:56783/profile/get'
;<?xml version="1.0" encoding="utf-8" standalone="yes"?><getUserProfileResponse success="true" xmlns="urn:com:expedia:www:services:user:messages:v3"><user passengerType="2" emailAddress="jmadynski@expedia.com" loginName="577015_EmailSignIn" hasGroups="false" locale="en_US"><personalName titleID="0" first="Elmer" middle="" last="Fudd"/><preferredPhone countryCode="1" phoneNumber="(415) 5050490"/><paymentInstrument paymentInstrumentID="75F85DBA-9274-4FC3-B7D6-E24BE4C5580C"><description>myvisa</description></paymentInstrument><paymentInstrument paymentInstrumentID="35DA0E90-A3DC-4C48-93AD-415B1B1D59E0"><description>otre Visa</description></paymentInstrument></user></getUserProfileResponse>
;curl -v -k -H "Content-Type: text/xml" -X POST -d '<?xml version="1.0" encoding="utf-8"?><usr:listTUIDsForExpAccountRequest xmlns:usr="urn:com:expedia:www:services:user:messages:v3"><usr:expUser emailAddress="jmadynski@expedia.com"/><usr:pointOfSale tpid="1" eapid="0"/><usr:messageInfo enableTraceLog="false" clientName="localhost" transactionGUID="a2192179-d5b7-4234-918c-8f662aaaf545"/></usr:listTUIDsForExpAccountRequest>' 'https://userservicev3.integration.karmalab.net:56783/exp-account/tuids'
;<?xml version="1.0" encoding="utf-8" standalone="yes"?><listTUIDsForExpAccountResponse success="true" xmlns="urn:com:expedia:www:services:user:messages:v3"><expUser id="301078" emailAddress="jmadynski@expedia.com"/><expUserTUIDMapping tpid="1" tuid="5363093" singleUse="true" updateDate="2014-04-25T09:55:00.000-07:00"/><expUserTUIDMapping tpid="1" tuid="577015" singleUse="false" updateDate="2014-05-30T22:26:00.000-07:00"/><authRealmID>1</authRealmID></listTUIDsForExpAccountResponse>



;<?xml version="1.0" encoding="utf-8" standalone="yes"?><getUserProfileResponse success="false" xmlns="urn:com:expedia:www:services:user:messages:v3"><errorMessage errorCode="IllegalArguments">Invalid traveler (LoggedInTUID: 577015 or ActAsTUID: 577015).</errorMessage></getUserProfileResponse>
;<?xml version="1.0" encoding="utf-8" standalone="yes"?><getUserProfileResponse success="true" xmlns="urn:com:expedia:www:services:user:messages:v3"><user passengerType="2" emailAddress="jmadynski@expedia.com" loginName="577015_EmailSignIn" hasGroups="false" locale="en_US"><personalName titleID="0" first="Elmer" middle="" last="Fudd"/><preferredPhone countryCode="1" phoneNumber="(415) 5050490"/><paymentInstrument paymentInstrumentID="75F85DBA-9274-4FC3-B7D6-E24BE4C5580C"><description>myvisa</description></paymentInstrument><paymentInstrument paymentInstrumentID="35DA0E90-A3DC-4C48-93AD-415B1B1D59E0"><description>otre Visa</description></paymentInstrument></user></getUserProfileResponse>
