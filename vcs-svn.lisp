(uiop/package:define-package :ql-checkout/vcs-svn (:use :cl :ql-checkout/vcs))
(in-package :ql-checkout/vcs-svn)
;;;don't edit above

(defclass svn (vcs) ())

(defmethod vcs-init ((vcs (eql 'svn)) params)
  (make-instance vcs :uri (first params)))
(defmethod vcs-owner ((vcs svn)) "svn")
(defmethod vcs-name ((vcs svn))
  (let* ((uri (vcs-uri vcs))
         (name (pathname-name uri)))
    (if name
        (if (equal name "trunk")
            (first (last (pathname-directory uri)))
            name)
        (progn 
          (setf name (first (last (pathname-directory uri))))
          (if (equal name "trunk")
              (first (last (pathname-directory uri) 2))
              name)))))
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