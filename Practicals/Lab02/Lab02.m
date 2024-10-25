figure;
trplot(eye(4), 'color', 'b', 'frame', '0', 'length', 0.4, 'thick', 2); % Default frame {0}
xlabel('X'); ylabel('Y'); zlabel('Z');
axis([0 4 0 4 0 3]);
grid on;
hold on;

R_10 = rotz(90, 'deg');  % Rotation matrix for 90° about Z axis
t_10 = [2; 3; 1];         % Translation vector for position

q0 = [2; 3; 1];
plot_arrow ([0,0,0], [q0(1),q0(2),q0(3)], 'b');

H_10 = rt2tr(R_10, t_10);  % Combine rotation and translation
disp("H_10");
disp(H_10);
trplot(H_10, 'color', 'r', 'frame', '1', 'length', 0.4, 'thick', 2); % Frame {1} in red

p1 = [1; 1; 1];
p0 = H_10 * [p1; 1];  % Transform p1 to frame {0}
p0 = p0(1:3);         % Extract position part
disp('p0');
disp(p0);

plot_arrow ([0,0,0], [p0(1),p0(2),p0(3)], 'g');
plot_arrow ([t_10(1),t_10(2),t_10(3)], [p0(1),p0(2),p0(3)], 'r');

%------------------------------------------------------------------

figure;
trplot(eye(4), 'color', 'r', 'frame', '1', 'length', 0.4, 'thick', 2); % Default frame {1}
hold on;
grid on;
axis([-4 2 -1 3 -2 2]);

plot_arrow ([0,0,0], [p1(1),p1(2),p1(3)], 'r');

% Obtain inverse homogeneous matrix H01
H_01 = inv(H_10);
trplot(H_01, 'color', 'b', 'frame', '0', 'length', 0.4, 'thick', 2); % Frame {0} in blue

t_01 = H_01(1:3, end);
disp('H_01');
disp(H_01);
disp('t_01');
disp(t_01);

plot_arrow ([p1(1),p1(2),p1(3)], [t_01(1),t_01(2),t_01(3)], 'g');