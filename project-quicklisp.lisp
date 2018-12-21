(uiop/package:define-package :ql-checkout/project-quicklisp (:use :ql-checkout/meta-project :cl))
(in-package :ql-checkout/project-quicklisp)
;;;don't edit above

(defclass quicklisp-projects (project) ())

(defun ensure-projectdata ()
  (clone-github "quicklisp/quicklisp-projects"))

(defmethod find-source ((project quicklisp-projects) name)
  (declare (ignore project))
  (let* ((name (remove #\/ name))
         (dir (ensure-projectdata))
         (path (merge-pathnames (format nil "projects/~A/source.txt" name) dir)))
    (when (probe-file path)
      (uiop:read-file-line path))))

(register-project 'quicklisp-projects)
