(ns leiningen.test.box.providers.virtualbox
  (:use clojure.test
        leiningen.box.providers.virtualbox))

(defn- slurp-resource [name]
  (slurp (clojure.java.io/resource name)))

(deftest virtualbox-info
  (let [name (-> (slurp-resource "test/showvminfo")
                 info->map
                 (get "name"))]
    (is (= name "paduka_1347891541"))))

(deftest test-forwarded-ports
  (let [ports (-> (slurp-resource "test/showvminfo")
                  forwarded-ports)]
    (is (= ports
           [["1" ["2to-2to" "3000" "300"] ["ssh" "2222" "2"]] ["2" ["Sinatra" "4567" "456"]] ["3"] ["4"] ["5"] ["6"] ["7"] ["8"]]))))

(deftest imported-uuid
  (let [uuid (-> (slurp-resource "test/list-vms")
                 (machine-uuid "lucid64"))]
    (is (= uuid "c334df61-aafe-4d66-8ab2-94942738ca65"))))

(deftest set-name
  (let [uuid "c334df61-aafe-4d66-8ab2-94942738ca65"
        name "project_134789154"
        cmd  (set-name-cmd uuid name)]
    (is (= cmd ["VBoxManage" "modifyvm" uuid "--name" name]))))

(deftest list-machines
  (let [cmd (list-vms-cmd)]
    (is (= cmd ["VBoxManage" "list" "vms"]))))

(deftest test-destroy-vm-cmd
  (let [uuid "c334df61-aafe-4d66-8ab2-94942738ca65"
        cmd (destroy-vm-cmd uuid)]
    (is (= cmd ["VBoxManage" "unregistervm" uuid "--delete"]))))

(deftest test-get-guestaddition-version-cmd
  (let [uuid "c334df61-aafe-4d66-8ab2-94942738ca65"
        cmd (get-guestaddition-version-cmd uuid)]
    (is (= cmd ["VBoxManage" "guestproperty" "get" uuid "/VirtualBox/GuestAdd/Version"]))))

(deftest test-get-guestaddition-version
  (let [version (-> (slurp-resource "test/get-guestaddition-version")
                    (get-guestaddition-version))]
    (is (= version "4.2.0"))))

(deftest test-read-vm-state
  (let [state (-> (slurp-resource "test/showvminfo")
                  (read-vm-state))]
    (is (= state "running"))))

(deftest test-read-vm-state-inaccessible
  (let [state (-> "name=\"<inaccessible>\""
                  (read-vm-state))]
    (is (= state "inaccessible"))))
