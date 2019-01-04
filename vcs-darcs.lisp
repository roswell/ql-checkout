(uiop/package:define-package :ql-checkout/vcs-darcs (:use :cl :ql-checkout/vcs))
(in-package :ql-checkout/vcs-darcs)
;;;don't edit above

(defclass darcs (vcs) ())

(defmethod vcs-init ((vcs (eql 'darcs)) params name)
  (make-instance vcs :uri (first params) :name name))
(defmethod vcs-owner ((vcs darcs)) "darcs")
(register-vcs 'darcs)

(defmethod vcs-checkout ((vcs darcs) directory quiet)
  (let ((dir (vcs-dir vcs directory)))
    (unless quiet
      (format t "darcs clone ~A~%" dir))
    (ensure-directories-exist (uiop:pathname-parent-directory-pathname dir))
    (uiop:run-program (format nil "darcs clone ~A ~A"
                              (vcs-uri vcs)
                              (let ((name (namestring dir)))
                                (subseq name 0 (1- (length name))))))
    dir))
