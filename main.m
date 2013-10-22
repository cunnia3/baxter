clear all;close all;clc;
% This is the main file!

%% Robot Raconteur Connections

% Connect to ROS Bridge for Baxter.
baxter = RobotRaconteur.Connect('tcp://localhost:34572/{0}/ROSBridge');

% Set up joint velocity publisher
handle_leftJointVel = baxter.publish('/robot/limb/left/command_joint_velocities', 'baxter_msgs/JointVelocities');
publisher_leftJointVel = baxter.get_publishers(handle_leftJointVel);

% Set up joint command mode publisher
handle_leftMode = baxter.publish('/robot/limb/left/joint_command_mode', 'baxter_msgs/JointCommandMode');
publisher_leftMode = baxter.get_publishers(handle_leftMode);

% Set up joint states subscriber
handle_jointStates = baxter.subscribe('/robot/joint_states', 'sensor_msgs/JointState');
subscriber_jointStates = baxter.get_subscribers(handle_jointStates);
baxter_JointStates = subscriber_jointStates.subscriberwire.Connect();

%% Initial parameter setup

% baxter_msgs/JointCommandMode
leftMode.mode = uint8(2);   % 1 for position mode; 2 is for velocity mode; 3 for torque mode

% baxter_msgs/JointVelocities
leftJointVel.names = {{int32(0),'left_e0'};{int32(1),'left_e1'};{int32(2),'left_s0'};{int32(3),'left_s1'};{int32(4),'left_w0'};{int32(5),'left_w1'};{int32(6),'left_w2'}};
leftJointVel.velocities = [0;0;0;0;0;0;0];

%% Main

kbhit('init');
setBaxterConstants;

while(1)
      
    % Gather joint information
    i = 1;
    while(i)  
        if baxter_JointStates.InValueValid == 1 
            jointStates = baxter_JointStates.InValue;
            jointAnglesLeft = jointStates.position(3:9); % (See line 27 for the order)
            i=0;    
        end  
    end
    
    % Reorder jointAngle to be [left_s0,left_s1,left_e0,left_e1,left_w0,left_w1,left_w2]
    joint34 = jointAnglesLeft(3:4);
    joint12 = jointAnglesLeft(1:2);
    jointAnglesLeft = [joint34;joint12;jointAnglesLeft(5:7)];
    
    % Calculate full jacobian for left arm
    J = jacobian(baxterConst.leftArm,jointAnglesLeft);
    
    % Input desired end-effector velocity
    linVel = [0;0;0];
    deltaX = 0.05;
    deltaY = 0.05;
    deltaZ = 0.05;
    clc;
    display('Press w(forward),a(left),s(backward),d(right),q(up),e(down),x(stop)');
    pause(0.01);
    keyPress = kbhit;
    if isempty(keyPress)
        keyPress = 'nothing';
    end
    switch keyPress
        case 'W'
            linVel(1) = deltaX;
        case 'A'
            linVel(2) = deltaY; 
        case 'S'
            linVel(1) = -deltaX; 
        case 'D'
            linVel(2) = -deltaY;   
        case 'Q'
            linVel(3) = deltaZ;
        case 'E'
            linVel(3) = -deltaZ; 
        otherwise 
            linVel = [0;0;0];         
    end
    linVelCorrect = rot([0;0;1],pi/4)*linVel;
    desVel = [0;0;0;linVelCorrect];
    
    % Calculate desired joint angle velocities
    if any(desVel)
        qDot = J\desVel;
        % Limit angular joint velocity to +/- 2.5
        for k = 1:length(qDot)
            if abs(qDot(k)) > 2.5
                qDot(k) = sign(qDot(k))*2.5;
            end
        end     
    else
        qDot = [0;0;0;0;0;0;0];
    end

    % Publish desired joint velocities
    leftJointVel.velocities = [qDot(3);qDot(4);qDot(1);qDot(2);qDot(5);qDot(6);qDot(7)];
    publisher_leftMode.publish(leftMode);
    publisher_leftJointVel.publish(leftJointVel);
    
end