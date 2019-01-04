(uiop/package:define-package :ql-checkout/vcs-mercurial (:use :cl :ql-checkout/vcs))
(in-package :ql-checkout/vcs-mercurial)
;;;don't edit above

(defclass mercurial (vcs) ())

(defmethod vcs-init ((vcs (eql 'mercurial)) params name)
  (make-instance vcs :uri (first params) :name name))
(register-vcs 'mercurial)

(defmethod vcs-checkout ((vcs mercurial) directory quiet)
  (let ((dir (vcs-dir vcs directory)))
    (unless quiet
      (format t "hg clone ~A~%" dir))
    (uiop:run-program (format nil "hg clone ~A ~A"
                              (vcs-uri vcs)
                              (namestring
                               (ensure-directories-exist dir))))
    dir))