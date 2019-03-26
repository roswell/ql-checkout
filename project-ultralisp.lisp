(uiop/package:define-package :ql-checkout/project-ultralisp (:use :ql-checkout/meta-project :cl))
(in-package :ql-checkout/project-ultralisp)
;;;don't edit above

(defclass ultralisp (project) ())

(defun ensure-projectdata ()
  (clone-github "ultralisp/ultralisp-projects"))

(defmethod find-source ((project ultralisp) name)
  (declare (ignore project))
  (let ((name (remove #\/ (remove #\. name)))
        (dir (ensure-projectdata)))
    (mapcar (lambda (x)
              (let ((exp (uiop:safe-read-from-string x :package :keyword)))
                (when (and (eql (first exp) :github)
                           (equal (second (uiop:split-string (second exp) :separator '(#\/))) name))
                  (return-from find-source
                    (format nil "git https://github.com/~A.git" (second exp))))))
            (uiop:read-file-lines (merge-pathnames "projects.txt" dir)))))

(defmethod update ((project ultralisp) &key)
  (format t "update ~A~%" "ultralisp/ultralisp-projects")
  (pull-github "ultralisp/ultralisp-projects"))

;;(register-project 'ultralisp)
