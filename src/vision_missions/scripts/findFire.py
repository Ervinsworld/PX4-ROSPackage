#!/usr/bin/env python
# -*- coding: UTF-8 -*-

# mono8: CV_8UC1, grayscale image

# bgr8: CV_8UC3, color image with blue-green-red color order


import rospy
import numpy as np
import sys
import cv2
from sensor_msgs.msg import Image
from cv_bridge import CvBridge, CvBridgeError
import time
from simple_pid import PID
from vision_missions.msg import center

x_pid = PID(0, 0, 0, setpoint=0) 
y_pid = PID(0.5, 0, 0, setpoint=0)

class FireDetection():
    def __init__(self):
        self.node_name = "findFire"
        rospy.init_node(self.node_name)
        rospy.on_shutdown(self.cleanup)     #当ros关闭时对opencv进行清理
        self.bridge = CvBridge()
        self.center_value = False
        self.x_diff = 0
        self.y_diff = 0
        #订阅usb_cam发布的图像topic, 当得到数据类型为Image的图像时调用对于回调函数image_callback
        self.apron_sub = rospy.Subscriber("/csi_cam_0/image_raw", Image, self.image_callback)
        self.center_pub = rospy.Publisher("/center_diff_fire",center, queue_size=10) 
	    #每30ms执行一次show_img_cb，用于刷新显示窗口中的图像
        rospy.Timer(rospy.Duration(0.1), self.img_process)
        rospy.Timer(rospy.Duration(0.1), self.pid_turning)
        # rospy.Timer(rospy.Duration(0.03), self.show_img_cb)
    #图像处理函数
    def img_process(self, event2):
        try:
            img = self.frame
            img = cv2.flip(img, -1)
            #获取图像的高和宽
            height = img.shape[0]
            width = img.shape[1]
            start = time.time()
            grid_RGB = cv2.cvtColor(img, cv2.COLOR_BGR2RGB)

            # 从RGB色彩空间转换到HSV色彩空间
            grid_HSV = cv2.cvtColor(grid_RGB, cv2.COLOR_RGB2HSV)

            # H、S、V范围一：
            lower1 = np.array([0, 43, 200])
            upper1 = np.array([10, 255, 255])
            mask1 = cv2.inRange(grid_HSV, lower1, upper1)  # mask1 为二值图像
            res1 = cv2.bitwise_and(grid_RGB, grid_RGB, mask=mask1)

            # H、S、V范围二：
            lower2 = np.array([156, 43, 200])
            upper2 = np.array([180, 255, 255])
            mask2 = cv2.inRange(grid_HSV, lower2, upper2)
            res2 = cv2.bitwise_and(grid_RGB, grid_RGB, mask=mask2)

            # 将两个二值图像结果 相加
            mask3 = mask1 + mask2

            # 检测红色的边缘
            contours, hierarchy = cv2.findContours(mask3, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
            for cnt in contours:
                area = cv2.contourArea(cnt)
                # print(area)
                if area > 200:
                    cv2.drawContours(img, cnt, -1, (255, 0, 0), 3)
                    peri = cv2.arcLength(cnt, True)
                    # print(peri)
                    approx = cv2.approxPolyDP(cnt, 0.02 * peri, True)
                    # print(len(approx))
                    objCor = len(approx)
                    x, y, w, h = cv2.boundingRect(approx)
                    cv2.rectangle(img, (x, y), (x + w, y + h), (0, 255, 0), 2)
                    cv2.putText(img, "Fire",
                                (x + (w // 2) - 10, y + (h // 2) - 10), cv2.FONT_HERSHEY_COMPLEX, 0.7,
                                (0, 0, 0), 2)
                                
                    self.center_value = True
                    self.x_diff = x + w/2 - width/2
                    self.y_diff = y + h/2 - height/2
                else:
                    self.center_value = False
            # end = time.time()
            # print(end - start)
            cv2.namedWindow("Camera Image", cv2.WINDOW_NORMAL)
            cv2.imshow("Camera Image", img)
            cv2.waitKey(100)
            # self.apron_proced_pub.publish(self.bridge.cv2_to_imgmsg(img_flipped, "bgr8"))
        except:
            pass
    # 图像显示函数
    # def show_img_cb(self, event):
    #     try:
    #         cv2.namedWindow("Camera Image", cv2.WINDOW_NORMAL)
    #         cv2.imshow("Camera Image", self.frame)
    #         cv2.waitKey(3)
    #     except:
    #         pass

    # 回调函数
    def image_callback(self,ros_image):
        try:
            self.frame = self.bridge.imgmsg_to_cv2(ros_image, "bgr8")
            # frame_proced = self.img_process(frame)
        except CvBridgeError as e:
            print(e)
    
    def cleanup(self):
        cv2.destroyAllWindows()
    
    def pid_turning(self, event):
        #初始化center消息
        center_dif = center()
        try:
            center_dif.value = self.center_value
            center_dif.x = x_pid(self.x_diff)
            center_dif.y = y_pid(self.y_diff)
            self.center_pub.publish(center_dif)
        except:
            pass

def main(args):
    try:
        FireDetection()
        rospy.spin()
    except KeyboardInterrupt:
        cv2.destroyAllWindows()
if __name__ == '__main__':
    main(sys.argv)



