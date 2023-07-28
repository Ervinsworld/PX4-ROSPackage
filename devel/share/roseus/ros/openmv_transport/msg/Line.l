;; Auto-generated. Do not edit!


(when (boundp 'openmv_transport::Line)
  (if (not (find-package "OPENMV_TRANSPORT"))
    (make-package "OPENMV_TRANSPORT"))
  (shadow 'Line (find-package "OPENMV_TRANSPORT")))
(unless (find-package "OPENMV_TRANSPORT::LINE")
  (make-package "OPENMV_TRANSPORT::LINE"))

(in-package "ROS")
;;//! \htmlinclude Line.msg.html


(defclass openmv_transport::Line
  :super ros::object
  :slots (_rho_output _theta_output _value ))

(defmethod openmv_transport::Line
  (:init
   (&key
    ((:rho_output __rho_output) 0.0)
    ((:theta_output __theta_output) 0.0)
    ((:value __value) nil)
    )
   (send-super :init)
   (setq _rho_output (float __rho_output))
   (setq _theta_output (float __theta_output))
   (setq _value __value)
   self)
  (:rho_output
   (&optional __rho_output)
   (if __rho_output (setq _rho_output __rho_output)) _rho_output)
  (:theta_output
   (&optional __theta_output)
   (if __theta_output (setq _theta_output __theta_output)) _theta_output)
  (:value
   (&optional __value)
   (if __value (setq _value __value)) _value)
  (:serialization-length
   ()
   (+
    ;; float32 _rho_output
    4
    ;; float32 _theta_output
    4
    ;; bool _value
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _rho_output
       (sys::poke _rho_output (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _theta_output
       (sys::poke _theta_output (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; bool _value
       (if _value (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _rho_output
     (setq _rho_output (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _theta_output
     (setq _theta_output (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; bool _value
     (setq _value (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(setf (get openmv_transport::Line :md5sum-) "589598a53c23406a8280a9b28c65982e")
(setf (get openmv_transport::Line :datatype-) "openmv_transport/Line")
(setf (get openmv_transport::Line :definition-)
      "float32 rho_output
float32 theta_output
bool value

")



(provide :openmv_transport/Line "589598a53c23406a8280a9b28c65982e")


