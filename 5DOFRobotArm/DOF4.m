clear L
deg = pi/180;

% Define the 4DOF Robot using DH parameters
L(1) = Revolute('d', 0.069, 'a', 0, 'alpha', pi/2, 'qlim', [-90 90]*deg, 'offset',pi/2);
L(2) = Revolute('d', 0, 'a', 0.105, 'alpha', 0, 'qlim', [-90 90]*deg, 'offset',pi/2);
L(3) = Revolute('d', 0, 'a', 0.150, 'alpha', 0, 'qlim', [-90 90]*deg, 'offset',-pi/2);
L(4) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', [-90 90]*deg, 'offset',pi/2);

% Initial joint configurations
initial_joint_configs = [
    0, 0, 0, 0;
    0, pi/2, -pi/2, 0;
    0, 0, -pi/2, 0;
    0, pi/8, pi/4, pi/8
];

% Create the robot model
dof4_robot = SerialLink(L, 'name', '4DOF Robot');

% Define a target pose (SE3)
T1 = SE3(0.35, 0.4, 0.15) * SE3.Rz(pi/2)* SE3.Ry(-pi/4);

% Loop through each initial configuration
for i = 1:size(initial_joint_configs, 1)
    q_init = initial_joint_configs(i, :); % Get initial joint configuration
    q_ik = dof4_robot.ikunc(T1, q_init);  % Perform inverse kinematics
    
    % Display all joint angles
    disp(['Configuration ', num2str(i), ':']);
    disp('Joint angles in radians:');
    disp(q_ik);
    disp('Joint angles in degrees:');
    disp(q_ik * (180/pi));
    
    % Check joint limits
    within_limits = true;
    for j = 1:dof4_robot.n
        if q_ik(j) < L(j).qlim(1) || q_ik(j) > L(j).qlim(2)
            within_limits = false;
            break;
        end
    end
    
    % Indicate whether the configuration is valid
    if within_limits
        disp('This configuration is within joint limits.');
        
        % Optional visualization
        dof4_robot.plot(q_ik, ...
            'workspace', [-0.8, 0.8, -0.8, 0.8, 0, 0.6], ...
            'floorlevel', 0, ...
            'jointdiam', 0.9, ...
            'noshadow', ...
            'noname', ...
            'wrist', ...
            'jaxes', ...
            'view', [30, 30], ...
            'scale', 1);
        pause(1); % Pause for visualization
    else
        disp('This configuration is out of joint limits.');
    end
    disp('-------------------------------------------');
end

% Clear variables
clear L
