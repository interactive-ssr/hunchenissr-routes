(defpackage hunchenissr-routes-asd
  (:use #:cl #:asdf))
(in-package #:hunchenissr-routes-asd)

(defsystem hunchenissr-routes
  :description "Better routes to be used with Hunchenissr."
  :author "Charles Jackson <charles.b.jackson@protonmail.com>"
  :license "LLGPL"
  :version "0"
  :serial t
  :depends-on (#:hunchenissr
               #:defrest)
  :components ((:file "package")
               (:file "hunchenissr-routes")))
