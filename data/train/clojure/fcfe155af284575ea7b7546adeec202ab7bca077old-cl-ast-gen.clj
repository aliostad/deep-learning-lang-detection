(ns org.cljgen.astgen)

(comment

  ;;; AST printer, much more concise than your CodeDOM and perhaps R# :-P
  ;;; Can be easily extended to support other language constructs &
  ;;; several languages simultaneously

  ;; pretty-print dispatch table: type -> printing func correspondence
  (defvar *dispatch* (copy-pprint-dispatch))

  (defun ast-print (x &optional (stream *standard-output*))
    "Print the expression x using AST dispatch rules"
    (write x :pretty t :pprint-dispatch *dispatch* :stream stream))

  (defun ast-print-form (stream form)
    "Print the AST node (form)"
    (if (and (symbolp (first form))
          (get (first form) 'ast-form))
      (funcall (get (first form) 'ast-form) stream form)
      (error "unknown form: ~S" form)))

  ;; set dispatch function for cons type in our pretty-print dispatch table
  (set-pprint-dispatch 'cons #'ast-print-form 0 *dispatch*)

  (defmacro defprinter (name args &body body)
    "Define a printer for specified AST node type"
    (let ((func-name (intern (format nil "PRINT-FORM-~A" name)))
           (item (gensym)))
      `(progn
         (defun ,func-name (stream ,item)
           (destructuring-bind ,args (rest ,item)
             ,@body))
         (setf (get ',name 'ast-form) ',func-name))))

  )