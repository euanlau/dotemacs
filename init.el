(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(if (not (require 'el-get nil t))
    (url-retrieve
     "https://github.com/dimitri/el-get/raw/master/el-get-install.el"
     (lambda (s)
       (let (el-get-master-branch)
         (end-of-buffer)
         (eval-print-last-sexp))
       (load-file "~/.emacs.d/init.el")))

  (setq el-get-sources
        '((:name async
                 :description "Simple library for asynchronous processing in Emacs"
                 :type github
                 :pkgname "jwiegley/emacs-async"
                 :features async)
          (:name emms
                 :description "The Emacs Multimedia System"
                 :type git
                 :url "git://git.sv.gnu.org/emms.git"
                 :info "doc"
                 :load-path ("./lisp")
                 :features emms-setup
                 :build `(("mkdir" "-p" ,(expand-file-name (format "%s/emms" user-emacs-directory)))
                          ("make" ,(format "EMACS=%s" el-get-emacs)
                           ,(format "SITEFLAG=\\\"--no-site-file -L %s/emacs-w3m/ \\\""
                                    el-get-dir)
                           "autoloads" "lisp" "docs")
                          ("make" "emms-print-metadata")
                          ("mv" "src/emms-print-metadata" ,(expand-file-name "bin/" user-emacs-directory)))
                 :depends emacs-w3m)
          (:name jedi
                 :description "An awesome Python auto-completion for Emacs"
                 :type github
                 :pkgname "tkf/emacs-jedi"
                 :build (("PYTHON=python2" "make" "requirements"))
                 :submodule nil
                 :depends (epc auto-complete))
          (:name multi-web-mode
                 :description "Multi Web Mode is a minor mode which makes web editing in Emacs much easier"
                 :type github
                 :pkgname "fgallina/multi-web-mode"
                 :features multi-web-mode)
          (:name org-s5
                 :description "Org-mode html export of S5 slideshow presentations"
                 :type github
                 :pkgname "fgallina/org-S5"
                 :features org-export-as-s5)
          (:name startupd
                 :description "Modular loading of Emacs configuration"
                 :type github
                 :pkgname "fgallina/startupd.el"
                 :features startupd)
          (:name pymacs2
                 :description "Interface between Emacs Lisp and Python"
                 :type github
                 :pkgname "pinard/Pymacs"
                 :features pymacs
                 :prepare
                 (progn
                   (el-get-envpath-prepend "PYTHONPATH" (expand-file-name "~/.emacs.d/el-get/pymacs2/"))
                   (el-get-envpath-prepend "PYTHONPATH" (expand-file-name "~/.emacs.d/el-get/rope/"))
                   (el-get-envpath-prepend "PYTHONPATH" (expand-file-name "~/.emacs.d/el-get/ropemode/"))
                   (el-get-envpath-prepend "PYTHONPATH" (expand-file-name "~/.emacs.d/el-get/ropemacs/"))
                   (autoload 'pymacs-load "pymacs" nil t)
                   (autoload 'pymacs-eval "pymacs" nil t)
                   (autoload 'pymacs-exec "pymacs" nil t)
                   (autoload 'pymacs-call "pymacs")
                   (autoload 'pymacs-apply "pymacs"))
                 :build (("make" "PYTHON=python2")))
          (:name python
                 :description "Python's flying circus support for Emacs"
                 :type github
                 :branch "emacs-24"
                 :pkgname "fgallina/python.el")
          (:name python-django
                 :description "An Emacs package for managing Django projects"
                 :type github
                 :pkgname "fgallina/python-django.el"
                 :features python-django)
          (:name region-bindings-mode
                 :description "A minor mode that enables custom bindings when mark is active."
                 :type github
                 :pkgname "fgallina/region-bindings-mode"
                 :features region-bindings-mode)
          (:name undo-tree
                 :description "Treat undo history as a tree"
                 :type github
                 :pkgname "emacsmirror/undo-tree"
                 :prepare (progn
                            (autoload 'undo-tree-mode "undo-tree.el"
                              "Undo tree mode; see undo-tree.el for details" t)
                            (autoload 'global-undo-tree-mode "undo-tree.el"
                              "Global undo tree mode" t))))
        el-get-user-package-directory "~/.emacs.d/conf")

  (setq my:el-get-packages
        '(ace-jump-mode
          async
          auto-complete
          clojure-mode
          coffee-mode
          deft
          dired-details
          emms
          expand-region
          full-ack
          gh
          gist
          jedi
          jquery-doc
          lua-mode
          magit
          markdown-mode
          multiple-cursors
          multi-web-mode
          org-mode
          org-s5
          o-blog
          php-mode-improved
          ropemacs
          pymacs2
          python
          python-django
          rainbow-mode
          region-bindings-mode
          rcirc-groups
          rcirc-notify
          scss-mode
          slime
          sunrise-commander
          sunrise-x-buttons
          sunrise-x-loop
          undo-tree
          smex
          smart-tab
          startupd
          yaml-mode
          yasnippet
          zencoding-mode))

  (el-get 'sync my:el-get-packages)

  (ignore-errors (load-file "~/.emacs.d/secrets.el"))
  (ignore-errors (load-file "~/.emacs.d/pre-startup.el"))
  (startupd-load-files)
  (ignore-errors (load-file "~/.emacs.d/post-startup.el"))

  (setq custom-file "~/.emacs.d/customizations.el")
  (load custom-file 'noerror))
