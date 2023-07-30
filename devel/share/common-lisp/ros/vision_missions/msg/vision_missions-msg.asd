
(cl:in-package :asdf)

(defsystem "vision_missions-msg"
  :depends-on (:roslisp-msg-protocol :roslisp-utils )
  :components ((:file "_package")
    (:file "center" :depends-on ("_package_center"))
    (:file "_package_center" :depends-on ("_package"))
  ))