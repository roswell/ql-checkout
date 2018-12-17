(uiop/package:define-package :ql-checkout/project-quicklisp (:use :ql-checkout/meta-project :cl))
(in-package :ql-checkout/project-quicklisp)
;;;don't edit above

(defclass quicklisp-projects (project) ())

(defun ensure-projectdata ()
  (clone-github "quicklisp/quicklisp-projects"))

(defmethod find-source ((project quicklisp-projects) name)
  (declare (ignore project))
  (let ((name (remove #\/ (remove #\. name)))
        (dir (ensure-projectdata)))
    (uiop:read-file-line (merge-pathnames (format nil "projects/~A/source.txt" name) dir))))

(register-project 'quicklisp-projects)
