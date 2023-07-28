//通过底层控制的mavros/setpoint_raw/local话题发布控制命令
#define PI acos(-1)

#include <ros/ros.h>
#include <geometry_msgs/PoseStamped.h>
#include <mavros_msgs/CommandBool.h>
#include <mavros_msgs/SetMode.h>
#include <mavros_msgs/State.h>
#include <nav_msgs/Odometry.h>
#include <mavros_msgs/PositionTarget.h>
#include <math.h>
#include "openmv_transport/Line.h"


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

openmv_transport::Line line;
double rho, theta, line_value;

void line_cb(const openmv_transport::Line::ConstPtr& line_finder){
    line = *line_finder;
    rho = line.rho_output;
    theta = line.theta_output;
    line_value = line.value;
    ROS_INFO_STREAM("Value is "<<line_value<<"  rho:"<<rho<<"  theta:"<<theta);
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
    ros::init(argc, argv, "line_tracker");
    ros::NodeHandle nh;

    ros::Subscriber state_sub = nh.subscribe<mavros_msgs::State>
            ("mavros/state", 10, state_cb);

    ros::Subscriber odom_sub = nh.subscribe<nav_msgs::Odometry>
            ("mavros/local_position/odom", 10, odom_cb);

    ros::Subscriber line_sub = nh.subscribe<openmv_transport::Line>
            ("/line_info", 10, line_cb);

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
    PoseCommand.position.z = 0.5;
    PoseCommand.yaw = 0;

    //send a few setpoints before starting
    for(int i = 100; ros::ok() && i > 0; --i){
        local_pos_pub.publish(PoseCommand);
        ros::spinOnce();
        rate.sleep();
    }

    mavros_msgs::SetMode offb_set_mode;
    offb_set_mode.request.custom_mode = "OFFBOARD";

    mavros_msgs::CommandBool arm_cmd;
    arm_cmd.request.value = true;

    ros::Time last_request = ros::Time::now();
    //判断是否进入巡线前的预定高度
    bool reachHeight = false;
    double aimHeight = 1;
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
        if(pose_match(aimHeight, cur_z, 0.05)&&!reachHeight){
            PoseCommand.type_mask = 0b101111100011;
            PoseCommand.velocity.x = 0.2;
            PoseCommand.velocity.y = 0;
            ROS_INFO_STREAM("Vy is "<<PoseCommand.velocity.y);
            PoseCommand.position.z = aimHeight;
            PoseCommand.yaw = 0;
            reachHeight = true;
        }

        // 判断是否能拟合到线，若无法寻到线则在原地悬停
        if(line_value){
            PoseCommand.velocity.y = rho/30;
            ROS_INFO_STREAM("Vy is "<<PoseCommand.velocity.y);
        }
        else{
            PoseCommand.velocity.x = 0;
            PoseCommand.velocity.y = 0;
            PoseCommand.position.z = aimHeight;
            PoseCommand.yaw = 0;
            ROS_INFO_STREAM("Can't find a line");
        }
        ros::spinOnce();
        rate.sleep();
    }

    return 0;
}

