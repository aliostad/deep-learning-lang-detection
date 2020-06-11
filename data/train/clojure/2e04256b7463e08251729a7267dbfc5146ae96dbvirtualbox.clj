(ns leiningen.box.providers.virtualbox
  (:require [leiningen.box.datastore :as store]
            [clj-shell.shell :refer (sh)]
            [clojure.string :as s]
            [cheshire.core :refer :all]
            [clojure.algo.monads :refer :all]))

(defn- line->pair [line]
  (let [[key value] (s/split line #"=" 2)]
    [key (s/replace value #"^\"|\"$" "")]))

(defn info->map [input]
  (->> (s/split-lines input)
       (map line->pair)
       (into {})))

(defn vm-show-info []
  ["VBoxManage" "showvminfo" "602c73f1-002e-48b6-a73a-7e5fc0d3d7b1" "--machinereadable"])

(defn vm-directory []
  ; TODO: dynamically determine this directory
  "/Users/henry/.vagrant.d/boxes/")

(defn vm-import-cmd [name]
  ["VBoxManage" "import" (str (vm-directory) name "/box.ovf")])

(defn machine-uuid [input name]
  (let [re (re-pattern (str "\"" name "\" \\{(.+?)\\}"))]
    (second (re-find re input))))

(defn forwarded-ports [input]
  (let [matches (drop 1 (s/split input #"nic"))
        nic (partial re-find #"^\d")
        ports (fn [x] (map (partial drop 1) (re-seq #"Forwarding\(\d\)=\"([^,]+),[^,].+?(\d+).+?(\d+).+?\"" x)))]
    (map #(-> % ports (conj (nic %))) matches)))

(defn set-name-cmd [uuid value]
  ["VBoxManage" "modifyvm" uuid  "--name" value])

(defn list-vms-cmd []
  ["VBoxManage" "list" "vms"])

(defn set-uuid [datastore uuid]
  (spit datastore (generate-string {"active" {"default" uuid}})))

(defn get-uuid [datastore]
  (try (get-in (parse-string (slurp datastore)) ["active" "default"])
       (catch java.io.FileNotFoundException e nil)))

(defn destroy-vm-cmd [uuid]
  ["VBoxManage" "unregistervm" uuid "--delete"])

(defn get-guestaddition-version-cmd [uuid]
  ["VBoxManage" "guestproperty" "get" uuid "/VirtualBox/GuestAdd/Version"])

(defn get-guestaddition-version [input]
  (second (re-find #"Value: (.+)" input)))

(defn read-vm-state [input]
  (let [attrs (info->map input)]
    (if (-> attrs
            (get "name")
            (= "<inaccessible>"))
     "inaccessible"
     (get attrs "VMState"))))
