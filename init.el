(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(global-set-key (kbd "C-x C-b") 'ibuffer)

(add-to-list 'load-path' "~/.emacs.d/lisp")
(require 'simpleclip)
(simpleclip-mode 1)

(require 'smart-tab)
(global-smart-tab-mode 1)
