(uiop/package:define-package :ql-checkout/vcs-svn (:use :cl :ql-checkout/vcs))
(in-package :ql-checkout/vcs-svn)
;;;don't edit above

(defclass svn (vcs) ())

(defmethod vcs-init ((vcs (eql 'svn)) params name)
   (make-instance vcs :uri (first params) :name name))
(defmethod vcs-owner ((vcs svn)) "svn")

(register-vcs 'svn)

(defmethod vcs-checkout ((vcs svn) directory quiet)
  (let ((dir (vcs-dir vcs directory)))
    (unless quiet
      (format t "svn checkout ~A~%" dir))
    (uiop:run-program (format nil "svn checkout ~A ~A"
                              (vcs-uri vcs)
                              (namestring
                               (ensure-directories-exist dir))))
    dir))