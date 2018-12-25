(uiop/package:define-package :ql-checkout/github (:use :cl :ql-checkout/config) (:export :clone-github :pull-github))
(in-package :ql-checkout/github)
;;;don't edit above

(defun clone-github (owner/name &key
                                branch
                                (checkoutdir *checkoutdir*))
  (let ((dir (merge-pathnames (format nil "~A/" owner/name) checkoutdir)))
    (setq branch (if branch (format nil "-b ~A" branch) ""))
    (if (uiop:probe-file* dir)
        ()
        (uiop:run-program (format nil "git clone ~A https://github.com/~A.git ~A"
                                  branch
                                  owner/name
                                  (namestring (ensure-directories-exist dir)))))
    dir))

(defun pull-github (owner/name &key (checkoutdir *checkoutdir*))
  (let ((dir (merge-pathnames (format nil "~A/" owner/name) checkoutdir)))
    (if (uiop:probe-file* dir)
        (uiop:run-program (format nil "cd ~A;git pull"
                                  (namestring dir))
                          :output :interactive)
        (format t "pull ~A.directory not exist.Not cloned? ~%" owner/name))))
