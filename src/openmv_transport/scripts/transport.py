#!/usr/bin/env python
# -*- coding: utf-8 -*-

import serial as ser
import rospy
from openmv_transport.msg import Line
from simple_pid import PID

rho_pid = PID(0.4, 0, 0, setpoint=0) 
theta_pid = PID(0.04, 0, 0, setpoint=0)

def velocity_publisher():
        # ROS节点初始化
    rospy.init_node('openmv_pub', anonymous=True)

        # 创建一个Publisher，发布名为/line_info的topic，消息类型为Line，队列长度10
    line_info_pub = rospy.Publisher('/line_info', Line, queue_size=10)

        #设置循环的频率
    rate = rospy.Rate(100)
    # 初始化Line类型的消息
    line_msg = Line()
    se = ser.Serial("/dev/ttyUSB0", 19200, timeout=1)
    line = se.readline()
    while not rospy.is_shutdown():
        line = se.readline()
        msg = line.encode("utf-8").strip()
        
        if msg == '':
            line_msg.rho_output = 0
            line_msg.theta_output = 0
            line_msg.value = False
            rospy.loginfo("Can't find a line!")
        else:
            list = msg.split(",")
            rho_raw = float(list[0])
            theta_raw = float(list[1])

            line_msg.rho_output = rho_pid(rho_raw)
            line_msg.theta_output = theta_pid(rho_raw)
            line_msg.value = True
                    # 发布消息

        line_info_pub.publish(line_msg)
        rospy.loginfo("Publish line output message[%f, %f]", line_msg.rho_output, line_msg.theta_output)
        # 按照循环频率延时
        #rate.sleep()
        se.flushOutput()

if __name__ == '__main__':
    try:
        velocity_publisher()
    except rospy.ROSInterruptException:
        pass

    

                                    
