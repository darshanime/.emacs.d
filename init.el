(require 'package)
(add-to-list 'package-archives
             '("melpa-milkbox" . "http://melpa.milkbox.net/packages/") t)

(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/") t)

(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)

;; adding imagemagick path to PATH env
(setenv "PATH" (concat (getenv "PATH") "/usr/local/Cellar/imagemagick/7.0.6-6"))

;; install use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

(use-package yafolding
  :config
  (yafolding-mode 1)
  (add-hook 'prog-mode-hook
            (lambda () (yafolding-mode)))
  (defvar yafolding-mode-map
    (let ((map (make-sparse-keymap)))
      (define-key map (kbd "<C-S-return>") #'yafolding-hide-parent-element)
      (define-key map (kbd "<C-M-return>") #'yafolding-toggle-all)
      (define-key map (kbd "<C-return>") #'yafolding-toggle-element)
      map)))

;; (use-package aggressive-indent-mode)

(use-package clojure-mode
  :config
  (add-hook 'clojure-mode-hook #'subword-mode)
  (add-hook 'clojure-mode-hook #'smartparens-strict-mode)
  (add-hook 'clojure-mode-hook #'aggressive-indent-mode)
  )

(use-package cider)
(use-package auto-complete
  :config
  (require 'auto-complete-config)
  (ac-config-default)
  )

(use-package ac-c-headers
  :config
  (add-hook 'c-mode-hook
            (lambda ()
              (add-to-list 'ac-sources 'ac-source-c-headers)
              (add-to-list 'ac-sources 'ac-source-c-header-symbols t)))
  )

(use-package google-c-style
  :config
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent)
  )
(use-package flymake-cursor)
(use-package iedit)
(use-package flymake-google-cpplint
  :config
  (add-hook 'c++-mode-hook 'flymake-google-cpplint-load))

(use-package jq-mode
  :config
  (autoload 'jq-mode "jq-mode.el"
    "Major mode for editing jq files" t)
  (add-to-list 'auto-mode-alist '("\\.jq$" . jq-mode))
  (with-eval-after-load "json-mode"
  (define-key json-mode-map (kbd "C-c C-j") #'jq-interactively))
  )

(use-package lispy
  :defer t
  ;; :bind (:map lispy-mode-map
  ;;             ("C-e" . nil)
  ;;             ("/" . nil)
  ;;             ("M-i" . nil)
  ;;             ("M-e" . lispy-iedit)
  ;;             ("S" . special-lispy-splice)
  ;;             ("g" . special-lispy-goto-local)
  ;;             ("G" . special-lispy-goto))
  :init
  (dolist (hook '(emacs-lisp-mode-hook
                  lisp-interaction-mode-hook
                  lisp-mode-hook
                  scheme-mode-hook
                  clojure-mode-hook))
    (add-hook hook (lambda () (lispy-mode 1)))))

(use-package lorem-ipsum
  :config
  (lorem-ipsum-use-default-bindings))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; files from custom dir  ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; FORMERLY in custom/setup-applications.el
;; (require 'eshell)
;; (require 'em-alias)
;; (require 'cl)

;; Advise find-file-other-window to accept more than one file
;; (defadvice find-file-other-window (around find-files activate)
;;   "Also find all files within a list of files.  This even works recursively."
;;   (if (listp filename)
;;       (loop for f in filename do (find-file-other-window f wildcards))
;;     ad-do-it))

;; In Eshell, you can run the commands in M-x
;; Here are the aliases to the commands.
;; $* means accepts all arguments.
;; (eshell/alias "o" "")
;; (eshell/alias "o" "find-file-other-window $*")
;; (eshell/alias "vi" "find-file-other-window $*")
;; (eshell/alias "vim" "find-file-other-window $*")
;; (eshell/alias "emacs" "find-file-other-windpow $*")
;; (eshell/alias "em" "find-file-other-window $*")

;; (add-hook 'eshell-mode-hook (lambda () (setq pcomplete-cycle-completions nil)))

;; change listing switches based on OS
;; (when (not (eq system-type 'windows-nt))
;;   (eshell/alias "ls" "ls --color -h --group-directories-first $*"))


;; FORMERLY in custom/setup-convience.el
;; GROUP: Convenience -> Revert

;; Global Auto Revert mode is a global minor mode that reverts any
;; buffer associated with a file when the file changes on disk.
(global-auto-revert-mode)

;; GROUP: Convenience -> Hippe Expand
;; hippie-expand is a better version of dabbrev-expand.
;; While dabbrev-expand searches for words you already types, in current;; buffers and other buffers, hippie-expand includes more sources,
;; such as filenames, klll ring...
;; (global-set-key (kbd "M-/") 'hippie-expand) ;; replace dabbrev-expand
;; (setq
;;  hippie-expand-try-functions-list
;;  '(try-expand-dabbrev ;; Try to expand word "dynamically", searching the current buffer.
;;    try-expand-dabbrev-all-buffers ;; Try to expand word "dynamically", searching all other buffers.
;;    try-expand-dabbrev-from-kill ;; Try to expand word "dynamically", searching the kill ring.
;;    try-complete-file-name-partially ;; Try to complete text as a file name, as many characters as unique.
;;    try-complete-file-name ;; Try to complete text as a file name.
;;    try-expand-all-abbrevs ;; Try to expand word before point according to all abbrev tables.
;;    try-expand-list ;; Try to complete the current line to an entire line in the buffer.
;;    try-expand-line ;; Try to complete the current line to an entire line in the buffer.
;;    try-complete-lisp-symbol-partially ;; Try to complete as an Emacs Lisp symbol, as many characters as unique.
;;    try-complete-lisp-symbol) ;; Try to complete word as an Emacs Lisp symbol.
;;  )

(setq ibuffer-use-other-window t) ;; always display ibuffer in another window
;; (add-hook 'prog-mode-hook 'linum-mode) ;; enable linum only in programming modes
(add-hook 'prog-mode-hook (lambda () (interactive) (setq show-trailing-whitespace 1))) ;; whitespace is highlighted in prog-mode
(global-set-key (kbd "C-c w") 'whitespace-mode) ;; view all whitespace characters

(setq-default indent-tabs-mode nil)
(delete-selection-mode)                 ; deletes selected text if you start typing
(global-set-key (kbd "RET") 'newline-and-indent)


;; easier window navigation
;; (windmove-default-keybindings) --> won't work well with org-mode windowns
(use-package windmove
  ;; :defer 4
  :ensure t
  :config
  ;; use command key on Mac
  (windmove-default-keybindings 'super)
  ;; wrap around at edges
  (setq windmove-wrap-around t))

;; (use-package transmission)

;; saveplace remembers your location in a file when saving files
(use-package saveplace
  :init
  ;; (save-place-mode) --> for emacs 25
  (progn
    (setq-default save-place t)))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customized functions                ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun prelude-move-beginning-of-line (arg)
  "Move point back to indentation of beginning of line.

Move point to the first non-whitespace character on this line.
If point is already there, move to the beginning of the line.
Effectively toggle between the first non-whitespace character and
the beginning of the line.

If ARG is not nil or 1, move forward ARG - 1 lines first.
If point reaches the beginning or end of the buffer, stop there."
  (interactive "^p")
  (setq arg (or arg 1))

  ;; Move lines first
  (when (/= arg 1)
    (let ((line-move-visual nil))
      (forward-line (1- arg))))

  (let ((orig-point (point)))
    (back-to-indentation)
    (when (= orig-point (point))
      (move-beginning-of-line 1))))

(global-set-key (kbd "C-a") 'prelude-move-beginning-of-line)

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; kill a line, including whitespace characters until next non-whiepsace character
;; of next line
(defadvice kill-line (before check-position activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode
                                latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1)))))

;; taken from prelude-editor.el
;; automatically indenting yanked text if in programming-modes
(defvar yank-indent-modes
  '(LaTeX-mode TeX-mode)
  "Modes in which to indent regions that are yanked (or yank-popped).
Only modes that don't derive from `prog-mode' should be listed here.")

(defvar yank-indent-blacklisted-modes
  '(python-mode slim-mode haml-mode)
  "Modes for which auto-indenting is suppressed.")

(defvar yank-advised-indent-threshold 1000
  "Threshold (# chars) over which indentation does not automatically occur.")

(defun yank-advised-indent-function (beg end)
  "Do indentation, as long as the region isn't too large.  Arguments: BEG and END."
  (if (<= (- end beg) yank-advised-indent-threshold)
      (indent-region beg end nil)))

(defadvice yank (after yank-indent activate)
  "If current mode is one of 'yank-indent-modes, indent yanked text (with prefix arg don't indent)."
  (if (and (not (ad-get-arg 0))
           (not (member major-mode yank-indent-blacklisted-modes))
           (or (derived-mode-p 'prog-mode)
               (member major-mode yank-indent-modes)))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end)))))

(defadvice yank-pop (after yank-pop-indent activate)
  "If current mode is one of `yank-indent-modes', indent yanked text (with prefix arg don't indent)."
  (when (and (not (ad-get-arg 0))
             (not (member major-mode yank-indent-blacklisted-modes))
             (or (derived-mode-p 'prog-mode)
                 (member major-mode yank-indent-modes)))
    (let ((transient-mark-mode nil))
      (yank-advised-indent-function (region-beginning) (region-end)))))

;; prelude-core.el
(defun prelude-duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated.  However, if
there's a region, all lines that region covers will be duplicated."
  (interactive "p")
  (pcase-let* ((origin (point))
               (`(,beg . ,end) (prelude-get-positions-of-line-or-region))
               (region (buffer-substring-no-properties beg end)))
    (-dotimes arg
      (lambda (n)
        (goto-char end)
        (newline)
        (insert region)
        (setq end (point))))
    (goto-char (+ origin (* (length region) arg) arg))))

;; prelude-core.el
(defun indent-buffer ()
  "Indent the currently visited buffer."
  (interactive)
  (indent-region (point-min) (point-max)))

;; prelude-editing.el
(defcustom prelude-indent-sensitive-modes
  '(coffee-mode python-mode slim-mode haml-mode yaml-mode)
  "Modes for which auto-indenting is suppressed."
  :type 'list)

(defun indent-region-or-buffer ()
  "Indent a region if selected, otherwise the whole buffer."
  (interactive)
  (unless (member major-mode prelude-indent-sensitive-modes)
    (save-excursion
      (if (region-active-p)
          (progn
            (indent-region (region-beginning) (region-end))
            (message "Indented selected region."))
        (progn
          (indent-buffer)
          (message "Indented buffer.")))
      (whitespace-cleanup))))

(global-set-key (kbd "C-c i") 'indent-region-or-buffer)

;; add duplicate line function from Prelude
;; taken from prelude-core.el
(defun prelude-get-positions-of-line-or-region ()
  "Return positions (beg . end) of the current line or region."
  (let (beg end)
    (if (and mark-active (> (point) (mark)))
        (exchange-point-and-mark))
    (setq beg (line-beginning-position))
    (if mark-active
        (exchange-point-and-mark))
    (setq end (line-end-position))
    (cons beg end)))

(defun kill-default-buffer ()
  "Kill the currently active buffer -- set to C-x k so that users are not asked which buffer they want to kill."
  (interactive)
  (let (kill-buffer-query-functions) (kill-buffer)))

(global-set-key (kbd "C-x k") 'kill-default-buffer)

;; smart openline
(defun prelude-smart-open-line (arg)
  "Insert an empty line after the current line.
Position the cursor at its beginning, according to the current mode.
With a prefix ARG open line above the current line."
  (interactive "P")
  (if arg
      (prelude-smart-open-line-above)
    (progn
      (move-end-of-line nil)
      (newline-and-indent))))

(defun prelude-smart-open-line-above ()
  "Insert an empty line above the current line.
Position the cursor at it's beginning, according to the current mode."
  (interactive)
  (move-beginning-of-line nil)
  (newline-and-indent)
  (forward-line -1)
  (indent-according-to-mode))

(global-set-key (kbd "C-o") 'prelude-smart-open-line)
(global-set-key (kbd "M-o") 'open-line)

(defadvice kill-ring-save (before slick-copy activate compile)
  "When called interactively with no active region, copy a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (message "Copied line")
     (list (line-beginning-position)
           (line-beginning-position 2)))))

(defadvice kill-region (before slick-cut activate compile)
  "When called interactively with no active region, kill a single line instead."
  (interactive
   (if mark-active (list (region-beginning) (region-end))
     (list (line-beginning-position)
           (line-beginning-position 2)))))

;; kill a line, including whitespace characters until next non-whiepsace character
;; of next line
(defadvice kill-line (before check-position activate)
  (if (member major-mode
              '(emacs-lisp-mode scheme-mode lisp-mode
                                c-mode c++-mode objc-mode
                                latex-mode plain-tex-mode))
      (if (and (eolp) (not (bolp)))
          (progn (forward-char 1)
                 (just-one-space 0)
                 (backward-char 1)))))

(winner-mode 1)
(column-number-mode 1)



;; you won't need any of the bar thingies
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'menu-bar-mode) (menu-bar-mode -1))

;; the blinking cursor is nothing, but an annoyance
(blink-cursor-mode -1)

(setq scroll-margin 0
      scroll-conservatively 100000
      scroll-preserve-screen-position 1)

(size-indication-mode t)

;; monre useful frame title, that show either a file or a
;; buffer name (if the buffer isn't visiting a file)
;; taken from prelude-ui.el
(setq frame-title-format
      '("" invocation-name " - " (:eval (if (buffer-file-name)
                                                    (abbreviate-file-name (buffer-file-name))
                                                  "%b"))))

(defvar backup-directory "~/.backups")
(if (not (file-exists-p backup-directory))
    (make-directory backup-directory t))
(setq
 make-backup-files t        ; backup a file the first time it is saved
 backup-directory-alist `((".*" . ,backup-directory)) ; save backup files in ~/.backups
 backup-by-copying t     ; copy the current file into backup directory
 version-control t   ; version numbers for backup files
 delete-old-versions t   ; delete unnecessary versions
 kept-old-versions 6     ; oldest versions to keep when a new numbered backup is made (default: 2)
 kept-new-versions 9 ; newest versions to keep when a new numbered backup is made (default: 2)
 auto-save-default t ; auto-save every buffer that visits a file
 auto-save-timeout 20 ; number of seconds idle time before auto-save (default: 30)
 auto-save-interval 200 ; number of keystrokes between auto-saves (default: 300)
 )

(setq
 dired-dwim-target t            ; if another Dired buffer is visible in another window, use that directory as target for Rename/Copy
 dired-recursive-copies 'always         ; "always" means no asking
 dired-recursive-deletes 'top           ; "top" means ask once for top level directory
 dired-listing-switches "-lha"          ; human-readable listing
 )

;; use 4 indent
(add-hook 'json-mode-hook
          (lambda ()
            (make-local-variable 'js-indent-level)
            (setq js-indent-level 2)))

;; automatically refresh dired buffer on changes
(add-hook 'dired-mode-hook 'auto-revert-mode)

;; if it is not Windows, use the following listing switches
(when (not (eq system-type 'windows-nt))
  (setq dired-listing-switches "-lha --group-directories-first"))

(require 'dired-x) ; provide extra commands for Dired

(defun dired-get-size ()
  "Get the size of selected files."
  (interactive)
  (let ((files (dired-get-marked-files)))
    (with-temp-buffer
      (apply 'call-process "/usr/bin/du" nil t nil "-sch" files)
      (message
       "Size of all marked files: %s"
       (progn
         (re-search-backward "\\(^[ 0-9.,]+[A-Za-z]+\\).*total$")
         (match-string 1))))))

(define-key dired-mode-map (kbd "z") 'dired-get-size)

;; wdired allows you to edit a Dired buffer and write changes to disk
;; - Switch to Wdired by C-x C-q
;; - Edit the Dired buffer, i.e. change filenames
;; - Commit by C-c C-c, abort by C-c C-k
(require 'wdired)
(setq
 wdired-allow-to-change-permissions t   ; allow to edit permission bits
 wdired-allow-to-redirect-links t    ; allow to edit symlinks
 )

(recentf-mode)
(setq
 recentf-max-menu-items 30
 recentf-max-saved-items 5000
 )
(use-package recentf-ext)

(setq c-default-style "linux"           ; set style to "linux"
      c-basic-offset 4)
(setq gdb-many-windows t             ; use gdb-many-windows by default
      gdb-show-main t) ; Non-nil means display source file containing the main routine at startup

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

(defun prelude-makefile-mode-defaults ()
  (whitespace-toggle-options '(tabs))
  (setq indent-tabs-mode t ))

(setq prelude-makefile-mode-hook 'prelude-makefile-mode-defaults)

(add-hook 'makefile-mode-hook (lambda ()
                                (run-hooks 'prelude-makefile-mode-hook)))

(setq ediff-diff-options "-w"
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain)

(add-to-list 'load-path' "~/.emacs.d/lisp")

(use-package docker)

(use-package simpleclip
  :config
  (simpleclip-mode 1))

(use-package 2048-game)

(use-package ace-jump-mode
  :config
  (autoload
    'ace-jump-mode
    "ace-jump-mode"
    "Emacs quick move minor mode"
    t)
  ;; you can select the key you prefer to
  (define-key global-map (kbd "C-c SPC") 'ace-jump-mode)
  (autoload
    'ace-jump-mode-pop-mark
    "ace-jump-mode"
    "Ace jump back:-)"
    t)
  (eval-after-load "ace-jump-mode"
    '(ace-jump-mode-enable-mark-sync))
  (define-key global-map (kbd "C-x SPC") 'ace-jump-mode-pop-mark))

(use-package keychain-environment)
(use-package highlight-numbers)

(use-package elfeed
  :config
  (global-set-key (kbd "C-x w") 'elfeed)
  (setq elfeed-feeds
        '(("http://nullprogram.com/feed/" nullprogram)
          ("http://akaptur.com/atom.xml" akaptur)
          ("http://feeds.feedburner.com/se-radio" se-radio)
          ("https://lwn.net/headlines/rss" lwn)
          ("http://www.commitstrip.com/en/feed/atom/?" commitstrip)
          ("https://jeremykun.com/feed/atom/" math-n-programming)
          ("https://golangweekly.com/rss/1b3gf1ok" go-lang-weekly)
          ("http://xkcd.com/rss.xml" xkcd)))
  (setf url-queue-timeout 30))

(use-package go-mode
  :config
  ;; use godoc from within emacs
  (defun set-exec-path-from-shell-PATH ()
    (let ((path-from-shell (replace-regexp-in-string
                            "[ \t\n]*$"
                            ""
                            (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
      (setenv "PATH" path-from-shell)
      (setq eshell-path-env path-from-shell) ; for eshell users
      (setq exec-path (split-string path-from-shell path-separator))))

  (when window-system (set-exec-path-from-shell-PATH))
  (setenv "GOPATH" "/Users/darshanchoudhary/go")

  (add-to-list 'exec-path "/Users/darshanchoudhary/go/bin")

  (defun my-go-mode-hook ()
    (setq gofmt-command "goimports")
    (add-hook 'before-save-hook 'gofmt-before-save)
    (local-set-key (kbd "M-.") 'godef-jump)
    (local-set-key (kbd "M-*") 'pop-tag-mark)
    (auto-complete-mode 1)
    (if (not (string-match "go" compile-command))
        (set (make-local-variable 'compile-command)
             "go build -v && go test -v && go vet"))
    )
  (add-hook 'go-mode-hook 'my-go-mode-hook)
  (with-eval-after-load 'go-mode
    (require 'go-autocomplete))
  )

(use-package go-guru
  :config
  (go-guru-hl-identifier-mode)
)

(use-package go-eldoc
  :config
  (add-hook 'go-mode-hook 'go-eldoc-setup)
  (setq go-eldoc-gocode "go")
  )

(use-package centered-window-mode
  :ensure t)

(use-package gist)

(use-package find-file-in-project
  :config
  (autoload 'find-file-in-project "find-file-in-project" nil t)
  (autoload 'find-file-in-project-by-selected "find-file-in-project" nil t)
  (autoload 'find-directory-in-project-by-selected "find-file-in-project" nil t)
  (autoload 'ffip-show-diff "find-file-in-project" nil t)
  (autoload 'ffip-save-ivy-last "find-file-in-project" nil t)
  (autoload 'ffip-ivy-resume "find-file-in-project" nil t))

;; github.com/spotify/dockerfile-mode
(use-package dockerfile-mode
  :config
  (add-to-list 'auto-mode-alist '("Dockerfile\\'" . dockerfile-mode)))

(use-package smart-tab
  :config
  (global-smart-tab-mode 1))

;; (setq explicit-shell-file-name "/bin/zsh") -- there is some encoding problem with zsh
(setq explicit-shell-file-name "/bin/bash")
(setq shell-file-name "bash")
(setq explicit-bash.exe-args '("--noediting" "--login" "-i"))
(setenv "SHELL" shell-file-name)

(add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m)
(global-set-key (kbd "<f1>") 'shell)

(use-package duplicate-thing)
(global-set-key (kbd "M-c") 'duplicate-thing)

(require 'volatile-highlights)
(volatile-highlights-mode t)

;; Package: smartparens
(require 'smartparens-config)
(setq sp-base-key-bindings 'paredit)
(setq sp-autoskip-closing-pair 'always)
(setq sp-hybrid-kill-entire-symbol nil)
(sp-use-paredit-bindings)

(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

(require 'undo-tree)
(global-undo-tree-mode)

(require 'yasnippet)
(yas-global-mode 1)

;; https://github.com/baohaojun/bbyac
(use-package bbyac)

(add-hook 'after-init-hook 'global-company-mode)
(use-package company-restclient
  :config
  (add-to-list 'company-backends 'company-restclient))


(use-package expand-region)
(global-set-key (kbd "M-m") 'er/expand-region)

(add-hook 'ibuffer-hook
          (lambda ()
            (ibuffer-vc-set-filter-groups-by-vc-root)
            (unless (eq ibuffer-sorting-mode 'alphabetic)
              (ibuffer-do-sort-by-alphabetic))))

(setq ibuffer-formats
      '((mark modified read-only vc-status-mini " "
              (name 18 18 :left :elide)
              " "
              (size 9 -1 :right)
              " "
              (mode 16 16 :left :elide)
              " "
              (vc-status 16 16 :left)
              " "
              filename-and-process)))


(projectile-global-mode)

(require 'dired+)
(require 'recentf-ext)

;; since ztree works with files and directories
(require 'ztree-diff)
(require 'ztree-dir)

(add-hook 'dired-mode-hook 'diff-hl-dired-mode)

(use-package magit
  :config
  (set-default 'magit-stage-all-confirm nil)
  (add-hook 'magit-mode-hook 'magit-load-config-extensions)
  ;; full screen magit-status
  (defadvice magit-status (around magit-fullscreen activate)
    (window-configuration-to-register :magit-fullscreen)
    ad-do-it
    (delete-other-windows))
  )

(global-unset-key (kbd "C-x g"))
(global-set-key (kbd "C-x g s") 'magit-status)


(require 'flycheck)
(add-hook 'after-init-hook #'global-flycheck-mode)

(require 'flycheck-tip)
(flycheck-tip-use-timer 'verbose)


(use-package golden-ratio
  :config
  (defun pl/helm-alive-p ()
    (if (boundp 'helm-alive-p)
        (symbol-value 'helm-alive-p)))
  (add-to-list 'golden-ratio-exclude-modes "ediff-mode")
  (add-to-list 'golden-ratio-exclude-modes "helm-mode")
  (add-to-list 'golden-ratio-inhibit-functions 'pl/helm-alive-p)
  (golden-ratio-mode)
  )


(add-hook 'prog-mode-hook 'highlight-numbers-mode)
(add-hook 'org-mode-hook 'visual-line-mode)


;; very important, gives us M-n and M-p
(require 'highlight-symbol)

(highlight-symbol-nav-mode)

(add-hook 'prog-mode-hook (lambda () (highlight-symbol-mode)))
(add-hook 'org-mode-hook (lambda () (highlight-symbol-mode)))

(setq highlight-symbol-idle-delay 0.2
      highlight-symbol-on-navigation-p t)

(global-set-key [(control shift mouse-1)]
                (lambda (event)
                  (interactive "e")
                  (goto-char (posn-point (event-start event)))
                  (highlight-symbol-at-point)))

(global-set-key (kbd "M-n") 'highlight-symbol-next)
(global-set-key (kbd "M-p") 'highlight-symbol-prev)


(use-package info+)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; dracula theme                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (load-theme 'solarized-theme t)

;; (add-to-list 'custom-theme-load-path "~/.emacs.d/themes/emacs-color-theme-solarized")
;; ;;(load-theme 'solarized t)
;; (set-terminal-parameter nil 'background-mode 'light)
;; (enable-theme 'solarized)

;; (add-hook 'after-make-frame-functions
;;           (lambda (frame)
;;             (let ((mode (if (display-graphic-p frame) 'light 'dark)))
;;               (set-frame-parameter frame 'background-mode mode)
;;               (set-terminal-parameter frame 'background-mode mode))
;;             (enable-theme 'solarized)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; eclim for java                                       ;;
;; this is killing my inspiron, do this in the newer PC ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; (require 'eclim)
;; (add-hook 'java-mode-hook 'eclim-mode)
;; (require 'eclimd)

;; (custom-set-variables
;;   '(eclim-eclipse-dirs '("~/eclipse/java-latest-released/eclipse"))
;;   '(eclim-executable "/home/radar/.p2/pool/plugins/org.eclim_2.6.0/bin/eclim"))

;; (setq help-at-pt-display-when-idle t)
;; (setq help-at-pt-timer-delay 0.1)
;; (help-at-pt-set-timer)

;; regular auto-complete initialization - darshaime
;; (require 'auto-complete-config)
;; (ac-config-default)

;; ;; add the emacs-eclim source
;; (require 'ac-emacs-eclim-source)
;; (ac-emacs-eclim-config)

;; (require 'company)
;; (global-company-mode t)

;; (require 'company-emacs-eclim)
;; (company-emacs-eclim-setup)

;; ;; tring out JDEE
;; (add-to-list 'load-path "~/.emacs.d/elpa/jdee/")
;; (require 'jdee)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; column marker                      ;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'column-marker)
;; (add-hook 'python-mode-hook (lambda () (interactive) (column-marker-1 80)))

;; config for discover-my-major
;; A quick major mode help with discover-my-major
(global-unset-key (kbd "C-h h"))        ; original "C-h h" displays "hello world" in different languages
(define-key 'help-command (kbd "h m") 'discover-my-major)


;; emojis in emacs
(use-package emojify
  :config
  (add-hook 'after-init-hook #'global-emojify-mode))


(add-hook 'html-mode-hook 'rainbow-mode)
(add-hook 'css-mode-hook 'rainbow-mode)


(use-package rainbow-delimiters
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))


(add-hook 'text-mode-hook (lambda () (flyspell-mode 1)))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))


(require 'help+)


(semantic-mode 1) ;; this prettyfies the helm-semantic-or-imenu listings


(setq-default indent-tabs-mode nil) ;; this disables tabs, to still have them, do c-q <tab>


(require 'direx)
(global-set-key (kbd "C-x C-j") 'direx:jump-to-directory)


;; disable lock files when using ember, see SO question 28884476
;; (add-hook 'js-mode-hook (lambda () (create-lockfiles nil)))
;; (add-hook 'web-mode-hook (lambda () (create-lockfiles nil)))

;; enable coffee mode for .coffee files
(use-package coffee-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.coffee\\'" . coffee-mode))
  )


;; EMMS
(use-package emms
  :config
  (global-set-key (kbd "C-M-n") 'emms-next)
  (global-set-key (kbd "C-M-SPC") 'emms-pause)
  (emms-all)

  (emms-default-players)

  ;; for gnu/linux, it would be /usr/local/vlc
  (setq emms-player-vlc-command-name "/Users/darshanchoudhary/Desktop/VLC.app/Contents/MacOS/VLC")

  (with-eval-after-load 'emms
    (emms-standard)
    (setq emms-source-file-default-directory "~/Music"
          emms-info-asynchronously t
          emms-show-format "\u266a %s"))

  (setq emms-repeat-playlist t)
  (setq emms-seek-seconds 120)
  (defvar emms-auto-save-playlist-path (concat emms-directory "/" "auto-save.m3u"))

  (global-set-key (kbd "C-c e") 'my-emms)

  (defun my-emms ()
    (interactive)
    (if (or (null emms-playlist-buffer)
            (not (buffer-live-p emms-playlist-buffer)))
        (emms-add-m3u-playlist emms-auto-save-playlist-path)
      )
    (emms-playlist-mode-go))

  (add-hook 'kill-emacs-hook
            (lambda ()
              (if emms-playlist-buffer
                  (emms-playlist-save 'm3u emms-auto-save-playlist-path)
                )))
  ;; Add file to playlist from Dired
  (define-key dired-mode-map (kbd "a") 'dired-add-to-emms-playlist)

  ;; Disable video output to prevent a new window.
  (defun file-audio-or-video-p (file-path)
    (let* ((safe-path (replace-regexp-in-string "\"" "\\\"" (expand-file-name file-path)))
           (mime (shell-command-to-string (format "file --mime --brief \"%s\"" safe-path)))
           (type (car (split-string mime "/"))))
      (if (member type '(video audio))
          type
        nil)))

  (defun dired-add-to-emms-playlist ()
    (interactive)
    (let ((file-path (dired-get-filename)))
      (if (or (member (file-name-extension file-path)
                      '("ogg" "mp3" "wav" "mpg" "mpeg" "wmv" "wma"
                        "mov" "avi" "divx" "ogm" "ogv" "asf" "mkv"
                        "rm" "rmvb" "mp4" "flac" "vrob" "m4a" "ape"
                        "flv" "webm" "opus"))
              (file-audio-or-video-p file-path))
          (emms-add-dired)))
    (dired-next-line 1))

  ;; Format
  (setq emms-playing-time-display-format "(%s)")
  (setq emms-mode-line-format "[%s]")

  (defadvice emms-track-description (after show-only-filename activate)
    (setq ad-return-value
          (string-trim (file-name-base ad-return-value))))
  )

(use-package emms-mode-line-cycle
  :config
  (emms-mode-line 1)
  (emms-playing-time 1))

(use-package helm-emms
  :config
  (autoload 'helm-emms "helm-emms" nil t))


;; hide minor modes in modeline
(use-package diminish
  :config
  (diminish 'jiggle-mode)
  (diminish 'abbrev-mode "Abv") ;; Replace abbrev-mode lighter with "Abv"
  (diminish 'projectile-mode)
  (diminish 'golden-ratio-mode)
  (diminish 'undo-tree-mode))

(use-package yaml-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode)))


;; sass mode
(use-package sass-mode
  :config
  (autoload 'scss-mode "scss-mode")
  (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode)))


;; handlebars major mode
(use-package mustache-mode
  :config
  (add-to-list 'auto-mode-alist '("\\.hbs\\'" . mustache-mode)))


(use-package help-fns+)
(use-package help-mode+)
(use-package smart-shift
  :config
  (global-smart-shift-mode 1))


;; only turn on if a window system is available
(case window-system
  ((ns x w32) (nyan-mode)))


;; helm-projectile settings
;; (projectile-global-mode)
;; (setq projectile-completion-system 'helm)
;; (helm-projectile-on)
;; (setq projectile-switch-project-action 'helm-projectile)

(use-package helm-projectile
  :config
  (projectile-global-mode)
  (setq projectile-completion-system 'helm)
  (helm-projectile-on)
  (setq projectile-switch-project-action 'helm-projectile))


;; misc key bindings
(defun toggle-window-split ()
  "Toggle split of windows."
  (interactive)
  (if (= (count-windows) 2)
      (let* ((this-win-buffer (window-buffer))
             (next-win-buffer (window-buffer (next-window)))
             (this-win-edges (window-edges (selected-window)))
             (next-win-edges (window-edges (next-window)))
             (this-win-2nd (not (and (<= (car this-win-edges)
                                         (car next-win-edges))
                                     (<= (cadr this-win-edges)
                                         (cadr next-win-edges)))))
             (splitter
              (if (= (car this-win-edges)
                     (car (window-edges (next-window))))
                  'split-window-horizontally
                'split-window-vertically)))
        (delete-other-windows)
        (let ((first-win (selected-window)))
          (funcall splitter)
          (if this-win-2nd (other-window 1))
          (set-window-buffer (selected-window) this-win-buffer)
          (set-window-buffer (next-window) next-win-buffer)
          (select-window first-win)
          (if this-win-2nd (other-window 1))))))

(global-set-key (kbd "C-x |") 'toggle-window-split)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Helm configuration
(use-package helm
  :config
  (require 'helm-config)
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))

  (define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
  (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
  (define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

  (when (executable-find "curl")
    (setq helm-google-suggest-use-curl-p t))

  (setq helm-split-window-in-side-p           t
        helm-echo-input-in-header-line        t
        helm-M-x-always-save-history          t
        helm-recentf-fuzzy-match              t
        helm-buffers-fuzzy-matching           t
        helm-move-to-line-cycle-in-source     t
        helm-ff-search-library-in-sexp        t
        helm-move-to-line-cycle-in-source     t
        helm-ff-search-library-in-sexp        t
        helm-scroll-amount                    8
        helm-ff-file-name-history-use-recentf t
        helm-apropos-fuzzy-match              t
        helm-locate-fuzzy-match               t
        helm-semantic-fuzzy-match             t
        helm-imenu-fuzzy-match                t
        helm-M-x-fuzzy-match                  t
        )

  (helm-autoresize-mode t)
  (defun pl/helm-alive-p ()
    (if (boundp 'helm-alive-p)
        (symbol-value 'helm-alive-p)))

  (add-to-list 'golden-ratio-inhibit-functions 'pl/helm-alive-p)
  (add-to-list 'helm-sources-using-default-as-input 'helm-source-man-pages) ;; get to man pages easily using c-c h m

  (global-set-key (kbd "M-x") 'helm-M-x)
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)
  (global-set-key (kbd "C-x b") 'helm-mini)
  (global-set-key (kbd "C-x C-f") 'helm-find-files)
  (global-set-key (kbd "C-c h o") 'helm-occur)
  (global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
  (global-set-key (kbd "C-c h x") 'helm-register)
  (global-set-key (kbd "C-c h g") 'helm-google-suggest)
  (global-set-key (kbd "C-c h M-:") 'helm-eval-expression-with-eldoc)

  (require 'helm-eshell)
  (add-hook 'eshell-mode-hook
            #'(lambda ()
                (define-key eshell-mode-map (kbd "C-c C-l")  'helm-eshell-history)))

  (define-key shell-mode-map (kbd "C-c C-l") 'helm-comint-input-ring)
  (define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)
  (helm-mode 1))

(use-package helm-swoop
  :config
  (setq helm-swoop-speed-or-color t)
  (setq helm-swoop-split-with-multiple-windows t)
  (global-set-key "\C-s" 'helm-swoop-without-pre-input))


(use-package helm-github-stars
  :config
  (setq helm-github-stars-username "darshanime"))

(use-package writeroom-mode
  :config
  (add-hook 'writeroom-mode-hook 'visual-line-mode))

(use-package markdown-mode
  :config
  (add-hook 'markdown-mode-hook 'writeroom-mode)
  (add-hook 'markdown-mode-hook 'artbollocks-mode)
  (define-key markdown-mode-map (kbd "C-c C-s C-c") 'markdown-insert-code)
  (define-key markdown-mode-map (kbd "C-c C-s C-b") 'markdown-insert-bold)
  (define-key markdown-mode-map (kbd "C-c C-s C-i") 'markdown-insert-italic)
  )

(use-package auto-capitalize
  :config
  (autoload 'auto-capitalize-mode "auto-capitalize"
    "Toggle `auto-capitalize' minor mode in this buffer." t)
  (autoload 'turn-on-auto-capitalize-mode "auto-capitalize"
    "Turn on `auto-capitalize' minor mode in this buffer." t)
  (autoload 'enable-auto-capitalize-mode "auto-capitalize"
    "Enable `auto-capitalize' minor mode in this buffer." t)
  (defun cap ()
    (auto-capitalize-mode))
  (add-hook 'org-mode-hook 'cap)
  (add-hook 'markdown-mode-hook 'cap)
  (defvar auto-capitalize-words
    '("I" "Python" "Emacs" "You")))

(use-package keyfreq
  :config
  (keyfreq-mode 1)
  (keyfreq-autosave-mode 1))

(use-package which-key
  :config
  (which-key-mode)
  (which-key-setup-side-window-bottom))

;; setting for highlighting the present line
(use-package hl-line
  :config
  (global-hl-line-mode 1))

(use-package flycheck-pos-tip
  :config
  (with-eval-after-load 'flycheck
    (flycheck-pos-tip-mode))
  (eval-after-load 'flycheck
    '(custom-set-variables
      '(flycheck-display-errors-function #'flycheck-pos-tip-error-messages))))

(use-package helm-proc)

;; MIT Scheme in Emacs
(setq scheme-program-name "scm")

;; rename current buffer
(defun rename-current-buffer-file ()
  "Renames current buffer and file it is visiting."
  (interactive)
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (if (not (and filename (file-exists-p filename)))
        (error "Buffer '%s' is not visiting a file!" name)
      (let ((new-name (read-file-name "New name: " filename)))
        (if (get-buffer new-name)
            (error "A buffer named '%s' already exists!" new-name)
          (rename-file filename new-name 1)
          (rename-buffer new-name)
          (set-visited-file-name new-name)
          (set-buffer-modified-p nil)
          (message "File '%s' successfully renamed to '%s'"
                   name (file-name-nondirectory new-name)))))))
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)


;; Org Mode
(use-package org
  :config

  (setq org-directory "~/org")
  (setq org-default-notes-file (concat org-directory "/notes.org"))
  (define-key global-map (kbd "C-c c") 'org-capture)

  ;; define the templates
  (setq org-capture-templates
        '(("t" "Todo" entry (file+headline "~/org/gtd.org" "Tasks")
           "* TODO %?\n  %i\n  %a")
          ("j" "Journal" entry (file+datetree "~/org/journal.org")
           "* %?\nEntered on %U\n  %i\n  %a")))

  (setq org-archive-location "~/org/archive.org::* From %s")
  (setq major-mode 'org-mode) ;; set org mode as the default mode for txt files and files with no major mode

  (add-to-list 'auto-mode-alist '("\\.txt$" . org-mode))

  ;; enable syntax highlighting in org-mode
  (setq org-src-fontify-natively t)

  ;; disable looking in data when using C-; (helm-projectile-grep)
  (add-to-list 'grep-find-ignored-directories "data")

  ;; enable displaying symbols as symbols (greek letters etc)
  (setq org-pretty-entities t)

  ;; now, a_{b} will be interpreted as a_subscript-b
  ;; and a^{b} will be interpreted as a-superscript-b
  (setq org-use-sub-superscripts "{}")


  ;; truncate-lines everywhere. this wasn't the case with org mode
  (setq truncate-lines nil)

  ;; add "optional" to TODO
  (setq org-todo-keywords '((sequence "TODO" "OPTIONAL" "|" "DONE")))

  ;; Make windmove work in org-mode:
  ;; moved to using Super key, this wasn't playing nice with goldenration
  ;; (add-hook 'org-shiftup-final-hook 'windmove-up)
  ;; (add-hook 'org-shiftleft-final-hook 'windmove-left)
  ;; (add-hook 'org-shiftdown-final-hook 'windmove-down)
  ;; (add-hook 'org-shiftright-final-hook 'windmove-right)

  ;; add inline images!
  ;; allow shrinking them
  (setq org-startup-with-inline-images t)
  (setq org-image-actual-width nil)

  ;; add shortcut function for showing inline images
  (global-set-key (kbd "C-`") 'org-toggle-inline-images)

  ;; indent code in src tabs
  (setq org-src-tab-acts-natively t)
  (org-babel-do-load-languages
   'org-babel-load-languages '((C . t) (python . t) (java . t)))
  (define-key org-mode-map (kbd "C-#") 'radar-insert-screenshot)
  )


;; define shortcuts to add pictures and src
(global-set-key (kbd "C-!") 'radar-insert-picture)
(global-set-key (kbd "C-#") 'org-download-screenshot)
(global-set-key (kbd "C-*") 'radar-insert-src)

(use-package org-download
  :config
  (if (eq system-type 'darwin)
      (setq org-download-screenshot-method "screencapture -i %s")
    ))


(defun radar-insert-screenshot ()
  "Use to insert picture."
  (interactive)
  (insert "#+ATTR_ORG: :width 400\n#+ATTR_ORG: :height 400")
  (defun org-download--dir () "./assets/")
  (org-download-screenshot))

(defun radar-insert-src ()
  "Use to insert src."
  (interactive)
  ;; ;; C
  ;; (insert "#+begin_src C\n#include <stdio.h>\n\nint main()\n{\n\n    return 0;\n}\n#+end_src")
  ;; python
  (insert "#+begin_src python\n\n#+end_src")
  )

;; revert buffer - darshanime
(global-set-key (kbd "C-.") 'revert-buffer)

(use-package org-journal
  :config
  (setq org-journal-dir (concat org-directory "/journal")))

;; https://github.com/domtronn/all-the-icons.el#readme
(use-package all-the-icons)

;; restclient for .http files
(use-package restclient
  :mode ("\\.http\\'" . restclient-mode))

;; restore window points when returning to buffers
(use-package pointback
  :config
  (global-pointback-mode 1))

;; code folding plugin https://github.com/zenozeng/yafolding.el
;; needs discover.el for showing a context menu of commands
(use-package discover
  :config
  (global-discover-mode 1))

;; activate the context menu
;; (global-set-key (kbd "s-d y") 'yafolding-discover)

(use-package prodigy
  :config

  (prodigy-define-service
    :name "synon-start server"
    :tags '(appknox)
    :cwd "~/zinnov/synon/synon"
    :command "python"
    :args '("manage.py" "runserver" "0.0.0.0:8000")
    :stop-signal 'sigkill
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "mycroft start celery"
    :tags '(appknox)
    :init (lambda () (pyvenv-workon "mycroft"))
    :cwd "~/Projects/appknox/mycroft/"
    :command "bash"
    :args '("scripts/celery_final.sh")
    :stop-signal 'sigkill
    :kill-process-buffer-on-stop t)

  (prodigy-define-service
    :name "grip markdon"
    ;; :cwd "~/projects/python/avilpage/"
    :command "grip"
    :stop-signal 'sigkill
    :kill-process-buffer-on-stop t)

  :bind
  ("C-x C-p" . prodigy))

(defun prodigy-begin ()
  "Start the prodigy services."
  (interactive)
  (prodigy)
  (with-current-buffer "*prodigy*"
    (prodigy-mark-all)
    (prodigy-start)
    (prodigy-unmark-all)))


(use-package multiple-cursors
  :config
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

(use-package restart-emacs)

(use-package know-your-http-well)

(use-package persistent-scratch
  :config
  (persistent-scratch-setup-default))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(flycheck-checker-error-threshold 1000)
 '(flycheck-display-errors-function (function flycheck-pos-tip-error-messages))
 '(initial-buffer-choice "~/org/master.org")
 '(magit-commit-arguments (quote ("--gpg-sign=02C4AE21763B59AD")))
 '(package-selected-packages
   (quote
    (cider clojure-mode aggressive-indent-mode define-word company-restclient jq-mode flymake-google-cpplint flymake-cursor google-c-style ac-c-headers go-guru go-eldoc go-autocomplete bbyac csv-mode all-the-icons transmission no-littering ace-jump-mode 2048-game keychain-environment elfeed go-mode centered-window-mode org-journal org-download helm-swoop helm-emms emms-mode-line-cycle emms ztree yafolding workgroups2 w3m volatile-highlights use-package undo-tree smartparens smart-tab smart-shift simpleclip restclient restart-emacs recentf-ext rebox2 rainbow-mode rainbow-delimiters prodigy pointback persistent-scratch octicons nyan-mode multiple-cursors magit-gh-pulls lorem-ipsum lispy know-your-http-well info+ ibuffer-vc highlight-symbol highlight-numbers help-mode+ help-fns+ help+ helm-projectile helm-flyspell helm-descbinds golden-ratio gist flycheck-tip expand-region ereader emojify elpy duplicate-thing dockerfile-mode discover-my-major discover direx dired+ diff-hl coffee-mode clean-aindent-mode circe chess auto-complete)))
 '(safe-local-variable-values (quote ((mangle-whitespace . t))))
 '(send-mail-function (quote smtpmail-send-it))
 '(smtpmail-smtp-server "smtp.googlemail.com")
 '(smtpmail-smtp-service 25))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 128 :width normal :foundry "DAMA" :family "Ubuntu Mono")))))

;; including elpy
(use-package elpy)
(elpy-enable)
(use-package pyvenv
  :config
  (pyvenv-workon "zinnov"))

(setq elpy-test-runner 'elpy-test-pytest-runner)
(setq elpy-rpc-timeout nil)
(setq elpy-rgrep-file-pattern "*.py *.html")
(setq elpy-rpc-backend "jedi")
(setq elpy-rpc-python-command "python3")
(elpy-rpc-restart)
(define-key elpy-mode-map (kbd "M-,") 'pop-tag-mark)


(defun add-mode-line-dirtrack ()
  "Show present working dir in mode line."
  (add-to-list 'mode-line-buffer-identification
               '(:propertize (" " default-directory " ") face dired-directory)))
  (add-hook 'shell-mode-hook 'add-mode-line-dirtrack)


;; auto update tags
(autoload 'turn-on-ctags-auto-update-mode "ctags-update" "turn on `ctags-auto-update-mode'." t)
(add-hook 'c-mode-common-hook  'turn-on-ctags-auto-update-mode)
(add-hook 'emacs-lisp-mode-hook  'turn-on-ctags-auto-update-mode)
(add-hook 'java-mode-hook  'turn-on-ctags-auto-update-mode)

;; add date
(defun insert-date (prefix)
  "Insert the current date.  With prefix-argument, use ISO format.  With two PREFIX arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
                 ((not prefix) "%d.%m.%Y")
                 ((equal prefix '(4)) "%Y-%m-%d")
                 ((equal prefix '(16)) "%A, %d. %B %Y")))
        (system-time-locale "de_DE"))
    (insert (format-time-string format))))
(global-set-key (kbd "C-c d") 'insert-date)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq-default
 indent-tabs-mode nil ;; no tabs in programs
 display-time-24hr-format t
 user-mail-address "deathbullet@gmail.com"
 cursor-in-non-selected-windows nil ;; Don't show a cursor in other windows
 )

;; Java
(setq c-default-style "bsd"
  c-basic-offset 4)

(defun fc-java-insert-public-class ()
  "Insert class template in new Java files."
  (let ((filename (buffer-file-name (current-buffer))))
    (when (and (= 1 (point-max))
               filename)
      (let ((classname (file-name-sans-extension
                        (file-name-nondirectory filename))))
        (skeleton-insert
         '(nil "public class " classname "\n{\n"
               > _
               "\n}"))))))

(add-hook 'java-mode-hook 'fc-java-insert-public-class)

;; delete present file and buffer
(defun delete-file-and-buffer ()
  "Kill the current buffer and deletes the file it is visiting."
  (interactive)
  (let ((filename (buffer-file-name)))
    (if filename
        (if (y-or-n-p (concat "Do you really want to delete file " filename " ?"))
            (progn
              (delete-file filename)
              (message "Deleted file %s." filename)
              (kill-buffer)))
      (message "Not a file visiting buffer!"))))

(global-set-key (kbd "C-c D")  'delete-file-and-buffer)

;; copy present buffer to os clipboard
(defun copy-current-buffer-to-os-clipboard ()
  (save-excursion
    (mark-whole-buffer)
    (defun copy-to-clipboard ()
      (interactive)
      (let ((thing (if (region-active-p)
                       (buffer-substring-no-properties (region-beginning) (region-end))
                     (thing-at-point 'symbol))))
        (simpleclip-set-contents thing)
        (message "thing => clipboard!")))
    (copy-to-clipboard)
    (keyboard-quit))
  )
(global-set-key (kbd "C-x p")  (lambda () (interactive) (copy-current-buffer-to-os-clipboard)))

(defun wenshan-other-docview-buffer-scroll-down ()
  "There are two visible buffers, one for taking notes and one
for displaying PDF, and the focus is on the notes buffer. This
command moves the PDF buffer forward."
  (interactive)
  (other-window 1)
  (doc-view-scroll-up-or-next-page)
  (other-window 1))

(defun wenshan-other-docview-buffer-scroll-up ()
  "There are two visible buffers, one for taking notes and one
for displaying PDF, and the focus is on the notes buffer. This
command moves the PDF buffer backward."
  (interactive)
  (other-window 1)
  (doc-view-scroll-down-or-previous-page)
  (other-window 1))

(global-set-key (kbd "<f8>") 'wenshan-other-docview-buffer-scroll-up)
(global-set-key (kbd "<f9>") 'wenshan-other-docview-buffer-scroll-down)

;; the perfect auto-correct.
;; http://endlessparentheses.com/ispell-and-abbrev-the-perfect-auto-correct.html

;; shortcut key mapping for helm-projectile-grep
(global-set-key (kbd "<f6>") 'helm-projectile-grep)
(global-set-key (kbd "C-;") 'helm-projectile-grep)

(display-time)

(global-set-key (kbd "C-x C-b") 'ibuffer)

(add-hook 'prog-mode-hook 'goto-address-mode)
(add-hook 'text-mode-hook 'goto-address-mode)
(add-hook 'emacs-lisp-mode-hook 'turn-on-eldoc-mode)
(add-hook 'lisp-interaction-mode-hook 'turn-on-eldoc-mode)
(add-hook 'ielm-mode-hook 'turn-on-eldoc-mode)

;; show important whitespace in diff-mode
(add-hook 'diff-mode-hook
          (lambda ()
            (setq-local whitespace-style
                        '(face
                          tabs
                          tab-mark
                          spaces
                          space-mark
                          trailing
                          indentation::space
                          indentation::tab
                          newline
                          newline-mark))
            (whitespace-mode 1)))


;; Start garbage collection every 100MB to improve Emacs performance
(setq gc-cons-threshold 100000000)

(setq global-mark-ring-max 5000         ; increase mark ring to contains 5000 entries
      mark-ring-max 5000                ; increase kill ring to contains 5000 entries
      mode-require-final-newline t      ; add a newline to end of file
      )

;; default to 4 visible spaces to display a tab
(setq-default tab-width 4)
(setq inhibit-startup-screen t)

(setq
 kill-ring-max 5000 ; increase kill-ring capacity
 kill-whole-line t  ; if NIL, kill whole line and move the next line up
 )

(setq savehist-additional-variables '(search ring regexp-search-ring) ; also save your regexp search queries
      savehist-autosave-interval 60     ; save every minute
      )
(setq large-file-warning-threshold 100000000) ;; size in bytes

(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)

(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-language-environment 'utf-8)
(set-selection-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(prefer-coding-system 'utf-8)

;; mac specific edits
(setq insert-directory-program "/usr/local/bin/gls" dired-use-ls-dired t)
(setq ring-bell-function 'ignore)
(set-frame-font "Ubuntu Mono 17" nil t)

(provide 'init)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; init.el ends here
(put 'downcase-region 'disabled nil)
