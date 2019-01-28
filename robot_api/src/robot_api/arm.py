#!/usr/bin/env python

import actionlib
import control_msgs.msg
import trajectory_msgs.msg
import rospy

from .arm_joints import ArmJoints

JOINT_ACTION_SERVER = 'arm_controller/follow_joint_trajectory'
TIME_FROM_START = 5

class Arm(object):
    """Arm controls the robot's arm.

    Joint space control:
        joints = ArmJoints()
        # Fill out joint states
        arm = robot_api.Arm()
        arm.move_to_joints(joints)
    """

    def __init__(self):
        self._joint_client = actionlib.SimpleActionClient(
            JOINT_ACTION_SERVER, control_msgs.msg.FollowJointTrajectoryAction)
        self._joint_client.wait_for_server(rospy.Duration(10))
        pass

    def move_to_joints(self, arm_joints):
        """Moves the robot's arm to the given joints.

        Args:
            arm_joints: An ArmJoints object that specifies the joint values for
                the arm.
        """
        point = trajectory_msgs.msg.JointTrajectoryPoint()
        point.positions.extend(arm_joints.values())
        point.time_from_start = rospy.Duration(TIME_FROM_START)

        goal = control_msgs.msg.FollowJointTrajectoryGoal()
        goal.trajectory.joint_names.extend(ArmJoints.names())
        goal.trajectory.points.append(point)

        self._joint_client.send_goal(goal)
        self._joint_client.wait_for_result(rospy.Duration(10))
