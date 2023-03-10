# Moveit  机械臂控制



10.7.1的夹爪joint以及角度速度、10.7.2的gripper部分，夹爪怎么控制？

10.9.1关节空间规划的marm_planning/launch/arm_planning.launch文件末尾启动rviz可视化界面的pick_and_place.rviz是怎么来的？



报错：

```xml
[FATAL] [1678236983.242573666]: Exception while loading controller manager 'z1_description': According to the loaded plugin descriptions the class z1_description with base class type moveit_controller_manager::MoveItControllerManager does not exist. Declared types are  moveit_controller_manager_example/MoveItExampleControllerManager moveit_fake_controller_manager/MoveItFakeControllerManager moveit_ros_control_interface::MoveItControllerManager moveit_ros_control_interface::MoveItMultiControllerManager moveit_simple_controller_manager/MoveItSimpleControllerManager pr2_moveit_controller_manager/Pr2MoveItControllerManager
```



在rviz中无法加载控制器，导致无法控制机械臂的运动。最后发现将`arm_moveit_controller_manager.launch.xml`中变量名修改,不报错，为什么？

```xml
  <arg name="moveit_controller_manager_1" default="moveit_simple_controller_manager/MoveItSimpleControllerManager" />
  <param name="moveit_controller_manager" value="$(arg moveit_controller_manager_1)"/>
```

