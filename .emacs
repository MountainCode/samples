;; Set up package.el to work with MELPA
(require 'package)
(add-to-list
 'package-archives
 '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(setq use-package-always-ensure t)

(use-package undo-fu)

(defun mtn/evil-hook ()
  ; Allow evil mode in package-menu-mode
  (dolist (mode '(package-menu-mode))
    (delete mode evil-emacs-state-modes)))

(use-package evil
  :ensure t
  :init
  (fset 'evil-visual-update-x-selection 'ignore)
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t) ; Allow us to page up with C-u
  (setq evil-want-fine-undo t)
  :hook (evil-mode . mtn/evil-hook)
  :config
  (evil-mode 1)
  (evil-set-undo-system 'undo-fu)
)

(setq inhibit-startup-message t)

; Turn off the annoying chrome
(menu-bar-mode   -1)                 ; Disable the menubar
(tool-bar-mode -1)                   ; Disable the toolbar
(tooltip-mode -1)                    ; Disable tooltips
(scroll-bar-mode -1)                 ; Disable visible scrollbar
(setq visible-bell t)                ; Disable the annoying beep
(setq-default indent-tabs-mode nil)  ; No tabs!
(setq x-select-enable-clipboard nil) ; Don't add stuff to the clipboard.

;; disable backup
(setq backup-inhibited t)
;; disable autosave
(setq auto-save-default nil)
;; auto-revert when a file changes outside of Emacs
(setq global-auto-revert-mode 1)
;; highlight active line
(global-hl-line-mode 1)

(setq confirm-kill-emacs 'y-or-n-p) ;; Ask before quitting

(set-default 'truncate-lines t)

(setq custom-file "~/.emacs.d/custom.el")
(when (file-exists-p custom-file)
  (load custom-file))

(setq create-lockfiles nil)

(set-face-attribute 'default nil
  :font   "Fira Code Retina"
  :height 100)

(when (version<= "26.0.50" emacs-version )
  (setq-default display-line-numbers-type 'visual
                display-line-numbers-current-absolute t
                display-line-numbers-width 4
                display-line-numbers-widen t)
  (add-hook 'text-mode-hook #'display-line-numbers-mode)
  (add-hook 'prog-mode-hook #'display-line-numbers-mode)
)

(use-package ivy
  :diminish ivy-mode
  :init (ivy-mode 1))
(use-package ivy-rich
  :init (ivy-rich-mode 1))
(use-package counsel
  :bind (("M-x"     . counsel-M-x)
         ("C-x b"   . counsel-ibuffer)
         ("C-x C-f" . counsel-find-file)
         :map minibuffer-local-map
         ("C-r" . 'counsel-minibuffer-history)))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-nord t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;(doom-themes-neotree-config)
  ;; or for treemacs users
  ;use the colorful treemacs theme
  ;(setq doom-themes-treemacs-theme "doom-colors")
  ;(doom-themes-treemacs-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(global-whitespace-mode)
(setq whitespace-style '(face trailing tabs tab-mark))

(require 'org-crypt)
(setq org-crypt-key "chris@snowboardbum.com")
(org-crypt-use-before-save-magic)
(setq org-tags-exclude-from-inheritance '("crypt"))
(global-set-key (kbd "C-c a") 'org-agenda)
(setq org-edit-src-content-indentation 0
      org-src-tab-acts-natively t
      org-src-preserve-indentation t)

(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c C-l") 'org-insert-link)

(add-hook 'org-mode-hook 'org-indent-mode)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((emacs-lisp . t)
   (haskell    . t)
   (js         . t)
   (shell      . t)))

(require 'ob-js)

(require 'org-tempo)
(add-to-list 'org-structure-template-alist '("cs" . "src csharp"))
(add-to-list 'org-structure-template-alist '("el" . "src emacs-lisp"))
(add-to-list 'org-structure-template-alist '("hs" . "src haskell"))
(add-to-list 'org-structure-template-alist '("js" . "src js"))
(add-to-list 'org-structure-template-alist '("mm" . "src mermaid"))
(add-to-list 'org-structure-template-alist '("sh" . "src shell"))

(setq org-ellipsis " ▼")

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(font-lock-add-keywords 'org-mode
                        '(("^ *\\([-]\\) "
                          (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

(require 'ox-publish)
(setq org-publish-project-alist
      '(("unstuck"
         :base-directory "~/unstuck"
         :base-extension "org"
         :publishing-directory "~/unstuck/exports"
         :publishing-function org-html-publish-to-html)
        ("all" :components ("unstuck"))))

(use-package real-auto-save)
(add-hook 'org-mode-hook 'real-auto-save-mode)

(add-hook 'prog-mode-hook #'electric-pair-local-mode)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package origami)

(use-package magit)

(use-package git-gutter+)

(use-package csharp-mode)

(use-package web-mode
  :mode "\\.html\\'"
  :init
    (setq tab-width 2)
    (setq web-mode-markup-indent-offset 2)
    (setq evil-shift-width 2)
)

;; JavaScript
(use-package js2-mode)
(add-to-list 'auto-mode-alist '("\\.\\(js\\|es6\\)\\'" . js2-mode))
(add-hook 'js2-mode-hook #'electric-pair-local-mode)
(add-hook 'js2-mode-hook (lambda() (setq tab-width 2)))
(add-hook 'js2-mode-hook (lambda() (setq js-indent-level-width 2)))
(add-hook 'js2-mode-hook (lambda() (setq evil-shift-width 2)))
(add-hook 'js2-mode-hook (lambda() (setq js-indent-level 2)))

(add-to-list 'org-src-lang-modes '("js" . js2))

(use-package json-mode)
(add-hook 'json-mode-hook
  (lambda() (setq
    js-indent-level 2
    evil-shift-width 2
  )))

(use-package restclient
  :mode "\\.rest\\'")

(add-to-list 'auto-mode-alist '("\\.rest\\'" . restclient-mode))

(use-package rust-mode)

(use-package toml-mode)

(use-package typescript-mode
  :mode "\\.ts\\'"
  :config (setq typescript-indent-level 2)
  :hook (typescript-mode . (lambda() (setq evil-shift-width 2))))

(use-package yaml-mode)

(use-package emojify)

(use-package dumb-jump
  :config (setq dumb-jump-selector 'ivy))

(use-package evil-surround
  :ensure t
  :config
  (global-evil-surround-mode 1))

(setq-default evil-surround-pairs-alist
              (push '(?q . ("“" . "”")) evil-surround-pairs-alist))

(use-package triples)

(defun mtn/org-insert-elisp-block ()
      (interactive)
      (org-insert-structure-template "src emacs-lisp"))

(defun mtn/org-toggle-babel-evaluate ()
    (interactive)
    (if org-confirm-babel-evaluate
        (setq org-confirm-babel-evaluate nil)
        (setq org-confirm-babel-evaluate t)))

(use-package general
  :config
  (general-create-definer mtn/leader-keys
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (mtn/leader-keys
    "a"  '(ace-window :which-key "switch window")
    "g"  '(:ignore t :which-key "git-gutter")
    "gg" '(git-gutter+-mode :which-key "git-gutter-mode")
    "gn" '(git-gutter+-next-hunk :which-key "next hunk")
    "gp" '(git-gutter+-previous-hunk :which-key "previous hunk")
    "gr" '(git-gutter+-revert-hunks :which-key "revert hunk")
    "gs" '(git-gutter+-show-hunk :which-key "show hunk")
    "s"  '(:ignore s :which-key "source code block")
    "se" '(mtn/org-insert-elisp-block :which-key "insert emacs lisp block")
    "t"  '(:ignore t :which-key "toggles")
    "t!" '(mtn/org-toggle-babel-evaluate :which-key "toggle DANGEROUS babel evaluation")
    "tt" '(counsel-load-theme :which-key "choose theme")
    "x"  '(:ignore t :which-key "scratch")
    "xx" '(text-scale-adjust :which-key "adjust text scale")
    "j" '(:ignore t :which-key "jump")
    "jg" '(dumb-jump-go :which-key "go")
    "l"  '(:ignore t :which-key "lsp")
    "lg" '(lsp-find-definition :which-key "goto definition")
    "lt" '(lsp-find-type-definition :which-key "goto type definition")
    "o" '(:ignore t :which-key "org")
    "od" '(org-update-all-dblocks :which-key "update all dblocks")
    "oj" '(org-clock-goto :which-key "goto current item")
    "op" '(org-publish-current-file :which-key "publish current file")
    "ot" '(org-babel-tangle :which-key "tangle")
    "w" '(:ignore t :which-key "word")
    "wd" '(dictionary-lookup-definition :which-key "definition" )))

(use-package ace-window)

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
    (setq which-key-idle-delay 0.3))
(global-whitespace-mode)
(setq whitespace-style '(face trailing tabs newline tab-mark newline-mark))
(setq whitespace-display-mappings
    '(;(space-mark   32 [?·])
      (newline-mark 10 [8629 10]       )
      (tab-mark     9  [187 9]   [92 9])
    )
)

(use-package command-log-mode)

(evil-mode 1)
(when (display-graphic-p)
  (server-start))

(setq dictionary-server "dict.org")
