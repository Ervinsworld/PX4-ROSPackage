# 2023年电赛无人机端ROS_Package
 1.技术方案：
 - 硬件：pixhawk + jetson nano + realsense_T265
 - 软件：ROS + mavros

 2.失误总结：
全局双目**视觉的缺陷**：无人机采用全局双目定位需要环境具有明显的特征点，而比赛场地的防护网无法提供特征点。
