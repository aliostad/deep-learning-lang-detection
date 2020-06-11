(ns gcpc.xml
  (:require [clojure.java.io :as io]
            [clojure.data.xml :as dxml]
            #_[clojure.tools.logging :as log]
            [onelog.core :as log])
  (:import (javax.xml.stream XMLInputFactory
                             XMLStreamReader
                             XMLStreamConstants)))

(defn xml-elements [events]
  (dxml/seq-tree
   (fn [^clojure.data.xml.Event event contents]
     (when (= :start-element (.type event))
       (clojure.data.xml.Element. (.name event) (.attrs event) contents)))
   (fn [^clojure.data.xml.Event event]
     (when-not (= :characters (.type event))
       (log/debug (.type event) " " (.name event)))
     (= :end-element (.type event)))
   (fn [^clojure.data.xml.Event event]
     (.str event))
   events))

(defn socket-xml-element-seq [socket ffun]
  (->> socket
       io/input-stream
       dxml/source-seq
       (remove ffun)
       xml-elements))

#_(run! println
      (first (socket-xml-element-seq (io/file "/tmp/fifo")
                                     #(= :stream (.name %)))))

#_(with-in-str "<a><b/><c/></a>"
  (->> (dxml/source-seq *in*)
       (remove #(= :a (.name %)))
       dxml/event-tree
       ;; first
       (run! println)))

#_(with-in-str "<stream:stream from=\"gmail.com\" id=\"125402E5B921EA58\" version=\"1.0\" xmlns:stream=\"http://etherx.jabber.org/streams\" xmlns=\"jabber:client\"><stream:features><mechanisms xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\"><mechanism>X-OAUTH2</mechanism><mechanism>X-GOOGLE-TOKEN</mechanism><mechanism>PLAIN</mechanism></mechanisms></stream:features><success xmlns=\"urn:ietf:params:xml:ns:xmpp-sasl\"/>
</stream:stream>
<stream:stream from=\"gmail.com\" id=\"72BD9C117B382754\" version=\"1.0\" xmlns:stream=\"http://etherx.jabber.org/streams\" xmlns=\"jabber:client\"><stream:features><bind xmlns=\"urn:ietf:params:xml:ns:xmpp-bind\"/><session xmlns=\"urn:ietf:params:xml:ns:xmpp-session\"/></stream:features> </stream:stream>"
  (doall (dxml/source-seq *in*)))
