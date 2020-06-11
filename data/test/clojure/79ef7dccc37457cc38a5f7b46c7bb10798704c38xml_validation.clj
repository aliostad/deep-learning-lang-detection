(ns uk.me.rkd.xml-validation)

(import 'javax.xml.XMLConstants)
(import 'org.xml.sax.SAXException)
(import 'javax.xml.validation.SchemaFactory)
(import 'java.io.File)
(import 'java.io.StringReader)
(import 'javax.xml.transform.stream.StreamSource)

(defn create-validation-fn [& schemas]
  (let [sources (into-array StreamSource (map #(-> (File. %)
                                                   (StreamSource.)) schemas))
        validator (-> (SchemaFactory/newInstance XMLConstants/W3C_XML_SCHEMA_NS_URI)
                      (.newSchema sources)
                      (.newValidator))]
    (fn [xmldoc]
      (try
        (.validate validator (StreamSource. (StringReader. xmldoc)))
        true
        (catch SAXException e false)))))
