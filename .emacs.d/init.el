(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))
(setq package-enable-at-startup nil)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'custom-theme-load-path "~/.emacs.d/themes/")

(custom-set-variables
 '(column-number-mode t)
 '(custom-enabled-themes '(gruvbox-custom))
 '(custom-safe-themes  '(default))
 '(display-line-numbers t)
 '(fringe-mode 0 nil (fringe))
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(initial-scratch-message nil)
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Minimize garbage collection during startup
(setq gc-cons-threshold most-positive-fixnum)

;; Lower threshold back to 8 MiB (default is 800kB)
(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (expt 2 23))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Unbind unhelpful keys
(global-unset-key (kbd "C-x C-d"))      ;; list-directory
(global-unset-key (kbd "C-x d"))       ;; dired
(global-unset-key (kbd "C-z"))         ;; suspend-frame
(global-unset-key (kbd "C-x C-z"))     ;; suspend-frame
(global-unset-key (kbd "C-x <left>"))  ;; previous-buffer
(global-unset-key (kbd "C-x <right>")) ;; next-buffer
(global-unset-key (kbd "C-x f"))       ;; set-fill-column

;; Move binds around to be more ergonomic
(global-set-key (kbd "C-c v") 'goto-line)
(global-set-key (kbd "C-c r") 'query-replace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Save backup files in a custom directory
(setq backup-directory-alist '(("." . "~/.emacs.d/backups/")))

(setq confirm-kill-emacs 'y-or-n-p)

;; Set scratch to text-mode
(setq initial-major-mode 'text-mode)

(add-hook 'before-save-hook #'delete-trailing-whitespace)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(windmove-default-keybindings)

(straight-use-package 'use-package)

(use-package clang-format
  :straight t)

(use-package yank-indent
  :straight (:host github :repo "jimeh/yank-indent")
  :config (global-yank-indent-mode t))

(use-package fzf
  :straight t
  :bind
  ("C-x f" . fzf-directory)
  ("C-c g" . fzf-grep-in-dir)
  :config
  (setq fzf/args "-x --color bw --print-query --no-hscroll"
        fzf/executable "fzf"
        fzf/git-grep-args "-i --line-number %s"
        fzf/grep-command "rgrep -nH"
        fzf/position-bottom t
        fzf/window-height 20))

(use-package windower
  :straight t
  :bind
  ("M-S-<left>"  . windower-move-border-left)
  ("M-S-<right>" . windower-move-border-right)
  ("M-S-<up>"    . windower-move-border-above)
  ("M-S-<down>"  . windower-move-border-below))

(use-package corfu
  :straight t
  :custom
  (corfu-auto t)
  (corfu-auto-delay 0)
  (corfu-auto-prefix 1)
  (corfu-default "#ccc")
  :hook ((c-mode . corfu-mode)
         (c++-mode . corfu-mode)))

(use-package vterm
  :straight t
  :config
  (setq vterm-max-scrollback 9001))

(use-package multi-vterm
  :straight t)

(use-package cmake-mode
  :straight t
  :hook cmake-mode)

(use-package eglot
  :straight t
  :hook (c++-mode . eglot-ensure)
  :hook (c-mode   . eglot-ensure)
  :custom
  (eglot-ignored-server-capabilities '(:inlayHintProvider)))

(with-eval-after-load 'eglot
    (add-to-list 'eglot-server-programs
                 '((c++-mode c-mode)
                   . ("clangd"
                      "-j=12"
                      "--malloc-trim"
                      "--background-index"
                      "--pch-storage=memory"
                      "--completion-style=detailed"))))
(use-package ivy-xref
  :straight t
  :config
  (setq xref-show-xrefs-function 'ivy-xref-show-xrefs))

(use-package recentf
  :config
;;(add-to-list 'recentf-exclude "/path/to/excluded/dir/")
  (recentf-mode))

(use-package counsel
  :straight t
  :config
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-extra-directories nil)
;;  (setcdr (assoc 'counsel-M-x ivy-initial-inputs-alist) "")
  (define-key ivy-minibuffer-map (kbd "TAB") 'ivy-alt-done)
  :bind
  ("C-x C-f" . counsel-find-file)
  ("M-x" . counsel-M-x)
  ("C-c f" . counsel-recentf)
  ("C-s" . swiper-isearch)
  ("C-r" . swiper-isearch-backward)
  :init
  (counsel-mode))

(use-package tree-sitter
  :straight t
  :hook (c-mode . tree-sitter-mode)
  :hook (c++-mode . tree-sitter-mode))

(use-package tree-sitter-langs
  :straight t)

(use-package ts-fold
  :straight (ts-fold :type git :host github :repo "emacs-tree-sitter/ts-fold")
  :requires diminish
  :after tree-sitter
  :hook (c-mode . ts-fold-mode)
  :hook (c++-mode . ts-fold-mode)
  :bind (:map c-mode-map ("C-<tab>" . ts-fold-toggle))
  :bind (:map c++-mode-map ("C-<tab>" . ts-fold-toggle))
  :config (diminish 'ts-fold-mode ""))

(use-package which-key
  :straight t
  :init
  (which-key-mode t))

(use-package vundo
  :straight t
  :bind
  ("C-c u" . vundo)
  :custom
  (vundo-glyph-alist vundo-unicode-symbols))

(use-package perspective
  :straight t
  :after counsel
  :bind
  ("C-c <left>" . persp-prev)
  ("C-c <right>" . persp-next)
  ("C-x b" . persp-counsel-switch-buffer)
  ("C-c p c" . persp-switch)
  ("C-c p k" . persp-remove-buffer)
  ("C-c p a" . persp-add-buffer)
  ("C-c p s" . persp-state-save)
  ("C-c p l" . persp-state-load)
  ("C-c p r" . persp-kill)
  :custom
  (persp-suppress-no-prefix-key-warning t)
  (persp-state-default-file "~/.emacs.d/perspective-states/")
  :init
  (persp-mode))

(use-package ivy-prescient
  :straight t
  :init
  (ivy-prescient-mode))

(use-package diminish
  :straight t
  :after which-key
  :init
  (diminish 'counsel-mode       "")
  (diminish 'eldoc-mode         "")
  (diminish 'yank-indent-mode   "")
  (diminish 'tree-sitter-mode   "")
  (diminish 'eldoc-mode         "")
  (diminish 'abbrev-mode        "")
  (diminish 'which-key-mode     ""))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun revert-buffer-no-confirm ()
  "Revert buffer without confirmation if buffer is unmodified."
  (interactive)
  (revert-buffer t (not (buffer-modified-p)) t))
(global-set-key (kbd "C-c q") 'revert-buffer-no-confirm)


(defun infer-indentation-style ()
  ;; if our source file uses tabs, we use tabs, if spaces spaces, and if
  ;; neither, we use the current indent-tabs-mode
  (let ((space-count (how-many "^  " (point-min) (point-max)))
        (tab-count (how-many "^\t" (point-min) (point-max))))
    (if (> space-count tab-count) (setq indent-tabs-mode nil))
    (if (> tab-count space-count) (setq indent-tabs-mode t))))
(add-hook 'c-mode-hook (lambda () (infer-indentation-style)))
(add-hook 'c++-mode-hook (lambda () (infer-indentation-style)))

(defun clang-format-save-hook-for-this-buffer ()
  "Create a buffer local save hook."
  (add-hook 'before-save-hook
            (lambda ()
              (when (locate-dominating-file "." ".clang-format")
                (clang-format-buffer))
              ;; Continue to save.
              nil)
            nil
            ;; Buffer local hook.
            t))
(add-hook 'c-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))
(add-hook 'c++-mode-hook (lambda () (clang-format-save-hook-for-this-buffer)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;