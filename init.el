;;; GENERAL EMACS SETTINGS

;; Speed up initial startup
;; Set garbage collection less frequently
(setq
 gc-cons-threshold (* 100 1024 1024)
 gc-cons-percentage 0.6
 read-process-output-max (* 1024 1024))

;; Non-package specific variables
(setq
 display-line-numbers-type 'visual ;; Show relative line numbers in relation to the current line
 ring-bell-function 'ignore        ;; Remove annoying bell sound
 inhibit-splash-screen t           ;; Don't show the splash screen
 auto-save-default nil             ;; Don't auto-save files
 initial-scratch-message nil       ;; Don't show a message when opening a *scratch* buffer
 confirm-kill-emacs 'y-or-n-p      ;; Ask before exiting emacs
 scroll-step 1)                    ;; Don't jump around when scrolling

;; Custom files config
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(load custom-file 'noerror 'nomessage)

;; Backup files config
(setq
 make-backup-files t
 backup-directory-alist '(("." . ,(expand-file-name "backups/" user-emacs-directory)))
 version-control t
 kept-new-versions 6
 kept-old-versions 2
 delete-old-versions t)

(setq-default
 cursor-in-non-selected-windows nil ;; Do not show cursor in non-selected windows
 fill-column 120		    ;; Set fill column at line 120
 line-spacing 8			    ;; Put more padding between lines for readability
 indent-tabs-mode nil)		    ;; Use spaces instead of tabs for indentation

(tool-bar-mode -1)                    ;; Disable the tool bar
(menu-bar-mode -1)                    ;; Disable the menu bar
(scroll-bar-mode -1)                  ;; Disable the scroll bar
(blink-cursor-mode -1)                ;; Disable blinking cursor
(tooltip-mode -1)                     ;; Display tips in the minibuffer
(column-number-mode)                  ;; Show column number in the modeline
(global-display-line-numbers-mode -1) ;; Do not show line numbers everywhere
(delete-selection-mode t)             ;; Delete selecteion when typing a new text
(electric-pair-mode t)                ;; Automatically insert paren pairs
(pixel-scroll-precision-mode t)       ;; Smoother scrolling
(which-key-mode t)                    ;; Enable which-key to help with keybindings
(add-to-list 'default-frame-alist '(fullscreen . maximized)) ;; Maximize Emacs on init

;; === LINE NUMBERS: Only prog-mode + org-mode ===
(dolist (hook '(prog-mode-hook org-mode-hook))
  (add-hook hook #'display-line-numbers-mode))

;; === VISUAL LINE MODE: Only text + org ===
(dolist (hook '(text-mode-hook org-mode-hook))
  (add-hook hook #'visual-line-mode))

;; === FILL COLUMN: Only code ===
(add-hook 'prog-mode-hook #'display-fill-column-indicator-mode)


;;; PACKAGES

;; Manually initialize and activate packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/") t)
(package-initialize)

;; Only activate after use-package is available
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

;; === UI & UX ===
;; helpful: Alternative to Emacs help that provides more contextual information.
(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)))

;; === CORE TOOLS ===
;; Minibuffer Completion Framework
(use-package vertico
  :init (vertico-mode))

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles partial-completion)))))

(use-package marginalia
  :init (marginalia-mode))

;; TODO: Setup basic keybindings for consult
(use-package consult)
;; consult-imenu
;; consult-grep
;; consult-buffer

;; In-buffer completion
(use-package corfu
  :init (global-corfu-mode)
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0.2))
  
(use-package cape
  :init
  (add-hook 'completion-at-point-functions #'cape-dabbrev)
  (add-hook 'completion-at-point-functions #'cape-file)
  (add-hook 'completion-at-point-functions #'cape-elisp-block)
  (add-hook 'completion-at-point-functions #'cape-keyword))

(use-package kind-icon
  :after corfu
  :config (add-to-list 'corfu-margin-formatters #'kind-icon-margin-formatter))

;; Git
(use-package magit)

(use-package forge
  :after magit
  :pin melpa-stable)
(use-package markdown-mode
  :pin melpa-stable
  :mode ("\\.md\\'" . markdown-mode))

;; === C++ ===

;; === WEB DEVELOPMENT ===

;; === ORG-MODE ===
(use-package toc-org
  :hook (org-mode . toc-org-enable))

