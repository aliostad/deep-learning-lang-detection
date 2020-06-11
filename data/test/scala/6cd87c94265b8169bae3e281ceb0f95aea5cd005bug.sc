(define (fail) (error 'fail "Top level fail"))

(define (a-boolean)
 (call-with-current-continuation
  (lambda (c)
   (let ((old-fail fail))
    (set! fail (lambda () (set! fail old-fail) (c #f))))
   (c #t))))

(define (test1)
 (let ((values '()))
  (call-with-current-continuation
   (lambda (return)
    (let ((old-fail fail))
     (set! fail (lambda () (set! fail old-fail) (return #f)))
     (set! values
	   (cons (map (lambda (x) (list (a-boolean) x)) '(a b)) values))
     (fail))))
  values))

(define (my-map f l)
 (if (null? l) '() (cons (f (car l)) (my-map f (cdr l)))))

(define (test2)
 (let ((values '()))
  (call-with-current-continuation
   (lambda (return)
    (let ((old-fail fail))
     (set! fail (lambda () (set! fail old-fail) (return #f)))
     (set! values
	   (cons (my-map (lambda (x) (list (a-boolean) x)) '(a b)) values))
     (fail))))
  values))
