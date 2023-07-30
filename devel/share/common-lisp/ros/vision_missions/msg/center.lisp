; Auto-generated. Do not edit!


(cl:in-package vision_missions-msg)


;//! \htmlinclude center.msg.html

(cl:defclass <center> (roslisp-msg-protocol:ros-message)
  ((x
    :reader x
    :initarg :x
    :type cl:float
    :initform 0.0)
   (y
    :reader y
    :initarg :y
    :type cl:float
    :initform 0.0)
   (value
    :reader value
    :initarg :value
    :type cl:boolean
    :initform cl:nil))
)

(cl:defclass center (<center>)
  ())

(cl:defmethod cl:initialize-instance :after ((m <center>) cl:&rest args)
  (cl:declare (cl:ignorable args))
  (cl:unless (cl:typep m 'center)
    (roslisp-msg-protocol:msg-deprecation-warning "using old message class name vision_missions-msg:<center> is deprecated: use vision_missions-msg:center instead.")))

(cl:ensure-generic-function 'x-val :lambda-list '(m))
(cl:defmethod x-val ((m <center>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader vision_missions-msg:x-val is deprecated.  Use vision_missions-msg:x instead.")
  (x m))

(cl:ensure-generic-function 'y-val :lambda-list '(m))
(cl:defmethod y-val ((m <center>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader vision_missions-msg:y-val is deprecated.  Use vision_missions-msg:y instead.")
  (y m))

(cl:ensure-generic-function 'value-val :lambda-list '(m))
(cl:defmethod value-val ((m <center>))
  (roslisp-msg-protocol:msg-deprecation-warning "Using old-style slot reader vision_missions-msg:value-val is deprecated.  Use vision_missions-msg:value instead.")
  (value m))
(cl:defmethod roslisp-msg-protocol:serialize ((msg <center>) ostream)
  "Serializes a message object of type '<center>"
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'x))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:let ((bits (roslisp-utils:encode-single-float-bits (cl:slot-value msg 'y))))
    (cl:write-byte (cl:ldb (cl:byte 8 0) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 8) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 16) bits) ostream)
    (cl:write-byte (cl:ldb (cl:byte 8 24) bits) ostream))
  (cl:write-byte (cl:ldb (cl:byte 8 0) (cl:if (cl:slot-value msg 'value) 1 0)) ostream)
)
(cl:defmethod roslisp-msg-protocol:deserialize ((msg <center>) istream)
  "Deserializes a message object of type '<center>"
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'x) (roslisp-utils:decode-single-float-bits bits)))
    (cl:let ((bits 0))
      (cl:setf (cl:ldb (cl:byte 8 0) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 8) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 16) bits) (cl:read-byte istream))
      (cl:setf (cl:ldb (cl:byte 8 24) bits) (cl:read-byte istream))
    (cl:setf (cl:slot-value msg 'y) (roslisp-utils:decode-single-float-bits bits)))
    (cl:setf (cl:slot-value msg 'value) (cl:not (cl:zerop (cl:read-byte istream))))
  msg
)
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql '<center>)))
  "Returns string type for a message object of type '<center>"
  "vision_missions/center")
(cl:defmethod roslisp-msg-protocol:ros-datatype ((msg (cl:eql 'center)))
  "Returns string type for a message object of type 'center"
  "vision_missions/center")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql '<center>)))
  "Returns md5sum for a message object of type '<center>"
  "8242b7d2c084ebc7b0621c9ba554c659")
(cl:defmethod roslisp-msg-protocol:md5sum ((type (cl:eql 'center)))
  "Returns md5sum for a message object of type 'center"
  "8242b7d2c084ebc7b0621c9ba554c659")
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql '<center>)))
  "Returns full string definition for message of type '<center>"
  (cl:format cl:nil "float32 x~%float32 y~%bool value~%~%~%"))
(cl:defmethod roslisp-msg-protocol:message-definition ((type (cl:eql 'center)))
  "Returns full string definition for message of type 'center"
  (cl:format cl:nil "float32 x~%float32 y~%bool value~%~%~%"))
(cl:defmethod roslisp-msg-protocol:serialization-length ((msg <center>))
  (cl:+ 0
     4
     4
     1
))
(cl:defmethod roslisp-msg-protocol:ros-message-to-list ((msg <center>))
  "Converts a ROS message object to a list"
  (cl:list 'center
    (cl:cons ':x (x msg))
    (cl:cons ':y (y msg))
    (cl:cons ':value (value msg))
))
