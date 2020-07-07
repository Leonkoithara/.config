(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(load-theme 'deeper-blue)
 (setq initial-frame-alist
       '((top . 1) (left . 1) (width . 140) (height . 60)))


(global-set-key (kbd "C-c l") 'org-store-link)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)

(setq-default fill-column 85)

(setq backup-by-copying t)
(setq backup-directory-alist '(("." . "~/.emacs.d/backups")))
(setq delete-old-versions t)
(setq kept-new-versions 3)
(setq kept-old-versions 2)
(setq version-control t)

(setq c-default-style "bsd"
      c-basic-offset 4)

(add-hook 'after-init-hook 'global-company-mode)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages (quote (company-go company go-eldoc go-mode org))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(defun go-mode-setup()
  (linum-mode 1)
  (go-eldoc-setup)
  (setq tab-width 4)
  (local-set-key (kbd "M-.") 'godef-jump)
  (add-hook 'before-save-hook 'gofmt-before-save)
  )

(add-hook 'go-mode-hook 'go-mode-setup)
