clear L
deg = pi/180;

% Define the 5DOF Robot using DH parameters
L(1) = Revolute('d', 0.07, 'a', 0, 'alpha', pi/2, 'qlim', [-90 90]*deg, 'offset', (-5.5)*deg);
L(2) = Revolute('d', 0, 'a', 0.105, 'alpha', pi, 'qlim', [-90 90]*deg, 'offset', 85*deg);
L(3) = Revolute('d', 0, 'a', 0.148, 'alpha', 0, 'qlim', [-90 90]*deg, 'offset', 84*deg);
L(4) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', [-90 90]*deg, 'offset', 90*deg);
L(5) = Revolute('d', 0.11, 'a', 0, 'alpha', 0, 'qlim', [-90 90]*deg, 'offset', 180*deg);

% Initial joint configurations
initial_joint_configs = [
    0, 0, 0, 0, 0;
    0, pi/2, -pi/2, 0, 0;
    0, 0, -pi/2, 0, 0;
    0, pi/8, pi/4, 0, pi/8
];

% Create the robot model
dof5_robot = SerialLink(L, 'name', '5DOF Robot');

% Define a target pose (SE3)
end_x = 0.17;
end_y = -0.17;
end_z = 0.05;

theta = atan2(end_y, end_x);

T1 = SE3(end_x, end_y, end_z) * SE3.Rz(pi) * SE3.Ry(-pi/2) * SE3.Rx(theta) * SE3.Ry(-10*deg);

% Initialize log to store all results
results_log = struct();

% Loop through each initial configuration
for i = 1:size(initial_joint_configs, 1)
    q_init = initial_joint_configs(i, :); % Get initial joint configuration
    q_ik = dof5_robot.ikine(T1, q_init, 'mask', [1 1 1 0 1 1], 'tol', 1e-7, 'ilimit', 10000);

    % Log joint angles in radians and degrees
    results_log(i).config_num = i;
    results_log(i).joint_angles_radians = q_ik;
    results_log(i).joint_angles_degrees = q_ik * (180/pi);
    
    % Display joint angles
    disp(['Configuration ', num2str(i), ':']);
    disp('Joint angles in radians:');
    disp(q_ik);
    disp('Joint angles in degrees:');
    disp(q_ik * (180/pi));
    
    % Check joint limits
    within_limits = true;
    for j = 1:dof5_robot.n
        if q_ik(j) < L(j).qlim(1) || q_ik(j) > L(j).qlim(2)
            within_limits = false;
            break;
        end
    end
    
    % Indicate whether the configuration is valid
    if within_limits
        disp('This configuration is within joint limits.');
        
        % Compute and log the final transformation matrix
        T_final = dof5_robot.fkine(q_ik);
        results_log(i).T_final = T_final;
        disp('Final Homogeneous Transformation Matrix (T):');
        disp(T_final);
        
        % Compute and log the Jacobian matrix
        J = dof5_robot.jacob0(q_ik); % Jacobian in base frame
        results_log(i).Jacobian = J;
        disp('Jacobian Matrix (Base Frame):');
        disp(J);
        
        % Compute and log transformation matrices for each joint
        T0_1 = dof5_robot.A(1, q_ik);
        T1_2 = dof5_robot.A(2, q_ik);
        T2_3 = dof5_robot.A(3, q_ik);
        T3_4 = dof5_robot.A(4, q_ik);
        T4_5 = dof5_robot.A(5, q_ik);
        
        results_log(i).T0_1 = T0_1;
        results_log(i).T1_2 = T1_2;
        results_log(i).T2_3 = T2_3;
        results_log(i).T3_4 = T3_4;
        results_log(i).T4_5 = T4_5;
        
        % Display transformation matrices
        disp('Individual Transformation Matrices:');
        disp('T0_1 (Base to Joint 1):');
        disp(T0_1);
        disp('T1_2 (Joint 1 to Joint 2):');
        disp(T1_2);
        disp('T2_3 (Joint 2 to Joint 3):');
        disp(T2_3);
        disp('T3_4 (Joint 3 to Joint 4):');
        disp(T3_4);
        disp('T4_5 (Joint 4 to Joint 5):');
        disp(T4_5);
        
        % Visualization
        dof5_robot.plot(q_ik, ...
            'workspace', [-0.6, 0.6, -0.6, 0.6, 0, 0.6], ...
            'floorlevel', 0, ...
            'jointdiam', 0.9, ...
            'noshadow', ...
            'wrist', ...
            'jaxes');
        
        % Add a title to the plot
        title(['5DOF Robot Arm Visualization - Configuration ', num2str(i)], ...
              'FontSize', 12, 'FontWeight', 'Bold');
        pause(1); % Pause for visualization
    else
        disp('This configuration is out of joint limits.');
    end
    disp('-------------------------------------------');
end

% Display all logged results for review
% disp('All Configurations and Outputs Logged:');
% disp(results_log);

clear L
