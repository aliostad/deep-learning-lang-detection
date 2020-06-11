(ns bordeaux.core
  (:require [schema.core         :as s]
            [org.httpkit.client  :as http]))

(def HashCode128
  (s/both s/Str (s/pred #(= (count %) 32) 'length-of-32)))

(def URL
  (letfn [(valid-url? [s] 
            (try
              (do
                (java.net.URL. s)
                true)
              (catch java.net.MalformedURLException e false)))]
    (s/pred valid-url? 'valid-url?)))

(def Format
  (s/enum "csv" "json" "xml"))

(def APIRequestParams
  "Base schema for a REDCap API request"
  {:token HashCode128})

(def ExportRecordsRequestParams
  (merge APIRequestParams 
         {(s/optional-key :content)                (s/eq "record")
          (s/optional-key :format)                 Format
          (s/optional-key :type)                   (s/enum "flat" "eav" "record")

          (s/optional-key :records)                [s/Str]
          (s/optional-key :fields)                 [s/Str]
          (s/optional-key :forms)                  [s/Str] ;; TODO replace spaces with underscores
          (s/optional-key :events)                 [s/Str]
          (s/optional-key :rawOrLabel)             (s/enum "raw" "label")
          (s/optional-key :rawOrLabelHeaders)      (s/enum "raw" "label")
          (s/optional-key :exportCheckboxLabel)    s/Bool
          (s/optional-key :returnFormat)           Format
          (s/optional-key :exportSurveyFields)     s/Bool
          (s/optional-key :exportDataAccessGroups) s/Bool}))

(def ExportReportsRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)             (s/eq "report")
          (s/optional-key :report_id)           s/Num
          (s/optional-key :format)              Format

          (s/optional-key :returnFormat)        Format
          (s/optional-key :rawOrLabel)          (s/enum "raw" "label")
          (s/optional-key :exportCheckboxLabel) s/Bool}))

(def ImportRecordsRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)           (s/eq "record")
          (s/optional-key :format)            Format
          (s/optional-key :type)              (s/enum "flat" "eav" "record")
          (s/optional-key :overwriteBehavior) (s/enum "normal" "overwrite")
          (s/optional-key :data)              s/Any
          
          (s/optional-key :dateFormat)        (s/enum "MDY" "DMY" "YMD")
          (s/optional-key :returnContent)     [s/Str]
          (s/optional-key :returnFormat)      Format}))

(def ExportMetadataRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)      (s/eq "metadata")
          (s/optional-key :format)       Format

          (s/optional-key :fields)       [s/Str]
          (s/optional-key :forms)        [s/Str]
          (s/optional-key :returnFormat) Format}))

(def ExportFileRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)      (s/eq "file")
          (s/optional-key :action)       (s/eq "export")
          (s/optional-key :record)       s/Num
          (s/optional-key :field)        s/Str
          (s/optional-key :event)        s/Str

          (s/optional-key :returnFormat) Format}))

(def ImportFileRequestParams
  (merge APIRequestParams
         {(s/optional-key :content) (s/eq "file")
          (s/optional-key :action)  (s/eq "import")
          (s/optional-key :record)  s/Str
          (s/optional-key :field)   s/Str
          (s/optional-key :event)   s/Str
          (s/optional-key :file)    s/Any}))

(def DeleteFileRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)      (s/eq "file")
          (s/optional-key :action)       (s/eq "delete")
          (s/optional-key :record)       s/Str
          (s/optional-key :field)        s/Str
          (s/optional-key :event)        s/Str

          (s/optional-key :returnFormat) Format}))

(def ExportInstrumentsRequestParams
  (merge APIRequestParams
         {(s/optional-key :content) (s/eq "instrument")
          (s/optional-key :format)  Format}))

(def ExportEventsRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)      (s/eq "event")
          (s/optional-key :format)       Format
          
          (s/optional-key :arms)         [s/Num]
          (s/optional-key :returnformat) Format}))

(def ExportArmsRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)      (s/eq "arm")
          (s/optional-key :format)       Format
          
          (s/optional-key :arms)         [s/Num]
          (s/optional-key :returnFormat) Format}))

(def ExportInstrumentEventMappingsRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)      (s/eq "formEventMapping")
          (s/optional-key :format)       Format

          (s/optional-key :arms)         [s/Num]
          (s/optional-key :returnFormat) Format}))

(def ExportUsersRequestParams
  (merge APIRequestParams
         {(s/optional-key :content)      (s/eq "user")
          (s/optional-key :format)       Format

          (s/optional-key :returnFormat) Format}))

(def ExportREDCapVersionRequestParams
  (merge APIRequestParams
         {(s/optional-key :content) (s/eq "version")}))

(defn api-request
  [url params]
  (http/post url {:form-params params}))

(s/defn export-records :- s/Any
  "Export a set of records for a project"
  [url    :- URL
   params :- ExportRecordsRequestParams]
  (let [default-params {:content "record" 
                        :format  "xml"
                        :type    "flat"}]
    (api-request url (merge default-params params))))

(s/defn import-records :- s/Any
  "Import a set of records for a project."
  [url    :- URL
   params :- ImportRecordsRequestParams]
  (let [default-params {:content           "record"
                        :format            "xml"
                        :overwriteBehavior "normal"}]
    (api-request url (merge default-params params))))

(s/defn export-reports :- s/Any
  "Export the data set of a report created on a project's 'Data Exports, Reports, and Stats' page."
  [url    :- URL
   params :- ExportReportsRequestParams]
  (let [default-params {:content "report"
                        :format  "xml"}]
    (api-request url (merge default-params params))))

(s/defn export-metadata :- s/Any
  "Export the metadata for a project"
  [url    :- URL
   params :- ExportMetadataRequestParams]
  (let [default-params {:content "metadata"
                        :format  "xml"}]
    (api-request url (merge default-params params))))

(s/defn export-file :- s/Any
  "Export a document that has been attached to an individual record."
  [url    :- URL
   params :- ExportFileRequestParams]
  (let [default-params {:content "file"
                        :action  "export"}]
    (api-request url (merge default-params params))))

(s/defn import-file :- s/Any
  "Import a document that will be attached to an individual record."
  [url    :- URL
   params :- ImportFileRequestParams]
  (let [default-params {:content "file"
                        :action  "import"}]
    (api-request url (merge default-params params))))

(s/defn delete-file :- s/Any
  "Delete a document that has been attached to an invidual record."
  [url    :- URL
   params :- DeleteFileRequestParams]
  (let [default-params {:content "file"
                        :action  "delete"}]
    (api-request url (merge default-params params))))

(s/defn export-instruments :- s/Any
  "Export a list of the data collection instruments for a project."
  [url    :- URL
   params :- ExportInstrumentsRequestParams]
  (let [default-params {:content "instrument"
                        :format  "xml"}]
    (api-request url (merge default-params params))))

(s/defn export-events :- s/Any
  "Export the events for a project."
  [url    :- URL
   params :- ExportEventsRequestParams]
  (let [default-params {:content "event"
                        :format  "xml"}]
    (api-request url (merge default-params params))))

(s/defn export-arms :- s/Any
  "Export the arms for a project."
  [url    :- URL
   params :- ExportArmsRequestParams]
  (let [default-params {:content "arm"
                        :format  "xml"}]
    (api-request url (merge default-params params))))

(s/defn export-instrument-event-mappings :- s/Any
  "Export the instrument-event mappings for a project."
  [url    :- URL
   params :- ExportInstrumentEventMappingsRequestParams]
  (let [default-params {:content "formEventMapping"
                        :format  "xml"}]
    (api-request url (merge default-params params))))

(s/defn export-users :- s/Any
  "Export the users for a project."
  [url    :- URL
   params :- ExportUsersRequestParams]
  (let [default-params {:content "user"
                        :format  "xml"}]
    (api-request url (merge default-params params))))

(s/defn export-redcap-version :- s/Any
  "Returns the current REDCap version number."
  [url    :- URL
   params :- ExportREDCapVersionRequestParams]
  (let [default-params {:content "version"}]
    (api-request url (merge default-params params))))
