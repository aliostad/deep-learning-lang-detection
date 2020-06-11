(in-ns 'dj.io)

(defprotocol Ipoop
  "Behave like clojure.core/spit but generically to any destination"
  (poop [dest txt] [dest txt append] "send data to file"))

(defprotocol Ieat
  "Behave like clojure.core/slurp but generically to any destination"
  (eat [dest] "obtain data from file"))

(defprotocol Imkdir
  "make a directory"
  (mkdir [dest]))

(defprotocol Ils
  "return list of files in that directory"
  (ls [dest]))

(defprotocol Irm
  "deletes path recursively"
  (rm [target]))

(defprotocol Imv
  "renames or moves file"
  (mv [target dest]))

(defprotocol Irelative-to
  "returns new abstract file relative to existing one"
  (relative-to [folder path]))

(defprotocol Iparent
  "returns parent file to existing one"
  (parent [f]))

(defprotocol Call
  "Allow a task to be executed by the executor"
  (call [executor body]))

(defprotocol RFuture
  "return a future object to manage the executor"
  (rfuture [executor body]))

(defprotocol Iget-name
  "for file like objects, get-name will return the last name in the name sequence of the path"
  (get-name [f]))

(defprotocol Iget-path
  "get str path for file like objects"
  (get-path [f]))

(defprotocol Iexists
  "return true if file exists"
  (exists? [f]))

(defmulti cp #(vector (type %1) (type %2)))
