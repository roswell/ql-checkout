(uiop/package:define-package :ql-checkout/meta-project (:nicknames) (:use :ql-checkout/github :cl)
                             (:shadow) (:export :clone-github :project :register-project :find-source) (:intern))
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
