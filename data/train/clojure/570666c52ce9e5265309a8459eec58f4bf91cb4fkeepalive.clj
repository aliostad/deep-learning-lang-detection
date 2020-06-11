(ns clj-libssh2.libssh2.keepalive
  "Manage the sending of keepalive messages."
  (:refer-clojure :exclude [send])
  (:require [net.n01se.clojure-jna :as jna]))

(def ^{:arglists '([session want-reply interval])} config
  "
   void libssh2_keepalive_config(LIBSSH2_SESSION *session,
                                 int want_reply,
                                 unsigned interval);"
  (jna/to-fn Void ssh2/libssh2_keepalive_config))

(def ^{:arglists '([session seconds-to-next])} send
  "
   int libssh2_keepalive_send(LIBSSH2_SESSION *session,
                              int *seconds_to_next);"
  (jna/to-fn Integer ssh2/libssh2_keepalive_send))
