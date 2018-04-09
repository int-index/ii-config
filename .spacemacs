;; -*- mode: emacs-lisp -*-

(defun dotspacemacs/layers ()
  (setq-default
   dotspacemacs-distribution 'spacemacs
   dotspacemacs-enable-lazy-installation 'unused
   dotspacemacs-ask-for-lazy-installation t
   dotspacemacs-configuration-layer-path '()
   dotspacemacs-configuration-layers
   '(
     helm
     ;; auto-completion
     html
     yaml
     emacs-lisp
     nixos
     git
     haskell
     python
     coq
     markdown
     racket
     javascript
     (org :variables
          org-clock-into-drawer nil
          org-startup-folded nil
          org-time-stamp-rounding-minutes (quote (0 0)))
     (shell :variables
            shell-default-height 30
            shell-default-position 'bottom)
     (spell-checking :variables
                     ispell-program-name "aspell")
     )
   dotspacemacs-additional-packages '()
   dotspacemacs-frozen-packages '()
   dotspacemacs-excluded-packages '(
     ;; see #9374
     org-projectile
     ;; do not like it
     evil-escape)
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  (setq-default
   dotspacemacs-elpa-https t
   dotspacemacs-elpa-timeout 5
   dotspacemacs-check-for-update nil
   dotspacemacs-elpa-subdirectory nil
   dotspacemacs-editing-style 'vim
   dotspacemacs-verbose-loading t
   dotspacemacs-startup-banner nil
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   dotspacemacs-startup-buffer-responsive t
   dotspacemacs-scratch-mode 'text-mode
   dotspacemacs-themes '(leuven spacemacs-dark)
   dotspacemacs-colorize-cursor-according-to-state t
   dotspacemacs-default-font '("Iosevka-12")
   dotspacemacs-leader-key "SPC"
   dotspacemacs-emacs-command-key "SPC"
   dotspacemacs-ex-command-key ":"
   dotspacemacs-emacs-leader-key "M-m"
   dotspacemacs-major-mode-leader-key ","
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   dotspacemacs-distinguish-gui-tab nil
   dotspacemacs-remap-Y-to-y$ nil
   dotspacemacs-retain-visual-state-on-shift t
   dotspacemacs-visual-line-move-text nil
   dotspacemacs-ex-substitute-global nil
   dotspacemacs-default-layout-name "Default"
   dotspacemacs-display-default-layout nil
   dotspacemacs-auto-resume-layouts nil
   dotspacemacs-large-file-size 1
   dotspacemacs-auto-save-file-location 'cache
   dotspacemacs-max-rollback-slots 5
   dotspacemacs-helm-resize nil
   dotspacemacs-helm-no-header nil
   dotspacemacs-helm-position 'bottom
   dotspacemacs-helm-use-fuzzy 'always
   dotspacemacs-enable-paste-transient-state nil
   dotspacemacs-which-key-delay 0.4
   dotspacemacs-which-key-position 'bottom
   dotspacemacs-loading-progress-bar t
   dotspacemacs-fullscreen-at-startup nil
   dotspacemacs-fullscreen-use-non-native nil
   dotspacemacs-maximized-at-startup nil
   dotspacemacs-active-transparency 90
   dotspacemacs-inactive-transparency 90
   dotspacemacs-show-transient-state-title t
   dotspacemacs-show-transient-state-color-guide t
   dotspacemacs-mode-line-unicode-symbols t
   dotspacemacs-smooth-scrolling t
   dotspacemacs-line-numbers 'relative
   dotspacemacs-folding-method 'evil
   dotspacemacs-smartparens-strict-mode nil
   dotspacemacs-smart-closing-parenthesis nil
   dotspacemacs-highlight-delimiters 'all
   dotspacemacs-persistent-server nil
   dotspacemacs-search-tools '("ag" "pt" "ack" "grep")
   dotspacemacs-default-package-repository nil
   dotspacemacs-whitespace-cleanup 'changed
   ))

(defun dotspacemacs/user-init ()
  (setq evil-want-abbrev-expand-on-insert-exit nil)
  )

(defun dotspacemacs/user-config ()
  ;; rebind keys
  (define-key key-translation-map (kbd "M-SPC") (kbd "C-g"))
  (define-key sp-pair-overlay-keymap (kbd "C-g") #'evil-force-normal-state)
  (define-key evil-insert-state-map (kbd "C-g") #'evil-force-normal-state)
  (define-key evil-insert-state-map (kbd "C-d") #'evil-delete-char)
  (define-key evil-insert-state-map (kbd "C-e") #'evil-end-of-visual-line)

  ;; fill column indicator
  (add-hook 'haskell-mode-hook #'turn-on-fci-mode)
  (add-hook 'emacs-lisp-mode-hook #'turn-on-fci-mode)

  ;; https://github.com/Fuco1/smartparens/issues/697#issuecomment-294276105
  (eval-after-load 'smartparens
    '(progn
       (sp-pair "(" nil :actions '(:rem insert))
       (sp-pair "[" nil :actions '(:rem insert))
       (sp-pair "'" nil :actions '(:rem insert))
       (sp-pair "\"" nil :actions '(:rem insert))
       (sp-pair "`" nil :actions '(:rem insert))
       (sp-pair "{" nil :post-handlers '(:add ("||\n[i]" "RET")))))

  ;; evil-surround: p(arentheses) and b[rackets]
  (add-hook 'after-change-major-mode-hook (lambda ()
    (push '(?p . ("(" . ")")) evil-surround-pairs-alist)
    (push '(?b . ("[" . "]")) evil-surround-pairs-alist)))

  ;; (defun redraw-hook (_) (run-at-time 0.3 nil (lambda ()(redraw-display))))
  ;; (add-hook 'after-make-frame-functions #'redraw-hook)
  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(evil-want-Y-yank-to-eol nil)
 '(package-selected-packages
   (quote
    (company-math math-symbol-lists faceup spinner powerline multiple-cursors packed gitignore-mode yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode dash-functional helm-pydoc cython-mode anaconda-mode pythonic flycheck iedit magit-popup with-editor simple-httpd dash epl yasnippet org-plus-contrib magit git-commit ghub hydra web-mode scss-mode nix-mode linum-relative dumb-jump ace-window ghc smartparens highlight evil projectile helm helm-core company yaml-mode xterm-color ws-butler winum which-key web-beautify volatile-highlights vi-tilde-fringe uuidgen use-package undo-tree toc-org tern tagedit spaceline smeargle slim-mode shell-pop sass-mode restart-emacs rainbow-delimiters racket-mode pug-mode popwin persp-mode pcre2el paradox orgit org-present org-pomodoro org-mime org-download org-bullets open-junk-file neotree multi-term move-text mmm-mode markdown-toc magit-gitflow macrostep lorem-ipsum livid-mode link-hint less-css-mode json-mode js2-refactor js-doc intero info+ indent-guide hungry-delete htmlize hlint-refactor hl-todo hindent highlight-parentheses highlight-numbers highlight-indentation hide-comnt help-fns+ helm-themes helm-swoop helm-projectile helm-nixos-options helm-mode-manager helm-make helm-hoogle helm-gitignore helm-flx helm-descbinds helm-css-scss helm-ag haskell-snippets goto-chg google-translate golden-ratio gnuplot gitconfig-mode gitattributes-mode git-timemachine git-messenger git-link gh-md flyspell-correct-helm flx-ido fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-magit evil-lisp-state evil-indent-plus evil-iedit-state evil-exchange evil-ediff evil-args evil-anzu eval-sexp-fu eshell-z eshell-prompt-extras esh-help emmet-mode elisp-slime-nav diminish define-word company-ghci company-ghc company-coq column-enforce-mode coffee-mode cmm-mode clean-aindent-mode auto-highlight-symbol auto-dictionary auto-compile aggressive-indent adaptive-wrap ace-link ace-jump-helm-line))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(proof-eager-annotation-face ((t (:background "medium blue"))))
 '(proof-error-face ((t (:background "dark red"))))
 '(proof-warning-face ((t (:background "indianred3")))))
