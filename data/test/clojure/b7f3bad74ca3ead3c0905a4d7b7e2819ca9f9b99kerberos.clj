(ns sarnowski.kerberos
  (:import (javax.security.auth.login Configuration AppConfigurationEntry AppConfigurationEntry$LoginModuleControlFlag LoginContext)
           (javax.security.auth.kerberos KerberosPrincipal)
           (javax.security.auth Subject)
           (java.security PrivilegedExceptionAction)
           (org.ietf.jgss GSSManager GSSCredential)
           (javax.security.auth.callback CallbackHandler NameCallback PasswordCallback)))

(defn- stringify-config [config]
  (into {} (map (fn [[k v]] [(name k) (str v)]) config)))

(def ^:private control-flags {::REQUIRED AppConfigurationEntry$LoginModuleControlFlag/REQUIRED
                              ::REQUISITE AppConfigurationEntry$LoginModuleControlFlag/REQUISITE
                              ::SUFFICIENT AppConfigurationEntry$LoginModuleControlFlag/SUFFICIENT
                              ::OPTIONAL AppConfigurationEntry$LoginModuleControlFlag/OPTIONAL})

(defn create-config
  "Create an in-memory JAAS configuration for the Kerberos login (instead of using a login.conf). See
  http://docs.oracle.com/javase/8/docs/jre/api/security/jaas/spec/com/sun/security/auth/module/Krb5LoginModule.html
  for possible keys as keywords."
  [jaas-config]
  (let [config (stringify-config (dissoc jaas-config :controlFlag))
        control-flag (if (:controlFlag jaas-config) (:controlFlag jaas-config) ::REQUIRED)]
    (proxy [Configuration] []
      (getAppConfigurationEntry [_]
        (into-array AppConfigurationEntry
                    [(AppConfigurationEntry. "com.sun.security.auth.module.Krb5LoginModule"
                                             (get control-flags control-flag)
                                             config)])))))

(defn create-service-subject
  "Logs in the local service user to be able to validate tickets later on. Returns the logged in subject or
  throws an exception."
  [principal #^Configuration config]
  (let [principals #{(KerberosPrincipal. principal)}
        subject (Subject. false principals #{} #{})
        ctx (LoginContext. "" subject nil config)]
    (.login ctx)
    (.getSubject ctx)))

(defn validate-ticket
  "Validates a given ticket blob and returns its detailed information. Throws an exception if not valid."
  [#^Subject service-subject #^bytes ticket]
  (Subject/doAs service-subject
                (proxy [PrivilegedExceptionAction] []
                  (run []
                    (let [credential nil                    ; hack to choose correct constructor
                          ctx (.. GSSManager (getInstance) (createContext #^GSSCredential credential))]
                      (try
                        (.acceptSecContext ctx ticket 0 (alength ticket))

                        {:principal (.getSrcName ctx)
                         :delegation (.getCredDelegState ctx)
                         :delegation-credential (if (.getCredDelegState ctx) (.getDelegCred ctx) nil)
                         :anonymity (.getAnonymityState ctx)
                         :integrity (.getIntegState ctx)
                         :lifetime (.getLifetime ctx)
                         :mechanism (.getMech ctx)
                         :mutual-auth (.getMutualAuthState ctx)}
                        (finally
                          (.dispose ctx))))))))

(defn login-user
  "Logs in a user with its username and password. Optionally can take additional callback functions for required input.
  Remember to manage the lifecycle of the returned LoginContext (logout if not required anymore to free the resources)."
  [username password #^Configuration config & {:keys [callback-fns]
                                               :or {callback-fns {}}}]
  (let [default-callback-fns {NameCallback #(.setName % username)
                              PasswordCallback #(.setPassword % (.toCharArray password))}
        callback-fns (merge default-callback-fns callback-fns)
        ctx (LoginContext. "" nil (proxy [CallbackHandler] []
                                    (handle [callbacks]
                                      (doseq [callback callbacks]
                                        (if-let [callback-fn (get callback-fns (class callback))]
                                          (callback-fn callback)
                                          (ex-info "requested callback not configured"
                                                   {:callback callback
                                                    :config config
                                                    :callback-fns callback-fns})))))
                           config)]
    (.login ctx)
    ctx))
