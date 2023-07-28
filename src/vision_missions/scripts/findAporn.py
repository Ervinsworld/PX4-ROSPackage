#!/usr/bin/env python
# -*- coding: UTF-8 -*-

import rospy
import sys
import cv2
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError

class ApronDetection():
    def __init__(self):
        self.node_name = "Apron"
        rospy.init_node(self.node_name)
        rospy.on_shutdown(self.cleanup)     #当ros关闭时对opencv进行清理
        self.bridge = CvBridge()
        #订阅usb_cam发布的图像topic, 当得到数据类型为Image的图像时调用对于回调函数image_callback
        self.apron_sub = rospy.Subscriber("/csi_cam_0/image_raw", Image, self.image_callback)
        self.apron_proced_pub = rospy.Publisher("apron_detection",Image, queue_size=10) 
	    #每30ms执行一次show_img_cb，用于刷新显示窗口中的图像
        rospy.Timer(rospy.Duration(0.03), self.show_img_cb) 
        rospy.Timer(rospy.Duration(0.03), self.img_process)
    #图像处理函数
    def img_process(self, event2):
        try:
            image = self.frame
            gray = cv2.cvtColor(image, cv2.COLOR_BGR2GRAY)
            gray = cv2.medianBlur(gray, 3)
            circles = cv2.HoughCircles(gray, cv2.HOUGH_GRADIENT, 1, 1000, param1=100, param2=30, minRadius=0, maxRadius=0)
            if circles is None:
                rospy.loginfo("No circles Found")
            else:
                for i in circles[0, :]:
                    cv2.circle(image, (int(i[0]), int(i[1])), int(i[2]), (0, 0, 255), 2)  # 画圆
                    cv2.circle(image, (int(i[0]), int(i[1])), 2, (0, 0, 255), 2)  # 画圆心
                self.apron_proced_pub.publish(self.bridge.cv2_to_imgmsg(image, "bgr8"))
        except:
            pass
    # 图像显示函数
    def show_img_cb(self, event):
        try:
            cv2.namedWindow("Camera Image", cv2.WINDOW_NORMAL)
            cv2.imshow("Camera Image", self.frame)
            cv2.waitKey(3)
        except:
            pass

    # 回调函数
    def image_callback(self,ros_image):
        try:
            self.frame = self.bridge.imgmsg_to_cv2(ros_image, "bgr8")
            # frame_proced = self.img_process(frame)
            # 

        except CvBridgeError as e:
            print(e)
    
    def cleanup(self):
        cv2.destroyAllWindows()
    

def main(args):
    try:
        ApronDetection()
        rospy.spin()
    except KeyboardInterrupt:
        cv2.destroyAllWindows()
if __name__ == '__main__':
    main(sys.argv)



