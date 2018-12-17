(uiop/package:define-package :ql-checkout/config (:use :cl) (:export :*checkoutdir*))
(in-package :ql-checkout/config)
;;;don't edit above

(defvar *checkoutdir*
  (or #+quicklisp (first ql:*local-project-directories*)
      (merge-pathnames "common-lisp/" (user-homedir-pathname))))
