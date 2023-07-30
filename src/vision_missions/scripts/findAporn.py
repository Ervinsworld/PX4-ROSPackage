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

x_pid = PID(0.04, 0, 0, setpoint=0) 
y_pid = PID(0.04, 0, 0, setpoint=0)

class ApronDetection():
    def __init__(self):
        self.node_name = "Apron"
        rospy.init_node(self.node_name)
        rospy.on_shutdown(self.cleanup)     #当ros关闭时对opencv进行清理
        self.bridge = CvBridge()
        self.center_value = False
        self.x_diff = 0
        self.y_diff = 0
        #订阅usb_cam发布的图像topic, 当得到数据类型为Image的图像时调用对于回调函数image_callback
        self.apron_sub = rospy.Subscriber("/csi_cam_0/image_raw", Image, self.image_callback)
        self.center_pub = rospy.Publisher("/center_diff",center, queue_size=10) 
	    #每30ms执行一次show_img_cb，用于刷新显示窗口中的图像
        rospy.Timer(rospy.Duration(0.1), self.img_process)
        rospy.Timer(rospy.Duration(0.1), self.pid_turning)
        # rospy.Timer(rospy.Duration(0.03), self.show_img_cb)
    #图像处理函数
    def img_process(self, event2):
        try:
            img = self.frame
            # start = time.time()
            img_flipped = cv2.flip(img, -1)
            #获取图像的高和宽
            height = img_flipped.shape[0]
            width = img_flipped.shape[1]
            img_grey = cv2.cvtColor(img_flipped, cv2.COLOR_BGR2GRAY)
            k = np.ones((31, 31), np.uint8)
            # 腐蚀操作， 防止边缘检测失败
            img_erode = cv2.erode(img_grey, k)
            blur = cv2.GaussianBlur(img_erode, (5, 5), 0)
            ret, img_otsu = cv2.threshold(blur, 0, 255, cv2.THRESH_BINARY + cv2.THRESH_OTSU)
            # 二值反转
            img_verse = cv2.bitwise_not(img_otsu)
            # # 图像边缘检测
            contours, hierarchy = cv2.findContours(img_verse, cv2.RETR_EXTERNAL, cv2.CHAIN_APPROX_SIMPLE)
            for cnt in contours:
                area = cv2.contourArea(cnt)
                # print(area)
                if area > 10000:
                    cv2.drawContours(img_flipped, cnt, -1, (255, 0, 0), 3)
                    peri = cv2.arcLength(cnt, True)
                    # print(peri)
                    approx = cv2.approxPolyDP(cnt, 0.02 * peri, True)
                    #print(len(approx))
                    objCor = len(approx)
                    x, y, w, h = cv2.boundingRect(approx)

                    # if objCor == 3:
                    #     objectType = "Tri"
                    # elif objCor == 4:
                    #     aspRatio = w / float(h)
                    #     if aspRatio > 0.98 and aspRatio < 1.03:
                    #         objectType = "Square"
                    #     else:
                    #         objectType = "Rectangle"
                    # elif objCor > 4:
                    #     objectType = "Circles"
                    # else:
                    #     objectType = "None"
                    if objCor > 6:
                        objectType = "Circles"
                        cv2.rectangle(img_flipped, (x, y), (x + w, y + h), (0, 255, 0), 2)
                        cv2.circle(img_flipped, (x + w//2, y + h//2), 1, (0, 0, 255), 4) #绘制圆心
                        cv2.putText(img_flipped, objectType,
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
            cv2.imshow("Camera Image", img_flipped)
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
        ApronDetection()
        rospy.spin()
    except KeyboardInterrupt:
        cv2.destroyAllWindows()
if __name__ == '__main__':
    main(sys.argv)



