;; Compiles .yaml files (in the current dir) following base16
;; specification for each theme in the ef-themes package by protesilaos:
;; https://protesilaos.com/emacs/ef-themes

;; download latest ef-themes repo
(setq download-dir (concat temporary-file-directory "ef-themes/"))

(shell-command (concat "git clone https://github.com/protesilaos/ef-themes " download-dir))

(add-to-list 'load-path download-dir)
;;end

;; script
(require 'ef-themes)

(defun alist-fmap (f alist)
  (mapcar (lambda (x)
	    (cons (car x) (funcall f (cdr x))))
	  alist))

(defun b16format (str)
  (upcase (string-replace "#" "" str)))

(defun colors (theme)
      (append
       (list (cons "scheme" (symbol-name theme))
	     (cons "author" "protesilaos"))
       (alist-fmap 'b16format
		   (list (cons "base00" (ef-themes-get-color-value 'bg-main theme))
		 	 (cons "base01" (ef-themes-get-color-value 'fg-dim theme))
			 (cons "base02" (ef-themes-get-color-value 'bg-hover theme))
			 (cons "base03" (ef-themes-get-color-value 'comment theme))
			 (cons "base04" (ef-themes-get-color-value 'bg-mode-line theme))
			 (cons "base05" (ef-themes-get-color-value 'fg-main theme))
			 (cons "base06" (ef-themes-get-color-value 'fg-dim theme))
			 (cons "base07" (ef-themes-get-color-value 'bg-dim theme))
			 (cons "base08" (ef-themes-get-color-value 'variable theme))
			 (cons "base09" (ef-themes-get-color-value 'constant theme))
			 (cons "base0A" (ef-themes-get-color-value 'type theme))
			 (cons "base0B" (ef-themes-get-color-value 'string theme))
			 (cons "base0C" (ef-themes-get-color-value 'rx-escape theme))
			 (cons "base0D" (ef-themes-get-color-value 'fnname theme))
			 (cons "base0E" (ef-themes-get-color-value 'keyword theme))
			 (cons "base0F" (ef-themes-get-color-value 'preprocessor theme))))))

(defun gen-yaml (alist)
  (if (eq nil alist)
      ""
    (let* ((cur (car alist))
	   (key (car cur))
	   (value (cdr cur)))
      (concat key ": \"" value "\"\n"
	      (gen-yaml (cdr alist))))))

(defun write-yaml (theme)
  "Convert Ef theme to a yaml file following base16 specification"
  (with-temp-file (concat (symbol-name theme) ".yaml")
    (insert (gen-yaml (colors theme)))))

(defun write-yaml--list (themes)
  (if (eq nil themes)
      t
    (let ((cur (car themes)))
      (write-yaml cur)
      (write-yaml--list (cdr themes)))))

(write-yaml--list (append ef-themes-light-themes ef-themes-dark-themes))

;; delete ef-themes repo
(delete-directory download-dir t)
