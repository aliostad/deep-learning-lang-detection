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

(ns dda.pallet.dda-backup-crate.infra.lib.transport-lib-test
  (:require
   [clojure.test :refer :all]
   [schema.core :as s]
   ;[dda.pallet.dda-backup-crate.infra.core.backup-element-test :as backup-element]
   [dda.pallet.dda-backup-crate.infra.lib.transport-lib :as sut]))

(deftest move-local-test
  (testing
    (is (= ["# Move transported files to store"
            "mv /var/backups/transport-outgoing/* /var/backups/store"
            ""
            "# Manage old backup generations"
            "cd /var/backups/store"
            "# test wether pwd points to expected place"
            "if [ \"$PWD\" == \"/var/backups/store\" ]; then"]
           (sut/move-local
            "/var/backups/transport-outgoing"
            "/var/backups/store")))))
