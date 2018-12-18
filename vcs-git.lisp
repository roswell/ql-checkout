(uiop/package:define-package :ql-checkout/vcs-git (:use :cl :ql-checkout/vcs))
(in-package :ql-checkout/vcs-git)
;;;don't edit above

(defclass git (vcs)
  ((branch
    :initarg :branch
    :initform nil
    :accessor git-branch)))
(defclass branched-git (git) ())
(defclass tagged-git (git) ())
(defclass latest-github-release (git) ())
(defclass kmr-git (git) ())

(defmethod vcs-init ((vcs (eql 'git)) params)
  (make-instance vcs :uri (first params)))
(defmethod vcs-init ((vcs (eql 'branched-git)) params)
  (make-instance vcs
                 :uri (first params)
                 :branch (second params)))
(defmethod vcs-init ((vcs (eql 'tagged-git)) params)
  (make-instance vcs
                 :uri (first params)
                 :branch (second params)))
(defmethod vcs-init ((vcs (eql 'latest-github-release)) params)
  (make-instance vcs :uri (first params)))
(defmethod vcs-init ((vcs (eql 'kmr-git)) params)
  (make-instance vcs :uri (format nil "http://git.kpe.io/~A.git" (first params))))
(defmethod vcs-owner ((vcs kmr-git)) "kmr")

(register-vcs 'git)
(register-vcs 'branched-git)
(register-vcs 'tagged-git)
(register-vcs 'latest-github-release)
(register-vcs 'kmr-git)

(defmethod vcs-checkout ((vcs git) directory quiet)
  (let ((dir (vcs-dir vcs directory)))
    (unless quiet
      (format t "git clone ~{~A~} ~A~%"
              (list (if (git-branch vcs)
                        (format nil"-b ~A" (git-branch vcs))
                        ""))
              dir))
    (uiop:run-program (format nil "git clone ~{~A~} ~A ~A"
                              (list (if (git-branch vcs)
                                        (format nil"-b ~A" (git-branch vcs))
                                        ""))
                              (vcs-uri vcs)
                              (namestring
                               (ensure-directories-exist 
                                dir))))
    dir))
