; Licensed to the Apache Software Foundation (ASF) under one
; or more contributor license agreements. See the NOTICE file
; distributed with this work for additional information
; regarding copyright ownership. The ASF licenses this file
; to you under the Apache License, Version 2.0 (the
; "License"); you may not use this file except in compliance
; with the License. You may obtain a copy of the License at
;
; http://www.apache.org/licenses/LICENSE-2.0
;
; Unless required by applicable law or agreed to in writing, software
; distributed under the License is distributed on an "AS IS" BASIS,
; WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
; See the License for the specific language governing permissions and
; limitations under the License.

(ns dda.pallet.dda-hardening-crate.infra.ossec
  (:require
    [schema.core :as s]
    [clojure.string :as string]
    [pallet.actions :as actions]
    [pallet.stevedore :as stevedore]))

(def OssecConfig {:server-ip s/Str
                   :agent-key s/Str})

(defn ossec-agent-configuration
  [ossec-server-ip]
  ["<!------ Managed by pallet ------->"
   "<ossec_config>"
   "<client>"
   (str "  <server-ip>" ossec-server-ip "</server-ip>")
   "</client>"
   ""
   "<syscheck>"
   "  <!-- Frequency that syscheck is executed -- default every 2 hours -->"
   "  <frequency>7200</frequency>"
   "  "
   "  <!-- Directories to check  (perform all possible verifications) -->"
   "  <directories check_all=\"yes\">/etc,/usr/bin,/usr/sbin</directories>"
   "  <directories check_all=\"yes\">/bin,/sbin</directories>"
   "  "
   "  <!-- Files/directories to ignore -->"
   "  <ignore>/etc/mtab</ignore>"
   "  <ignore>/etc/hosts.deny</ignore>"
   "  <ignore>/etc/mail/statistics</ignore>"
   "  <ignore>/etc/random-seed</ignore>"
   "  <ignore>/etc/adjtime</ignore>"
   "  <ignore>/etc/httpd/logs</ignore>"
   "</syscheck>"
   ""
   "<rootcheck>"
   "  <rootkit_files>/var/ossec/etc/shared/rootkit_files.txt</rootkit_files>"
   "  <rootkit_trojans>/var/ossec/etc/shared/rootkit_trojans.txt</rootkit_trojans>"
   "</rootcheck>"
   ""
   "<localfile>"
   "  <log_format>syslog</log_format>"
   "  <location>/var/log/auth.log</location>"
   "</localfile>"
   ""
   ""
   "<localfile>"
   "  <log_format>apache</log_format>"
   "  <location>/var/log/apache2/access.log</location>"
   "</localfile>"
   ""
   "<localfile>"
   "  <log_format>apache</log_format>"
   "  <location>/var/log/apache2/ssl-access.log</location>"
   "</localfile>"
   ""
   "<localfile>"
   "  <log_format>apache</log_format>"
   "  <location>/var/log/apache2/other_vhosts_access.log</location>"
   "</localfile>"
   ""
   "<localfile>"
   "  <log_format>apache</log_format>"
   "  <location>/var/log/apache2/error.log</location>"
   "</localfile>"
   "</ossec_config>"
   ""]

 (s/defn install-ossec
   "Install the ossec client"
   [config :- OssecConfig]
   (actions/package-source "ossec"
      :aptitude
      {:url "http://ossec.alienvault.com/repos/apt/ubuntu"
       :release "trusty"
       :key-url "http://ossec.alienvault.com/repos/apt/conf/ossec-key.gpg.key"
       :scopes ["main"]}
    (actions/package-manager :update)
    (actions/package "ossec-hids-agent")))


 (s/defn configure-ossec
   "configure the ossec client. Restart client is a missing feature."
   [config :- OssecConfig]
   (actions/exec
      {:language :bash}
      (stevedore/script
        ((str "echo \"y\n\"|" "/var/ossec/bin/manage_agents -i " ~(get-in config [:agent-key]))))
    (actions/remote-file
       "/var/ossec/etc/ossec.conf"
       :owner "root"
       :group "ossec"
       :mode "440"
       :force true
       :content (string/join
                  \newline
                  (ossec-agent-configuration (get-in config [:server-ip])))))))
