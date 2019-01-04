(uiop/package:define-package :ql-checkout/vcs-quicklisp (:use :cl :ql-checkout/vcs))
(in-package :ql-checkout/vcs-quicklisp)
;;;don't edit above

(defclass quicklisp (vcs) ())
(defclass single-file (quicklisp) ())
(defmethod vcs-owner ((vcs quicklisp)) "no-vcs")

(defmethod vcs-init ((vcs (eql 'single-file)) params name)
  (make-instance vcs :uri (first params) :name name))

(register-vcs 'single-file)

(defmethod vcs-checkout ((vcs quicklisp) directory quiet)
  (let ((dir (vcs-dir vcs directory)))
    (unless quiet
      (format t "extract from quicklisp ~A~%" dir))
    (ensure-directories-exist dir)
    #+quicklisp
    (let* ((release (ql-dist:find-release (vcs-name vcs)))
           (archive (ql-dist:ensure-local-archive-file release))
           (tar (ql:qmerge "tmp/release-install.tar"))
           (output dir))
      (ensure-directories-exist tar)
      (ensure-directories-exist output)
      (ql-gunzipper:gunzip archive tar)
      (ql-minitar:unpack-tarball tar :directory output))
    dir))