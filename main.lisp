(uiop/package:define-package :ql-checkout/main (:nicknames :ql-checkout)
  (:use :cl :ql-checkout/config :ql-checkout/vcs)
  (:export :checkout))
(in-package :ql-checkout/main)
;;;don't edit above

(defun checkout (names &optional quiet)
  (loop for name in (or (and (listp names) names) (list names))
        for vcs = (vcs-find name)
        do (vcs-checkout vcs *checkoutdir* quiet)))
