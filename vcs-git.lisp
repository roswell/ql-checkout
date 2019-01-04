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
(defclass latest-github-tag (git) ())
(defclass kmr-git (git) ())
(defclass ediware-http (git) ())

(defmethod vcs-init ((vcs (eql 'git)) params name)
  (make-instance vcs :uri (first params) :name name))
(defmethod vcs-init ((vcs (eql 'branched-git)) params name)
  (make-instance vcs
                 :name name
                 :uri (first params)
                 :branch (second params)))
(defmethod vcs-init ((vcs (eql 'tagged-git)) params name)
  (make-instance vcs
                 :name name
                 :uri (first params)
                 :branch (second params)))
(defmethod vcs-init ((vcs (eql 'latest-github-release)) params name)
  (make-instance vcs :uri (first params) :name name))
(defmethod vcs-init ((vcs (eql 'latest-github-tag)) params name)
  (make-instance vcs :uri (first params) :name name))
(defmethod vcs-init ((vcs (eql 'kmr-git)) params name)
  (make-instance vcs :uri (format nil "http://git.kpe.io/~A.git" (first params)) :name name))
(defmethod vcs-owner ((vcs kmr-git)) "kmr")
(defmethod vcs-init ((vcs (eql 'ediware-http)) params name)
  (make-instance vcs :uri (format nil "https://github.com/edicl/~A.git" (first params)) :name name))

(register-vcs 'git)
(register-vcs 'branched-git)
(register-vcs 'tagged-git)
(register-vcs 'latest-github-release)
(register-vcs 'latest-github-tag)
(register-vcs 'kmr-git)
(register-vcs 'ediware-http)

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
