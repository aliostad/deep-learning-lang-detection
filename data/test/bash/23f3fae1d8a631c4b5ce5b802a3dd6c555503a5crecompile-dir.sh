#!/bin/bash

# This script recompiles the current directory
DIR=~/.emacs.d

#~/dev/stuff/emacs-stuff/emacs/nextstep/Emacs.app/Contents/MacOS/Emacs \
/Applications/Emacs.app/Contents/MacOS/Emacs \
        --eval "(defconst home-dir \"$DIR\")" \
        --eval "(defun home-dir/ (&optional file)
                  (setq file (or file \"\"))
                  (concat home-dir \"/\" file))" \
	--eval "(defmacro add-to-load-path (path)
		  \`(add-to-list 'load-path ,(expand-filename path)))" \
	--eval "(add-to-list 'load-path \"$DIR\")" \
        --eval '(load "utils.el")' \
	--eval '(load "load-paths.el")' \
    --eval '(load "configs.el")' \
	--eval "(byte-recompile-directory \"${DIR}\" 0)" \
	--batch

rm -f lisp-stuff.elc load-paths.elc hooks.elc configs.elc erc-config.elc \
      init.elc utils.elc

