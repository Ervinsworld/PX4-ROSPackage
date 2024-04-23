# 2023年电赛无人机ROS_Package
![image](https://github.com/Ervinsworld/PX4-ROSPackage/blob/master/pic.jpg)
> 飞行视频：[视频](https://www.bilibili.com/video/BV1Cj411B762/?spm_id_from=333.999.0.0&vd_source=63b77a3cb11fa22eb55ce223594a91b7)
### 1.技术方案：
 - 硬件方案：pixhawk + jetson nano + realsense_T265
 - 软件方案：ROS + mavros

### 2.目录结构
- src/command-center: 起飞、降落、航点规划和运动控制package
- src/openmv_transport: openmv和jetson nano的串口通讯包（预备方案，以防jetson nano算力不足）
- src/vision_mission: 使用jetson nano的csi摄像头, 基于opencv库对火点，起飞降落点进行识别的包
- src/missions: launch file目录
  
### 3.失误总结：
全局双目**视觉的缺陷**：无人机采用全局双目定位需要环境具有明显的特征点，而比赛场地的防护网无法提供特征点。
