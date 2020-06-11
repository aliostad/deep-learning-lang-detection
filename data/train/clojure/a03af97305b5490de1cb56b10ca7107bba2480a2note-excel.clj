(import '(javax.swing JFrame JTextField  JOptionPane JMenuItem JFileChooser JFormattedTextField)
  '(javax.swing.text MaskFormatter)
        '(java.awt.event ActionListener)
  '(java.awt ComponentOrientation)
  '(javax.swing.event MenuListener)
   '(java.awt GridLayout Component FileDialog)

   '(com.jacob.com Dispatch ComThread))
(use 'clojure.contrib.duck-streams)

(defmacro add-item-action [item action]
  "add a action as a listener listener to a item"
  `(.addActionListener ~item
         (proxy [ActionListener] []
     (~'actionPerformed [~'evt] ~action))))



(def xl (new Dispatch "Excel.Application"))
;(Dispatch/put xl "Visible" true)
;(def sdir "C:\\clojure\\waterfront\\cello")
(def adir (ref "C:\\clojure\\waterfront\\cello" ))

(defn foll-fn [file]
(dosync (ref-set adir file)))

(def wbl (.. Dispatch (get xl "Workbooks")(toDispatch)))
(def wb (.. Dispatch (call wbl "Open" @adir)(toDispatch)))

(def wsl (.. Dispatch (get wb "Worksheets")(toDispatch)))
;(def wol (.. Dispatch (call wsl "Open" sdir)(toDispatch)))

(def ws (.. Dispatch (call wsl "Item" 1)(toDispatch)))

;(Dispatch/put ws "Visible" true)
(defn print-on-cells [alon i k]
(let [m (.. Dispatch (call ws "Cells" i  (+ 2 k))(toDispatch))]

(if (seq alon)
(if (< k 8)
(do (. Dispatch put m "Value" (str (first alon)))
(print-on-cells (rest alon) i (inc k)))
(print-on-cells (rest alon) (inc i) 1)))))

(Dispatch/put xl "Visible" true)
;;(print-on-cells mad 7 1)

     
(defn process-file [file-name]
(map #(-> % second Double/parseDouble)
(re-seq #"=>\s[A-Z\s]*(\-?[0-9]+\.[0-9]+)"(slurp* file-name))))



(defn create-board-gui []
  "Create Converter"
  (let [frame (javax.swing.JFrame. "Notepad to Excel converter")
   bar (javax.swing.JMenuBar.)
   dni-item (JMenuItem. "DNI File")
   ost-item (JMenuItem. "OST File")
   file-menu (javax.swing.JMenu. "File")
  file-chooser (javax.swing.JFileChooser. ".")]

(add-item-action dni-item (do
       (.showOpenDialog file-chooser frame)
       (let [file (.getSelectedFile file-chooser)]
         (when file (print-on-cells (process-file file) 37 1)))))
(add-item-action  ost-item (do
         (.showOpenDialog file-chooser frame)
         (let [file (.getSelectedFile file-chooser)]
         (when file (foll-fn file)))))
        
 (doto file-menu
       (.add dni-item)
       (.add ost-item))
 (doto file-chooser
      (.setDialogTitle "Soduko File"))
   (doto bar
      (.add file-menu))

(doto frame
      (.setLayout (java.awt.GridLayout. 9 1))
      (.setSize 300 300)
      (.setJMenuBar bar)
      (.applyComponentOrientation ComponentOrientation/LEFT_TO_RIGHT)
      (.setVisible true))))
(create-board-gui)
