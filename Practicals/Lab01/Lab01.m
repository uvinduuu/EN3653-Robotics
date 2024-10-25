% Create a new figure
figure;
% Plot the default 2D coordinate frame {0}
trplot2(eye(3), 'frame', '0');
hold on;
% Set plot limits
xlim([-4 7]);
ylim([-2 7]);
% Enable grid
grid on;
% Define the position vector
p = [5; 6];
% Draw a blue arrow from the origin to point p
plot_arrow([0, 0], [p(1), p(2)], 'b');
% Define the rotation angle
alpha = deg2rad(45);
% Create the 2D rotation matrix
R = rot2(alpha);
% Plot the rotated coordinate frame {1} in red
trplot2(R, 'frame', '1', 'color', 'r');
% Transform point p into frame {1}
p_in_frame1 = R' * p;
% Plot the transformed point p in frame {1} using a red
plot(p_in_frame1(1), p_in_frame1(2), 'ro');
disp(p_in_frame1)

% Define the position vector for point q
q = [-3; 2];
% Plot a red arrow from the origin of frame {1} to point q
% First, get the origin of frame {1} in the original frame {0}
origin_frame1 = R * [0; 0];
% Plot the red arrow for point q relative to frame {1}
plot_arrow(origin_frame1, origin_frame1 + R * q, 'r');


% Define the rotation angle for 68 degrees in radians
theta_68 = deg2rad(68);
% Create the 2D rotation matrix for 68 degrees
R_68 = rot2(theta_68);
% Rotate point p by 68 degrees to obtain point r
r = R_68 * p;
% Plot the green arrow from the origin to the new point r
plot_arrow([0, 0], [r(1), r(2)], 'g');
% Hold off to finalize the plot
hold off;

% Step 3.6: Visualizing the default 3D coordinate frame {0}
figure;
trplot(eye(3), 'frame', '0', 'color', 'k'); % Identity matrix represents frame {0}
axis([-1 2 -1 2 -1 2]); % Limiting the plot area
grid on;

% Step 3.7: Successive rotations to obtain frame {1}
theta_x = deg2rad(15); % Rotation angle about X-axis
theta_y = deg2rad(25); % Rotation angle about Y-axis
theta_z = deg2rad(35); % Rotation angle about Z-axis

% Rotation matrices
R_x = rotx(rad2deg(theta_x)); % Rotation about X-axis
R_y = roty(rad2deg(theta_y)); % Rotation about Y-axis
R_z = rotz(rad2deg(theta_z)); % Rotation about Z-axis

% Successive rotations to get final orientation
R_10 = R_x * R_y * R_z; % Final rotation matrix R_10

% Visualize the successive rotations
figure;
tranimate(eye(3), R_x, 'color', 'r', 'frame', '1'); % Rotate about X-axis
hold on;
tranimate(R_x, R_x * R_y, 'color', 'r', 'frame', '1'); % Rotate about Y-axis
tranimate(R_x * R_y, R_10, 'color', 'r', 'frame', '1'); % Rotate about Z-axis

% Plot the final frame {1}
trplot(R_10, 'frame', '1', 'color', 'r');
axis([-1 2 -1 2 -1 2]);
grid on;

% Step 3.9: Given rotation matrix
R_given = [
    0.8138 0.0400 0.5798;
    0.2962 0.8298 -0.4730;
    -0.5000 0.5567 0.6634
];

% Convert the rotation matrix to roll, pitch, and yaw angles
rpy_angles = tr2rpy(R_given, 'deg'); % Obtain roll, pitch, yaw in degrees
disp('Roll-Pitch-Yaw Angles (in degrees):');
disp(rpy_angles);

% Confirm by converting back to rotation matrix
R_confirmed = rpy2r(rpy_angles(1), rpy_angles(2), rpy_angles(3), 'deg');
disp('Reconstructed Rotation Matrix:');
disp(R_confirmed);