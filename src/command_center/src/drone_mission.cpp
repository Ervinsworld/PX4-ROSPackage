#include <ros/ros.h>
#include <geometry_msgs/PoseStamped.h>
#include <mavros_msgs/CommandBool.h>
#include <mavros_msgs/State.h>
#include <nav_msgs/Odometry.h>
#include <mavros_msgs/SetMode.h>
#include <mavros_msgs/PositionTarget.h>
#include <sensor_msgs/Range.h>
#include <mavros_msgs/Thrust.h>
#include <cmath>

const int N = 100;//航点最大数

const double TRAVEL_H = 1.8;
const double MISSION_H = 1.5;

mavros_msgs::State current_state;
void state_cb(const mavros_msgs::State::ConstPtr& msg){
    current_state = *msg;
}

nav_msgs::Odometry current_Odom;
double cur_x, cur_y;
double start_x, start_y, start_z;

void odom_cb(const nav_msgs::Odometry::ConstPtr& Odom){
    current_Odom = *Odom;
    cur_x = current_Odom.pose.pose.position.x;
    cur_y = current_Odom.pose.pose.position.y;
    //cur_z = current_Odom.pose.pose.position.z;
    //ROS_INFO_STREAM("odom INFO x:"<<cur_x<<"  y:"<<cur_y);
}

sensor_msgs::Range current_range;
double cur_z;
void range_cb(const sensor_msgs::Range::ConstPtr& range){
    current_range = *range;
    cur_z = current_range.range;
    ROS_INFO_STREAM("Range INFO:"<<cur_z);
}

//用来判断理想值和实际值是否符合range
bool pose_match(double exp, double cur, double range){
    if(fabs(exp-cur)>range)
        return false;
    else
        return true;
}


int main(int argc, char **argv)
{
    ros::init(argc, argv, "drone_mission");
    ros::NodeHandle nh;

    ros::Subscriber state_sub = nh.subscribe<mavros_msgs::State>
            ("mavros/state", 10, state_cb);

    ros::Subscriber odom_sub = nh.subscribe<nav_msgs::Odometry>
            ("mavros/local_position/odom", 25, odom_cb);

    ros::Subscriber range_sub = nh.subscribe<sensor_msgs::Range>
            ("/mavros/distance_sensor/hrlv_ez4_pub", 25, range_cb);

    ros::Publisher local_pos_pub = nh.advertise<mavros_msgs::PositionTarget>
            ("mavros/setpoint_raw/local", 10);

    ros::Publisher thrust_pub = nh.advertise<mavros_msgs::Thrust>
            ("mavros/setpoint_attitude/thrust", 10);

    ros::ServiceClient arming_client = nh.serviceClient<mavros_msgs::CommandBool>
            ("mavros/cmd/arming");

    ros::ServiceClient set_mode_client = nh.serviceClient<mavros_msgs::SetMode>
            ("mavros/set_mode");


    


    //the setpoint publishing rate MUST be faster than 2Hz
    ros::Rate rate(100.0);

    // wait for FCU connection
    while(ros::ok() && !current_state.connected){
        ros::spinOnce();
        rate.sleep();
    }

    //让位置信息开始接收
    for(int i = 100; ros::ok() && i > 0; --i){
        ros::spinOnce();
        rate.sleep();
    }

    //记录起点的坐标
    start_x = cur_x;
    start_y = cur_y;
    start_z = cur_z;
    ROS_INFO_STREAM("Home point refreshed!");
    //航点数(包含起点和终点)
    int flightPoint_num = 13;
    //用来记录当前执行到哪一个航点
    int current_flightPoint = 0;

    //来记录路径规划的抽象点格坐标，左下角为(1, 1), 右上角为(6, 5),不包含起点和终点!!!
    double Flight_point[N-2][2] = {{1, 5}, {2, 5}, {2, 2}, {3, 2}, {3, 5}, {4, 5}, {4, 2}, {5, 2}, {5, 5}, {6, 5}, {6, 1}};

    //飞行航点位置数组集合,每一行依次存放x, y, z坐标
    double Flight_list[N][3] = {};

    //按照Flight_point导入Flight_list
    Flight_list[0][0] = start_x;
    Flight_list[0][1] = start_y;
    Flight_list[0][2] = TRAVEL_H;
    Flight_list[flightPoint_num-1][0] = start_x;
    Flight_list[flightPoint_num-1][1] = start_y;
    Flight_list[flightPoint_num-1][2] = TRAVEL_H;
    for(int i=0; i<flightPoint_num-2; i++){
        Flight_list[i+1][0] = start_x + (Flight_point[i][1]-1)*0.75 + 0.05;
        Flight_list[i+1][1] = start_y - (Flight_point[i][0]-1)*0.75 - 0.05;
        Flight_list[i+1][2] = TRAVEL_H;
    }

    // Flight_list[0][0] = start_x;
    // Flight_list[0][1] = start_y;
    // Flight_list[0][2] = TRAVEL_H;
    // Flight_list[flightPoint_num-1][0] = start_x;
    // Flight_list[flightPoint_num-1][1] = start_y;
    // Flight_list[flightPoint_num-1][2] = TRAVEL_H;
    // for(int i=0; i<flightPoint_num-2; i++){
    //     Flight_list[i+1][0] = start_x + (Flight_point[i][1]-1)*0.8;
    //     Flight_list[i+1][1] = start_y - (Flight_point[i][0]-1)*0.8;
    //     Flight_list[i+1][2] = TRAVEL_H;
    // }

    //输出Flight_list的实际参数用来调试
    for(int i=0; i<flightPoint_num; i++){
         ROS_INFO_STREAM("POINT INFO:"<<Flight_list[i][0]<<"  "<<Flight_list[i][1]<<" "<<Flight_list[i][2]);
    }

    mavros_msgs::PositionTarget PoseCommand;
    PoseCommand.header.stamp=ros::Time::now();
    PoseCommand.coordinate_frame = 1;
    PoseCommand.type_mask = 0b101111111000;
    PoseCommand.position.x = Flight_list[0][0];
    PoseCommand.position.y = Flight_list[0][1];
    PoseCommand.position.z = Flight_list[0][2];
    PoseCommand.yaw = 0;

    //send a few setpoints before starting
    for(int i = 100; ros::ok() && i > 0; --i){
        local_pos_pub.publish(PoseCommand);
        ros::spinOnce();
        rate.sleep();
    }



    //解锁对象实例化
    mavros_msgs::CommandBool arm_cmd, disarm_cmd;
    arm_cmd.request.value = true;
    disarm_cmd.request.value = false;

    //设置时间延迟戳
    ros::Time last_request = ros::Time::now();
    //设置降落标志
    bool land_cmd_sent = false;

     //设置油门值
    mavros_msgs::Thrust th;
    th.thrust = 0;

    //是否降落标识
    bool land_flag = false;

    //主循环
    while(ros::ok()){
        //解锁命令
        if(current_state.mode == "OFFBOARD"){
            if( !current_state.armed &&
                (ros::Time::now() - last_request > ros::Duration(2.0))){
                if( arming_client.call(arm_cmd) &&
                    arm_cmd.response.success){
                    ROS_INFO("Vehicle armed");
                }
                last_request = ros::Time::now();
            }
        }


        //pose控制发布命令
        local_pos_pub.publish(PoseCommand);

        //航点控制逻辑
        if(pose_match(Flight_list[current_flightPoint][0], cur_x, 0.05)&&
           pose_match(Flight_list[current_flightPoint][1], cur_y, 0.05)&&
           pose_match(Flight_list[current_flightPoint][2], cur_z, 0.05)&&flightPoint_num != current_flightPoint){
            //当前航点数加一

            current_flightPoint++;
            //发布下一个航点命令
            PoseCommand.position.x = Flight_list[current_flightPoint][0];
            PoseCommand.position.y = Flight_list[current_flightPoint][1];
            PoseCommand.position.z = Flight_list[current_flightPoint][2];
            ROS_INFO_STREAM("FlightPoint INFO:"<<current_flightPoint);
            last_request = ros::Time::now();
           }

        //降落命令
        if((flightPoint_num == current_flightPoint)&&!land_flag){
            PoseCommand.type_mask = 0b101111000111;
            PoseCommand.velocity.x = 0;
            PoseCommand.velocity.y = 0;
            PoseCommand.velocity.z = -0.3;
            PoseCommand.yaw = 0;
            land_flag = true;
            last_request = ros::Time::now();
        }
        if(land_flag){
           if((ros::Time::now() - last_request > ros::Duration(6.0))){
                //将所有值归0
                PoseCommand.type_mask = 0b111111111111;
                local_pos_pub.publish(PoseCommand);
                //循环直到成功上锁
                do{
                    arming_client.call(disarm_cmd);
                    ros::spinOnce();
                    rate.sleep();
                }while(!disarm_cmd.response.success);
                  
                ROS_INFO("Vehicle disarmed! Mission end!");
                return 0;
            }
        }
        ros::spinOnce();
        rate.sleep();
    }
    return 0;
}

