;;don't edit
(DEFSYSTEM "ql-checkout" :LICENSE "mit" :CLASS :PACKAGE-INFERRED-SYSTEM
 :COMPONENTS
 ((:FILE "config") (:FILE "github") (:FILE "meta-project") (:FILE "vcs")
  (:FILE "project-quicklisp") (:FILE "project-ultralisp")
  (:FILE "vcs-quicklisp") (:FILE "vcs-git") (:FILE "vcs-svn")
  (:FILE "vcs-mercurial") (:FILE "vcs-darcs") (:FILE "main"))
 :DESCRIPTION
 "ql-checkout is library intend to checkout quicklisp maintained library with vcs."
 :AUTHOR "SANO Masatoshi" :MAILTO "snmsts@gmail.com")
