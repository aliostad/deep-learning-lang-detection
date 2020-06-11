(ns sifaka.io
  (:require (sifaka [packets :as p]
                    [util :as util]))
  (:import [java.io FileInputStream InputStream OutputStream DataOutputStream]
           [java.nio ByteBuffer]
           [java.nio.channels DatagramChannel]
           [java.net InetSocketAddress Socket]))

(defn read-file
  ^{:doc "Read a (binary) file into a byte array. Used only for testing."}
  [name]
  (let [f (FileInputStream. name)
        ba (byte-array (.available f))] ; Assumption: ".available" returns all.
    (.read f ba)
    (.close f)
    ba))

(defn transmit-payload
  ^{:doc "Transmit a byte-array payload, assumed to be complete
          with <RESET/> clause, project tags, etc.
          So... it's actually a TCP socket, despite being
          packet-formatted. Still cargo-culting the
          packet segmentation; that may not be necessary, but the client
          is really brittle."}
  [host port ba]
  (let [sock (Socket. host port)
        in-stream (.getInputStream sock)
        out-stream (.getOutputStream sock)]
    (try
      (doseq [packet (p/package-data ba)]
        (.write out-stream packet)
        (.flush out-stream))
      (finally (do (.close sock)
                   (.close in-stream)
                   (.close out-stream))))))
