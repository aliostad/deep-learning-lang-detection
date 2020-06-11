(ns banky-clj.core)

;============= handle application state
(def appdata-defaults
  {:accounts
         {:test {:name "Test account"
                 :transactions []}
          :dev {:name "Developer account"
                :transactions []}}})

(def appdata
  (atom appdata-defaults))

(defn load-appdata [] @appdata)

(defn save-appdata [data]
  (swap! appdata (fn [_] data)))

(defn reset-appdata [] (reset! appdata appdata-defaults))

;============= manage source file headers
(def headers
  (list
    {:kirjauspaiva "Kirjauspäivä"}
    {:arvopaiva "Arvopäivä"}
    {:maara "Määrä  EUROA"}
    {:laji "Laji"}
    {:selitys "Selitys"}
    {:saaja_maksaja "Saaja/Maksaja"}
    {:saajan_tilinro "Saajan tilinumero ja pankin BIC"}
    ;:bic parsed from :saajan_tilinro
    {:viite "Viite"}
    {:viesti "Viesti"}
    {:arkistointitunnus "Arkistointitunnus"}))

(def headers-keys (map #(first (keys %)) headers))
(def headers-vals (map #(first (vals %)) headers))

;============= read source data

;account number and bic separation
;only if account number given, otherwise return nil bic
(defn read-account-and-bic [account]
  (if (empty? account) {:bic nil}
  (let [fields (clojure.string/split account #" / ")]
    (array-map
     :saajan_tilinro (first fields)
     :bic (last fields)))))

;split lines and trim pieces, mark empty pieces as nil
(defn split-line [line]
  (map (fn [entry]
         (let [piece (clojure.string/trim
                      (clojure.string/replace entry #"[\"]" ""))]
           (if (empty? piece) nil piece)))
       (clojure.string/split line #";")))

; convert from string to ISO 8601
;05.08.2013 -> 2013-08-05
;a hack until I include clj-time
(defn convert-dates [datestring]
  (if-not (empty? datestring)
  (let [fields (clojure.string/split datestring #"\.")
        day    (first fields)
        month  (second fields)
        year   (last fields)]
    (str year "-" month "-" day))))

;read one entry
(defn read-entry [line]
  (let [fields (split-line line)
        rawmap (zipmap headers-keys fields)
        kdate (convert-dates (nth fields 0 nil))
        adate (convert-dates (nth fields 1 nil))
        accountmap (read-account-and-bic (nth fields 6 nil))]
    (merge
      rawmap
      accountmap
      ;date conversion is a bit hacky at the moment
      {:kirjauspaiva kdate :arvopaiva adate})))

;read all entries
(defn import-rawdata [data]
  (map
    #(read-entry %)
    (seq (clojure.string/split data #"\n"))))

;read source input and update appdata
;this is a bit hacky, must refactor
(defn read-and-save-entry [account sourceline]
  (let [entrymap (read-entry sourceline)
        oldaccount
          (get-in @appdata [:accounts account])
        newaccount
          (update-in oldaccount [:transactions] conj entrymap)
        newappdata
          (update-in @appdata [:accounts account] merge newaccount)]
    (save-appdata newappdata))

;do something like this instead
;(swap! @appdata update-in
;       [:accounts account :transactions]
;       conj entrymap)
  )

;============= load data from file
(defn load-data-from-file [account file]
  (with-open [r (clojure.java.io/reader
                 file
                 :encoding "ISO-8859-1")]
    (doseq [line (line-seq r)]
      (read-and-save-entry account line))))

;============= filter data
;match transaction entry against regex
(defn match-regex? [entry attr regex]
  (if-not (empty? (attr entry))
    (let [v (attr entry)]
      (if (re-matches regex v) true false))))

;match all values against given regex
(defn filter-entries [dataset attr regex]
  (filter
   #(match-regex? % attr regex)
   dataset))

;group entries by given field :keyword
(defn group-entries [field data]
  (group-by field data))
