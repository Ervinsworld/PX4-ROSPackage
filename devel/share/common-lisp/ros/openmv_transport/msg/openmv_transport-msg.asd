
(cl:in-package :asdf)

(defsystem "openmv_transport-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "Line" :depends-on ("_package_Line"))
    (:file "_package_Line" :depends-on ("_package"))
  ))