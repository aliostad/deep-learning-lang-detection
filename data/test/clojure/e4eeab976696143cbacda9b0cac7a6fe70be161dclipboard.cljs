(ns figdemo.spork.util.clipboard
  )

(defn copy! [the-string]
  (let [clip (ClipboardEvent. "copy")
        cb   (.clipboardData clip)
        _    (. cb (setData "text/plain" the-string))
        tgt (.target e)]
    (.dispatchEvent tgt clip)))

(defn paste! []
    (let [clip (ClipboardEvent. "paste")
          cb   (.clipboardData clip)
          res  (. cb (getData "text/plain"))
          tgt (.target e)]
      (.dispatchEvent tgt clip)))

;; var pasteEvent = new ClipboardEvent('paste');
;; pasteEvent.clipboardData.items.add('My string', 'text/plain');
;; document.dispatchEvent(pasteEvent);
        
;; var clip = new ClipboardEvent( 'copy'String );

;;     clip.clipboardData.setData( 'text/plain'String, data );

;;     clip.preventDefault();

 

;;     e.target.dispatchEvent( clip );
