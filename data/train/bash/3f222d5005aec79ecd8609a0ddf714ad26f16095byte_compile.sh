#!/bin/sh

cd $HOME/.emacs.d

emacs --batch \
      --eval "(add-to-list 'load-path (expand-file-name \"~/.emacs.d\"))" \
      --eval "(add-to-list 'load-path (expand-file-name \"~/.emacs.d/modes\"))" \
      --eval "(add-to-list 'load-path (expand-file-name \"~/.emacs.d/interface-themes\"))" \
      --eval "(add-to-list 'load-path (expand-file-name \"~/.emacs.d/plugins\"))" \
      --eval "(add-to-list 'load-path (expand-file-name \"~/.emacs.d/plugins/auto-complete\"))" \
      --eval "(batch-byte-compile-if-not-done)" *.el
