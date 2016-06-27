(provide 'setup-programming)
;; GROUP: Programming -> Languages -> C

;; Available C style:
;; \u201cgnu\u201d: The default style for GNU projects
;; \u201ck&r\u201d: What Kernighan and Ritchie, the authors of C used in their book
;; \u201cbsd\u201d: What BSD developers use, aka \u201cAllman style\u201d after Eric Allman.
;; \u201cwhitesmith\u201d: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; \u201cstroustrup\u201d: What Stroustrup, the author of C++ used in his book
;; \u201cellemtel\u201d: Popular C++ coding standards as defined by \u201cProgramming in C++, Rules and Recommendations,\u201d Erik Nyquist and Mats Henricson, Ellemtel
;; \u201clinux\u201d: What the Linux developers use for kernel development
;; \u201cpython\u201d: What Python developers use for extension modules
;; \u201cjava\u201d: The default style for java-mode (see below)
;; \u201cuser\u201d: When you want to define your own style
(setq c-default-style "linux" ; set style to "linux"
      c-basic-offset 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GROUP: Programming -> Tools -> Gdb ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(setq gdb-many-windows t        ; use gdb-many-windows by default
      gdb-show-main t)          ; Non-nil means display source file containing the main routine at startup

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; GROUP: Programming -> Tools -> Compilation ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Compilation from Emacs
(defun prelude-colorize-compilation-buffer ()
  "Colorize a compilation mode buffer."
  (interactive)
  ;; we don't want to mess with child modes such as grep-mode, ack, ag, etc
  (when (eq major-mode 'compilation-mode)
    (let ((inhibit-read-only t))
      (ansi-color-apply-on-region (point-min) (point-max)))))

;; setup compilation-mode used by `compile' command
(require 'compile)
(setq compilation-ask-about-save nil          ; Just save before compiling
      compilation-always-kill t               ; Just kill old compile processes before starting the new one
      compilation-scroll-output 'first-error) ; Automatically scroll to first
(global-set-key (kbd "<f5>") 'compile)

;; GROUP: Programming -> Tools -> Makefile
;; takenn from prelude-c.el:48: https://github.com/bbatsov/prelude/blob/master/modules/prelude-c.el
(defun prelude-makefile-mode-defaults ()
  (whitespace-toggle-options '(tabs))
  (setq indent-tabs-mode t ))

(setq prelude-makefile-mode-hook 'prelude-makefile-mode-defaults)

(add-hook 'makefile-mode-hook (lambda ()
                                (run-hooks 'prelude-makefile-mode-hook)))

;; GROUP: Programming -> Tools -> Ediff
(setq ediff-diff-options "-w"
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)
