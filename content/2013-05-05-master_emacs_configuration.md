title: Single File Master Emacs Configuration
author: Donald Curtis
tags: emacs

This configuration design uses as a single file (`~/.emacs.d/init.el`) to contain the *entire* Emacs configuration and `package.el` manages packages from the [MELPA](http://melpa.milkbox.net) repository. Basically this serves as a starting framework for building up and maintaining an Emacs configuration using `package.el` and provides some helper functionality that makes a single file approach work. For what it's worth, I think the way to go at building your own Emacs config is to start with the bare bones and build up customizations as you go, the way you like them.

## Boilerplate

Elisp files, at a minimum, should start with header line which gives the name of the file and a brief description; it's a good habit to get into. Below are the first lines of my `init.el` file. 

```common-lisp
;;; init.el --- Milkmacs configuration file

;; Turn off mouse interface early in startup to avoid momentary display
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please... jeez
(setq inhibit-startup-screen t)
```

The first three lines of actual Emacs Lisp (elisp) are to get rid of useless GUI items and maximize text real estate.

Next I put in the section to setup `package.el` and initialize installed packages since I want them available for the rest of the configuration.

```common-lisp
;;;; package.el
(require 'package)
(setq package-user-dir "~/.emacs.d/elpa/")
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-initialize)
```

This loads the *package* feature (provided by `package.el`), sets the path where I want installed packages kept, adds [MELPA](http://melpa.milkbox.net) to the list of package repositories, and then initializes any packages that are already installed.

I then have a function to quickly install rad (important) packages that I almost always *definitely* want. This function is useful when I blow away the `~/.emacs.d/elpa` directory for testing or when I am bootstrapping Emacs on a new machine.

```common-lisp
(defvar mp-rad-packages
  '(
    ;; ag
    ;; auto-complete
    ;; base16-theme
    ;; clojure-mode
    ;; company
    ;; deft
    ;; dired+
    ;; dropdown-list
    ;; evil
    ;; flx
    ;; gist
    ;; rainbow-delimiters
    ;; smartparens
    ace-jump-mode
    browse-kill-ring
    diminish
    expand-region
    git-commit-mode
    ido-ubiquitous
    ido-vertical-mode
    magit
    multiple-cursors
    smex
    undo-tree
    ))

(defun mp-install-rad-packages ()
  "Install only the sweetest of packages."
  (interactive)
  (package-refresh-contents)
  (mapc #'(lambda (package)
            (unless (package-installed-p package)
              (package-install package)))
        mp-rad-packages))
```

The function updates the local package repository information and then installs the packages in the order listed from top to bottom. I think you can do a similar thing on the command line using something like [Carbon](https://github.com/rejeep/carton) and [Pallet](https://github.com/rdallasgray/pallet) but this works for me and is simple as picking your nose---which you can do while packages are installing if that's your thing---and it keeps my package list right along side my configuration.


### The `after` macro

The key to my configuration and using `package.el` is lazy loading magic using this `after` macro,

```common-lisp
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))
```

This is simply a wrapper around `eval-after-load` and I have seen similar, sometimes fancier, versions elsewhere but this one is mine. Normally if you want something to load *after* a feature (package) loads you do something like,

```common-lisp
(eval-after-load 'python
  (progn
    (message "python has been loaded")
    (local-set-key (kbd "M-n") 'flymake-goto-next-error)
    (local-set-key (kbd "M-p") 'flymake-goto-prev-error)))
```

and using the `after` macro just cleans things up a bit,

```common-lisp
(after `python
  (message "python has been loaded")
  (local-set-key (kbd "M-n") 'flymake-goto-next-error)
  (local-set-key (kbd "M-p") 'flymake-goto-prev-error))
```

This may not seem like that much of a difference but the whole config relies on the `eval-after-load` + `progn` pattern so I like to use it. Now that I think about it, I should've made it much shorter but I don't want to deal with namespace errors.

Roughly speaking, the `after` macro specifies code to run when the specified feature (e.g., `python` in the above examples) loads from the file. If the feature is already loaded the code runs immediately.

## Sections

If you examine the example code above you'll notice lines starting with four semicolons (`;;;;`) followed by some text. These comments indicate different sections and with a bit of additional elisp they become functional.

```common-lisp
;;;; emacs lisp
(defun imenu-elisp-sections ()
  (setq imenu-prev-index-position-function nil)
  (add-to-list 'imenu-generic-expression '("Sections" "^;;;; \\(.+\\)$" 1) t))

(add-hook 'emacs-lisp-mode-hook 'imenu-elisp-sections)
```

By adding a hook to `emacs-lisp-mode`, which adds additional settings to `imenu`, we can use `imenu` to navigate to these different sections. This is hardly necessary with smaller configs and the simple boilerplate provided above, but as a single file configuration grows it becomes useful. Yes, this is when most people run for the hills and separate code into multiple files but with search capabilities and great features like `imenu` there is no need to.

When using this elisp in your config, `imenu` will have an entry called `Sections` that contains every section heading specified by the text following the `;;;; `. Thus the line `;;;; emacs lisp` will appear in `imenu` under the `Sections` sub-list---I never knew `imenu` was hierarchical until I copied this code from somewhere---and selecting will jump to that section line. As good as opening a file with the advantage that you can search all of your configuration without grep. Of course you can still use `occur` and search for `;;;; .+` if you to see all sections in a grep-like manner.


### Altogether

Below is the boilerplate code above put in a single file. To extend the file, place new configuration information before the `;;; init.el ends here` line---another elisp comment standard.

```common-lisp
;;; init.el --- Milkmacs configuration file

;; Turn off mouse interface early in startup to avoid momentary display
(when (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(when (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(when (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please... jeez
(setq inhibit-startup-screen t)


;;;; package.el
(require 'package)
(setq package-user-dir "~/.emacs.d/elpa/")
;; (add-to-list 'package-archives
;;              '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
;; (add-to-list 'package-archives '("melpa-local" . "/Users/dcurtis/src/melpa/packages/") t)
(package-initialize)

(defun mp-install-rad-packages ()
  "Install only the sweetest of packages."
  (interactive)
  (package-refresh-contents)
  (mapc '(lambda (package)
           (unless (package-installed-p package)
             (package-install package)))
        '(browse-kill-ring
          ido-ubiquitous
          magit
          paredit
          smex
          undo-tree)))

;;;; macros
(defmacro after (mode &rest body)
  "`eval-after-load' MODE evaluate BODY."
  (declare (indent defun))
  `(eval-after-load ,mode
     '(progn ,@body)))

;;;; global key bindings


;;;; emacs lisp
(defun imenu-elisp-sections ()
  (setq imenu-prev-index-position-function nil)
  (add-to-list 'imenu-generic-expression '("Sections" "^;;;; \\(.+\\)$" 1) t))

(add-hook 'emacs-lisp-mode-hook 'imenu-elisp-sections)


;;; init.el ends here
```

# &rest

*I don't suggest you take any of what follows and throw it into your configuration. Starting your configuration from scratch and adding configuration as needed is the way to go; steal good ideas but make it your own. Configuration code that appears below is for demonstration purposes and mileage may vary. Plus it's probably not the right way to do things anyways.*

## Configuring Packages

When I add a package and want to add keybindings or set variables I wrap the commands in the `after` macro. There are two types of code I want to run,

1. Code that should run if the package is *available*
2. Code that should run when the package *loads*.

### Running code when a package is available.

There are times I start Emacs having no packages installed. The problem I encountered early on in my configuration career is code in my `init.el` that requires the package to be available. Luckily when `package.el` installs a new package it creates an autoload file that can be used to indicate that the package is installed. The generated file is the package name with `-autoloads` appended. For example, after installing the [multiple-cursors](https://github.com/magnars/multiple-cursors.el) package the file `multiple-cursors-autoloads.el` exists. When `package-initialize` runs it loads `multiple-cursors-autoloads.el` and when a file is loaded we can use a string to match the file name with the `after` macro.

The implication is we can have code that runs *only* if the package is actually installed simply by wrapping it in the `after` macro based on the `-autoloads` filename created by `package.el`. Since I don't want bindings for *multiple-cursors* unless it's actually installed I have the following,

```common-lisp
(after "multiple-cursors-autoloads"
  (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
  (global-set-key (kbd "C-S-c C-e") 'mc/edit-ends-of-lines)
  (global-set-key (kbd "C-S-c C-a") 'mc/edit-beginnings-of-lines)
  (global-set-key (kbd "C->") 'mc/mark-next-like-this)
  (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
  (global-set-key (kbd "C-<return>") 'mc/mark-more-like-this-extended)
  (global-set-key (kbd "C-S-SPC") 'set-rectangular-region-anchor)
  (global-set-key (kbd "C-M-=") 'mc/insert-numbers)
  (global-set-key (kbd "C-*") 'mc/mark-all-like-this)
  (global-set-key (kbd "C-S-<mouse-1>") 'mc/add-cursor-on-click))
```

Thus, if `multiple-cursors` is not installed this code will never run. If `multiple-cursors` *is* installed, through `package.el`, then this code *will* run. But Emacs will not *actually* load the `multiple-cursors` package until pressing one of the bound keys---which triggers the `autoload` mechanism for that particular function contained in the package.

Similarly, I don't want to enable `global-undo-tree-mode` unless `undo-tree` is *actually* installed so I have

```common-lisp
(after "undo-tree-autoloads"
  (global-undo-tree-mode t)
  (setq undo-tree-visualizer-relative-timestamps t)
  (setq undo-tree-visualizer-timestamps t))
```

And since I can't run a function provided by a package in a hook unless that package is actually installed, I make sure only to `add-hook` when the package is available. With `rainbow-delimiters` I have,

```common-lisp
(after "rainbow-delimiters-autoloads"
  (add-hook 'prog-mode-hook 'rainbow-delimiters-mode-enable))
```

Again, this code is *only* when an installation of `rainbow-delimiters` through `package.el` exists.

All this may seem silly, but I tend to add and remove packages at will. Sometimes I will add a package, build up configuration for that package, then remove the package, but I still want to keep my configuration settings because some day I may want to install that package again. [helm](https://github.com/emacs-helm/helm) is a perfect example of a package I have installed a number of times but just can't get in to. I will occasionally install it again to give it another shot and my config is automatically activated after installing the package. Yet, when I inevitably decide to remove helm, my personalized settings for helm stay `init.el` without interfering with the future---which we know from Back to the Future II can be devestating.

### Running code when a package loads.

The more obvious use of `after`---based on the more obvious application of `eval-after-load`---is to run some code only after loading the package. Commonly, variables are not available before loading the package and thus trying to set them prior to loading can cause errors and break things. Some of my uses probably don't warrant wrapping them in the `after` macro but I just do it anyways to be sure.

For `yasnippet` I want to reload all snippets and modify the `yas/prompt-functions` variable so I have,

```common-lisp
(after 'yasnippet
  (yas/reload-all)
  (setq yas/prompt-functions '(yas/ido-prompt yas/completing-prompt yas/no-prompt)))
```

or after loading `latex`,

```common-lisp
(after 'latex
  (add-hook 'LaTeX-mode-hook 'TeX-source-correlate-mode)
  (add-hook 'LaTeX-mode-hook 'variable-pitch-mode)
  (add-hook 'LaTeX-mode-hook 'TeX-fold-mode)

  (setq TeX-source-correlate-method 'synctex)
  (setq TeX-auto-save t)
  (setq TeX-parse-self t)
  (setq TeX-save-query nil)
  (setq TeX-item-indent 0)
  (setq TeX-newline-function 'reindent-then-newline-and-indent)
  (setq-default TeX-PDF-mode t)
  (setq TeX-view-program-list
        '(("Skim"
           "/Applications/Skim.app/Contents/SharedSupport/displayline %n %o %b")))
  (setq TeX-view-program-selection '((output-pdf "Skim")))


  (add-hook 'LaTeX-mode-hook 'flyspell-mode)
  (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
  (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
  (setq reftex-plug-into-AUCTeX t)
  (define-key TeX-mode-map (kbd "C-M-h") 'mark-paragraph)
  (define-key TeX-mode-map (kbd "C-c C-m") 'TeX-command-master)
  (define-key TeX-mode-map (kbd "C-c C-c") 'TeX-compile))
```

In both cases this code executes after the package loads.


### Combinations

Occasionally I want to combine these like I do with `diminish`,

```common-lisp
(after "diminish-autoloads"
  (after 'paredit (diminish 'paredit-mode " pe"))
  (after 'yasnippet (diminish 'yas-minor-mode " ys"))
  (after 'undo-tree (diminish 'undo-tree-mode " ut"))
  (after 'checkdoc (diminish 'checkdoc-minor-mode " cd")))
```


# &optional

[My config on GitHub](https://github.com/milkypostman/dotemacs) contains lots of stuff stolen from the following two configs and reorganized into a single big `init.el` file.

[Magnar's config on GitHub](https://github.com/magnars/.emacs.d) is a great place to find awesome config stuff. I have no idea where he comes up with half of it; must be drugs.

[Purcell's config on GitHub](https://github.com/purcell/emacs.d) is a great place for finding awesome config stuff managed by someone who turns my elisp into works of art; must be drugs.


    
