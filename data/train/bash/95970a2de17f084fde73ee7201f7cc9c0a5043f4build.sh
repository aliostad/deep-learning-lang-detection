#!/bin/sh

OUTPUT=utils

rm -f $OUTPUT

../buildapp-1.1/buildapp                                   \
    --load "$HOME/.sbclrc"                                 \
    --load "$HOME/Programming/lisp/quicklisp-setup"        \
    --eval "(ql:quickload \"trivial-shell\")"              \
    --load-system "cl-fad"                                 \
    --eval "(ql:quickload \"drakma\")"                     \
    --eval "(ql:quickload \"split-sequence\")"             \
    --eval "(ql:quickload \"clx\")"                        \
    --eval "(ql:quickload \"alexandria\")"                 \
    --eval "(ql:quickload \"cl-libxml2\")"                 \
    --eval "(ql:quickload \"cl-who\")"                     \
    --eval "(ql:quickload \"lisp-unit\")"                  \
    --eval "(ql:quickload \"shelisp\")"                    \
    --load-system "stumpwm"                                \
    --load "short-lambda"                                  \
    --load "stumpwm"                                       \
    --load "utils.lisp"                                    \
    --load "randBG"                                        \
    --load "InterfaceLisp"                                 \
    --load "comics"                                        \
    --output "$OUTPUT"                                     \
    --dispatched-entry "randBG/randBG:main"                \
    --dispatched-entry "InterfaceLift/interface-lift:main" \
    --dispatched-entry "/utils:run-repl"                   \
    --dispatched-entry "comics/comics:main"                \
    --dispatched-entry "stumpwm/stumpwm:main"

