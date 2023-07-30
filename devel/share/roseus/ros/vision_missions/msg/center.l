;; Auto-generated. Do not edit!


(when (boundp 'vision_missions::center)
  (if (not (find-package "VISION_MISSIONS"))
    (make-package "VISION_MISSIONS"))
  (shadow 'center (find-package "VISION_MISSIONS")))
(unless (find-package "VISION_MISSIONS::CENTER")
  (make-package "VISION_MISSIONS::CENTER"))

(in-package "ROS")
;;//! \htmlinclude center.msg.html


(defclass vision_missions::center
  :super ros::object
  :slots (_x _y _value ))

(defmethod vision_missions::center
  (:init
   (&key
    ((:x __x) 0.0)
    ((:y __y) 0.0)
    ((:value __value) nil)
    )
   (send-super :init)
   (setq _x (float __x))
   (setq _y (float __y))
   (setq _value __value)
   self)
  (:x
   (&optional __x)
   (if __x (setq _x __x)) _x)
  (:y
   (&optional __y)
   (if __y (setq _y __y)) _y)
  (:value
   (&optional __value)
   (if __value (setq _value __value)) _value)
  (:serialization-length
   ()
   (+
    ;; float32 _x
    4
    ;; float32 _y
    4
    ;; bool _value
    1
    ))
  (:serialize
   (&optional strm)
   (let ((s (if strm strm
              (make-string-output-stream (send self :serialization-length)))))
     ;; float32 _x
       (sys::poke _x (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; float32 _y
       (sys::poke _y (send s :buffer) (send s :count) :float) (incf (stream-count s) 4)
     ;; bool _value
       (if _value (write-byte -1 s) (write-byte 0 s))
     ;;
     (if (null strm) (get-output-stream-string s))))
  (:deserialize
   (buf &optional (ptr- 0))
   ;; float32 _x
     (setq _x (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; float32 _y
     (setq _y (sys::peek buf ptr- :float)) (incf ptr- 4)
   ;; bool _value
     (setq _value (not (= 0 (sys::peek buf ptr- :char)))) (incf ptr- 1)
   ;;
   self)
  )

(setf (get vision_missions::center :md5sum-) "8242b7d2c084ebc7b0621c9ba554c659")
(setf (get vision_missions::center :datatype-) "vision_missions/center")
(setf (get vision_missions::center :definition-)
      "float32 x
float32 y
bool value

")



(provide :vision_missions/center "8242b7d2c084ebc7b0621c9ba554c659")


