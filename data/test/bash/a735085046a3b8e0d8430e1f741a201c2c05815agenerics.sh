#!/bin/bash

IFS=$'\n';
for a in $(grep '^(add-method' bindings-ss.ss|awk '{print $2}'|sort -u); do
    case $a in
        initialize)
            continue
            ;;


        load)
            cat <<EOF
(cond ((not (eqv? <generic> (class-of load)))
       (let ((system-load load))
         (set! load (make-generic))
         (add-method load
           (make-method (list <string>)
             (lambda (cnm spec) (system-load spec)))))))
EOF
            ;;
        

        *)
            cat <<EOF
(define $a (make-generic))
EOF
            ;;
    esac
done
