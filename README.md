# 🤖 5-DoF Robotic Arm Control System

A complete robotic arm control system developed as part of the EN3563 Robotics module at the University of Moratuwa. This project blends kinematic modeling, interactive simulation, and real-time hardware control using MATLAB and Arduino.

## 📌 Overview

This project demonstrates a working 5-DoF robotic arm system featuring:

- Denavit-Hartenberg (DH) based kinematic modeling
- Forward and inverse kinematics
- Jacobian matrix for velocity and dynamic analysis
- A MATLAB GUI for intuitive control and simulation
- Real-time hardware actuation via serial communication with Arduino

## 🛠️ Features

- **MATLAB Robotics Toolbox** for geometric modeling and trajectory planning
- **MATLAB GUI** with sliders and textboxes for joint angle manipulation
- **Real-time end-effector visualization** (position + orientation)
- **Arduino Uno** for multi-servo control and precise actuation
- **Serial Communication** for seamless MATLAB–Arduino integration

## 🧮 Kinematic Modeling

- Defined DH parameters for all 5 joints
- Implemented:
  - Forward Kinematics (FK)
  - Inverse Kinematics (IK)
  - Jacobian matrix analysis for velocity and singularity conditions

## 🖥️ GUI Application

- Developed using MATLAB App Designer
- Real-time display of:
  - Joint angles
  - End-effector pose (position + orientation)
- Supports trajectory planning and step-wise control

## 🔧 Hardware Setup

- **Arduino Uno**
- **5 Servo Motors** (one per joint)
- Power supply and protoboard for actuation
- Serial communication over USB for sending joint commands from MATLAB

## 🔄 MATLAB–Arduino Communication

- MATLAB sends calculated joint angles to Arduino via serial
- Arduino interprets angles and drives corresponding servos
- Smooth synchronized motion for pick-and-place tasks

## 📦 Project Structure

