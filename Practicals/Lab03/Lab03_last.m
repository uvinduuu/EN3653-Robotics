close all;
clear all;
mdl_puma560
T1 = SE3(0.8,0,0)*SE3.Ry(pi/2);
T2 = SE3(-0.8,0,0)*SE3.Rx(pi);
q1 = p560.ikine6s(T1);
q2 = p560.ikine6s(T2);
t = [0:0.05:2]';
q = jtraj(q1, q2, t);
p560.plot3d(q);
