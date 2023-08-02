//用来测试降落接口
//mavros/cmd/land包含经度纬度数据，应该适用于gps，故舍弃
#include <ros/ros.h>
#include <geometry_msgs/PoseStamped.h>
#include <mavros_msgs/CommandBool.h>
#include <mavros_msgs/SetMode.h>
#include <mavros_msgs/State.h>
#include <nav_msgs/Odometry.h>
#include <mavros_msgs/PositionTarget.h>
#include "vision_missions/center.h"

mavros_msgs::State current_state;
void state_cb(const mavros_msgs::State::ConstPtr& msg){
    current_state = *msg;
}

nav_msgs::Odometry current_Odom;
double cur_x, cur_y, cur_z;

void odom_cb(const nav_msgs::Odometry::ConstPtr& Odom){
    current_Odom = *Odom;
    cur_x = current_Odom.pose.pose.position.x;
    cur_y = current_Odom.pose.pose.position.y;
    cur_z = current_Odom.pose.pose.position.z;
    //ROS_INFO_STREAM("odom INFO x:"<<cur_x<<"  y:"<<cur_y<<"  z:"<<cur_z);
}

vision_missions::center current_center;
double x_dif, y_dif, cen_value;

void center_cb(const vision_missions::center::ConstPtr& center){
    current_center = *center;
    x_dif = current_center.x/500;
    y_dif = current_center.y/500;
    cen_value = current_center.value;
    ROS_INFO_STREAM("center INFO x:"<<x_dif<<"  y:"<<y_dif<<"  value:"<<cen_value);
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
    ros::init(argc, argv, "land_tester");
    ros::NodeHandle nh;

    ros::Subscriber state_sub = nh.subscribe<mavros_msgs::State>
            ("mavros/state", 10, state_cb);

    ros::Subscriber odom_sub = nh.subscribe<nav_msgs::Odometry>
            ("mavros/local_position/odom", 10, odom_cb);

    ros::Subscriber center_sub = nh.subscribe<vision_missions::center>
            ("/center_diff", 10, center_cb);

    ros::Publisher local_pos_pub = nh.advertise<mavros_msgs::PositionTarget>
            ("mavros/setpoint_raw/local", 10);

    ros::ServiceClient arming_client = nh.serviceClient<mavros_msgs::CommandBool>
            ("mavros/cmd/arming");

    ros::ServiceClient set_mode_client = nh.serviceClient<mavros_msgs::SetMode>
            ("mavros/set_mode");

    //the setpoint publishing rate MUST be faster than 2Hz
    ros::Rate rate(20.0);

    // wait for FCU connection
    while(ros::ok() && !current_state.connected){
        ros::spinOnce();
        rate.sleep();
    }

    mavros_msgs::PositionTarget PoseCommand;
    PoseCommand.header.stamp=ros::Time::now();
    PoseCommand.coordinate_frame = 1;
    PoseCommand.type_mask = 0b101111111000;
    PoseCommand.position.x = 0;
    PoseCommand.position.y = 0;
    PoseCommand.position.z = 1.5;
    PoseCommand.yaw = 0;

    //send a few setpoints before starting
    for(int i = 100; ros::ok() && i > 0; --i){
        local_pos_pub.publish(PoseCommand);
        ros::spinOnce();
        rate.sleep();
    }

    mavros_msgs::SetMode offb_set_mode;
    offb_set_mode.request.custom_mode = "OFFBOARD";

    mavros_msgs::CommandBool arm_cmd, disarm_cmd;
    arm_cmd.request.value = true;
    disarm_cmd.request.value = false;

    bool land_flag = false;

    ros::Time last_request = ros::Time::now();

    while(ros::ok()){
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

        local_pos_pub.publish(PoseCommand);
        if(pose_match(1.5, cur_z, 0.05)){
            PoseCommand.type_mask = 0b101111011100;
            //PoseCommand.position.z = 0;
            PoseCommand.velocity.z = -0.1;
            PoseCommand.yaw = 0;
            land_flag = true;
        }

        //降落到0.8米高度处开始pid校准
        if(land_flag){
            if(pose_match(0.8, cur_z, 0.05)){   
                //进入pid循环
                ros::Time pid_time = ros::Time::now();
                PoseCommand.type_mask = 0b101111100011;
                PoseCommand.position.z = 0.8;
                PoseCommand.yaw = 0;
                do{
                    local_pos_pub.publish(PoseCommand);
                    PoseCommand.velocity.x = y_dif;
                    PoseCommand.velocity.y = x_dif;
                    ros::spinOnce();
                    rate.sleep();
                }while(ros::Time::now()-pid_time < ros::Duration(10.0));
                //pid调整成功，进入降落稳定模式
                ros::Time pid_end = ros::Time::now();
                PoseCommand.type_mask = 0b101111011100;
                PoseCommand.position.x = cur_x;
                PoseCommand.position.y = cur_y;
                PoseCommand.velocity.z = -0.3;
                PoseCommand.yaw = 0;
                do{
                    local_pos_pub.publish(PoseCommand);
                    ros::spinOnce();
                    rate.sleep();
                }while(ros::Time::now()-pid_end < ros::Duration(3.0));
                PoseCommand.type_mask = 0b111111111111;
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
