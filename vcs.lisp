(uiop/package:define-package :ql-checkout/vcs (:use :cl :ql-checkout/meta-project)
  (:export :vcs :register-vcs :vcs-checkout :vcs-init :vcs-find :vcs-uri :vcs-owner :vcs-name :vcs-dir))
(in-package :ql-checkout/vcs)
;;;don't edit above

(defvar *vcs-init* '())

(defclass vcs ()
  ((uri
    :initarg :uri
    :accessor vcs-uri)
   (name
    :initarg :name
    :accessor vcs-name)))

(defmethod vcs-checkout (vcs directory quiet)
  (declare (ignore directory quiet))
  (error "not supported vcs for checkout ~S" vcs))

(defmethod vcs-init (symbol params name)
  (error "~S init fail." symbol))

(defmethod vcs-owner (vcs)
  (first (last (pathname-directory (vcs-uri vcs)))))

(defmethod vcs-dir (vcs base)
  (merge-pathnames
   (format nil "~A/~A/"
           (vcs-owner vcs)
           (vcs-name vcs))
   base))

(defun vcs-find (name)
  (loop for p in ql-checkout/meta-project::*projects*
        for line = (find-source p name)
        for split = (uiop:split-string line)
        do (when (>= (length split) 2)
             (let ((symbol (cdr (assoc (first split) *vcs-init* :test 'string-equal))))
               (if symbol
                   (let ((result (vcs-init symbol (rest split) name)))
                     (if (typep result 'vcs)
                         (return-from vcs-find result)
                         (error "something wrong with ~S ~S~%" result split)))
                   (error (format nil "~A is not supported" (first split))))))))

(defun register-vcs (symbol)
  (let ((name (string symbol)))
    (and (find-class symbol)
         ;; check the class is deriverd class?
         (setf *vcs-init* (acons name symbol (remove name *vcs-init* :test 'string-equal :key #'first))))))
