(uiop/package:define-package :ql-checkout/meta-project (:nicknames) (:use :ql-checkout/github :cl)
                             (:shadow) (:export :clone-github :pull-github :project :project-name :register-project :find-source :update) (:intern))
(in-package :ql-checkout/meta-project)
;;don't edit above

(defclass project () ())

(defmethod find-source ((project project) name)
  (declare (ignore name))
  (error "not supported project ~S" project))

(defvar *projects* ())

(defun register-project (name)
  (unless (find-if (lambda (x) (typep x name)) *projects*)
    (push (make-instance name) *projects*)))

(defmethod update ((project project) &key)
  (error "not supported project ~S" project))

(defmethod update ((project (eql :all)) &key)
  (loop for i in *projects*
        do (update i)))

(defmethod update ((project list) &key)
  (loop for i in project
        do (update i)))

(defmethod update ((project string) &key)
  (let ((found (find project *projects*
                     :test #'equalp
                     :key (lambda (x) (string (type-of x))))))
    (when found
      (update found))))
