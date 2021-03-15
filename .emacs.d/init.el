(load-theme 'deeper-blue)

(setq inhibit-startup-message t)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(setq display-time-default-load-average nil)
(setq display-time-24hr-format t)
(display-time-mode 1)

(set-face-attribute 'default nil :font "Monaco" :height 180)

;;Set command key as meta for macOS
(setq-default mac-command-modifier 'meta)

(setq-default fill-column 85)
(setq-default tab-width 4)
(show-paren-mode 1)

(global-display-line-numbers-mode 1)
(dolist (mode '(org-mode-hook
				eshell-mode-hook
				dired-mode-hook
				speedbar-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

(setq backup-by-copying t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions t)
(setq kept-new-versions 3)
(setq kept-old-versions 2)
(setq version-control t)

(setq c-default-style "bsd"
      c-basic-offset 4)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x j" . dired-jump)
		 :map dired-mode-map
		 ("=" . 'dired-find-file)
		 ("-" . 'dired-up-directory)
		 ("/" . 'dired-diff))
  :hook
  (dired-mode . dired-hide-details-mode))

(use-package diminish)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)	
         :map ivy-switch-buffer-map
         ("C-k" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-reverse-i-search-kill))
  :config
  (setq ivy-use-virtual-buffers t)
  (ivy-mode 1))
(use-package swiper)
(use-package counsel
  :diminish
  :bind (("M-x" . counsel-M-x)
		 ("C-x C-b" . counsel-ibuffer)
		 ("C-x b" . counsel-switch-buffer)
		 ("C-x C-f" . counsel-find-file)
		 :map minibuffer-local-map
		 ("C-r" . counsel-minibuffer-history))
  :config
  (counsel-mode 1))

(use-package sr-speedbar
  :config
  (setq speedbar-use-images nil
		sr-speedbar-width-window 25
		speedbar-show-unknown-files t
		sr-speedbar-right-side nil
		sr-speedbar-auto-refresh nil)
  :bind (("C-t" . sr-speedbar-toggle)))

(use-package org
  :config
  (set-face-underline 'org-ellipsis nil)
  (setq org-agenda-start-with-log-mode t
		org-log-done 'time
		org-log-into-drawer t
		org-agenda-files (list "~/org/Tasks.org"
							   "~/org/Birthdays.org")
		org-agenda-span 10
		org-agenda-start-on-weekday nil
		org-agenda-start-day "-3d"
		org-todo-keywords
		'((sequence "TODO(t)" "|" "DONE(d!)")
		  (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "|" "CANC(k@)"))
		org-refile-targets '(("Archive.org" :maxlevel . 1)
							 ("Tasks.org" :maxlevel . 1))
		org-capture-templates '(("t" "Tasks" entry (file+headline "~/org/Captures.org" "Tasks")
								 "* TODO %?\n  %i\n  %a")
								("i" "Oncall Incidents" entry (file+olp+datetree "~/org/oncall.org" "Oncall Incidents")
								 "* %?\n %U\n"))
		org-ellipsis " v")
  (advice-add 'org-refile :after 'org-save-all-org-buffers)
  :bind (("C-c l" . org-store-link)
		 ("C-c a" . org-agenda)
		 ("C-c c" . org-capture)))
(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

(use-package exec-path-from-shell
  :if (or (memq window-system '(mac ns x))
		  (daemonp))
  :init
  (setq exec-path-from-shell-variables '("PATH" "MANPATH" "SSH_AUTH_SOCK" "GOROOT" "GOPATH"))
  :config
  (exec-path-from-shell-initialize))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :demand t
  :bind-keymap
  ("C-c p" . projectile-command-map))

(use-package counsel-projectile
  :config
  (counsel-projectile-mode))

(use-package magit
  :bind ("C-M-;" . magit-status)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


(use-package go-mode)

(use-package lsp-mode
  :commands
  (lsp lsp-deferred)
  :hook
  ((js-mode jsx-mode go-mode) . lsp-deferred)
  :init
  (setq lsp-keymap-prefix "C-c C-l"))
;; Installation steps of language servers used so far
;; ======================GOLANG===========================
;; go get golang.org/x/tools/gopls@latest
;; source following env variables
;; export GOPATH=$HOME/Projects/go
;; export GOROOT="/usr/local/go"
;; export PATH="$PATH:${GOPATH}/bin:${GOROOT}/bin"
;; ===============JavaScript/TypeScript===================
;; npm i -g typescript-language-server; npm i -g typescript

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

;; C-a to beginning of command instead of beginning of line
(defun eshell-maybe-bol ()
  (interactive)
  (let ((p (point)))
    (eshell-bol)
    (if (= p (point))
        (beginning-of-line))))
(add-hook 'eshell-mode-hook
          '(lambda () (define-key eshell-mode-map "\C-a" 'eshell-maybe-bol)))
