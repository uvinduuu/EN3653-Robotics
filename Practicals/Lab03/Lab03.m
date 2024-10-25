mdl_puma560;
p560;

qz = p560.qz ; % Zero angle configuration
qr = p560.qr ;  % Ready pose
qs = p560.qs ;  % Stretch pose
qn = p560.qn ;  % Nominal pose

p560.tool = SE3(0,0,0.2);   

Tz = p560.fkine(qz);  % Forward kinematics for zero angle configuration
Tr = p560.fkine(qr); % Forward kinematics for ready pose
Ts = p560.fkine(qs);  % Forward kinematics for stretch pose
Tn = p560.fkine(qn);  % Forward kinematics for nominal pose

p560.plot3d(qz);   % Plot zero angle configuration
%p560.plot3d(qr);   % Plot ready pose
%p560.plot3d(qs);   % Plot stretch pose
%p560.plot3d(qn);   % Plot nominal pose 

p560.tool = SE3();   % Resets the tool transform to zero in T6 frame
qn = p560.qn ;
T_nominal = p560.fkine(qn);
q_ikine = p560.ikine6s(T_nominal);   % Inverse kinematics to recover joint angles

q_left_elbow_up = p560.ikine6s(T_nominal, 'lu');    % Left hand, elbow up
T_nominal_left_elbow_up = p560.fkine(q_left_elbow_up);
q_left_elbow_down = p560.ikine6s(T_nominal, 'ld');  % Left hand, elbow down
T_nominal_left_elbow_down = p560.fkine(q_left_elbow_down);
q_right_elbow_up = p560.ikine6s(T_nominal, 'ru');   % Right hand, elbow up
T_nominal_right_elbow_up = p560.fkine(q_right_elbow_up);
q_right_elbow_down = p560.ikine6s(T_nominal, 'rd'); % Right hand, elbow down
T_nominal_right_elbow_down = p560.fkine(q_right_elbow_down);

%p560.plot3d(q_left_elbow_up);   % Plot zero angle configuration
%p560.plot3d(q_left_elbow_down);   % Plot ready pose
p560.plot3d(q_right_elbow_up);   % Plot stretch pose
%p560.plot3d(q_right_elbow_down);   % Plot nominal pose

T_unreachable = [0; 0; 2];
q_ikine_unreachable = p560.ikine6s(T_unreachable);