(uiop/package:define-package :ql-checkout/main (:nicknames :ql-checkout)
  (:use :cl :ql-checkout/config :ql-checkout/vcs :ql-checkout/meta-project)
  (:export :checkout :update))
(in-package :ql-checkout/main)
;;;don't edit above

(defun checkout (names &optional quiet)
  (loop for name in (if (listp names)
                        names
                        (list names))
        for vcs = (vcs-find name)
        do (if vcs
               (vcs-checkout vcs *checkoutdir* quiet)
               (unless quiet
                 (format t "~A not found.~%" name)))))
