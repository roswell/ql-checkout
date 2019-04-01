(uiop/package:define-package :ql-checkout/project-quicklisp (:use :ql-checkout/meta-project :cl))
(in-package :ql-checkout/project-quicklisp)
;;;don't edit above

(defclass quicklisp (project) ())

(defun ensure-projectdata ()
  (clone-github "quicklisp/quicklisp-projects"))

(defmethod find-source ((project quicklisp) name)
  (declare (ignore project))
  (let* ((name (remove #\/ name))
         #+quicklisp
         (name (ql-dist:project-name (ql-dist:release (ql-dist:find-system name))))
         (dir (ensure-projectdata))
         (path (merge-pathnames (format nil "projects/~A/source.txt" name) dir)))
    (when (probe-file path)
      (uiop:read-file-line path))))

(defmethod update ((project quicklisp) &key)
  (format t "update ~A~%" "quicklisp/quicklisp-projects")
  (pull-github "quicklisp/quicklisp-projects"))

(register-project 'quicklisp)
