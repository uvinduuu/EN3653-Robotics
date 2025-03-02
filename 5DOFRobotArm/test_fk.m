function five_dof_slider_control_with_textbox_and_radians
    % Define the 5DOF Robot using DH parameters
    deg = pi / 180;% Define the 5DOF Robot using DH parameters
    L(1) = Revolute('d', 0.07, 'a', 0, 'alpha', pi/2, 'qlim', [-90 90]*deg, 'offset', (-5.5)*deg);
    L(2) = Revolute('d', 0, 'a', 0.105, 'alpha', pi, 'qlim', [-90 90]*deg, 'offset', 85*deg);
    L(3) = Revolute('d', 0, 'a', 0.148, 'alpha', 0, 'qlim', [-90 90]*deg, 'offset', 84*deg);
    L(4) = Revolute('d', 0, 'a', 0, 'alpha', pi/2, 'qlim', [-90 90]*deg, 'offset', 90*deg);
    L(5) = Revolute('d', 0.11, 'a', 0, 'alpha', 0, 'qlim', [-90 90]*deg, 'offset', 180*deg);

    % Create the robot model
    dof5_robot = SerialLink(L, 'name', '5DOF Robot');

    % Initialize joint angles
    q_init = [0, 0, 0, 0, 0];
    
    % Create the GUI
    fig = figure('Name', '5DOF Robot Control', 'NumberTitle', 'off', ...
                 'Position', [100, 100, 1000, 500]);

    % Font size and style
    font_size = 12;
    font_weight = 'bold';

    % Create sliders, textboxes, and labels
    sliders = gobjects(5, 1);
    textboxes = gobjects(5, 1);
    radian_labels = gobjects(5, 1);
    for i = 1:5
        % Joint label
        uicontrol('Style', 'text', 'String', ['Joint ', num2str(i)], ...
                  'Position', [20, 430 - (i-1)*70, 70, 30], ...
                  'FontSize', font_size, 'FontWeight', font_weight);

        % Slider for joint angle
        sliders(i) = uicontrol('Style', 'slider', ...
                               'Min', L(i).qlim(1), 'Max', L(i).qlim(2), ...
                               'Value', q_init(i), ...
                               'Position', [100, 440 - (i-1)*70, 400, 30], ...
                               'Callback', @(src, event) update_robot());
        
        % Textbox for joint angle in degrees
        textboxes(i) = uicontrol('Style', 'edit', ...
                                 'String', '0', ...
                                 'Position', [520, 440 - (i-1)*70, 60, 30], ...
                                 'FontSize', font_size, 'FontWeight', font_weight, ...
                                 'Callback', @(src, event) update_from_text(i));
        
        % Label for radian value
        radian_labels(i) = uicontrol('Style', 'text', ...
                                     'String', '0 rad', ...
                                     'Position', [600, 440 - (i-1)*70, 100, 30], ...
                                     'FontSize', font_size, 'FontWeight', font_weight);
    end

    % Forward kinematics result display
    pos_text = uicontrol('Style', 'text', 'String', 'End Effector Position: [0, 0, 0]', ...
                         'Position', [20, 60, 900, 30], ...
                         'FontSize', font_size, 'FontWeight', font_weight, ...
                         'HorizontalAlignment', 'left');
    orient_text = uicontrol('Style', 'text', 'String', 'End Effector Orientation: [0, 0, 0]', ...
                            'Position', [20, 30, 900, 30], ...
                            'FontSize', font_size, 'FontWeight', font_weight, ...
                            'HorizontalAlignment', 'left');

    % 3D plot of the robot
    ax = axes('Parent', fig, 'Position', [0.7, 0.25, 0.25, 0.65]);
    dof5_robot.plot(q_init, 'workspace', [-0.5, 0.5, -0.5, 0.5, 0, 0.6], 'noname', 'noshadow', 'jaxes');

    % Update function for sliders
    function update_robot()
        % Get joint angles from sliders
        q_current = zeros(1, 5);
        for j = 1:5
            q_current(j) = sliders(j).Value;
            % Update the text box
            textboxes(j).String = num2str(rad2deg(q_current(j)), '%.1f');
            % Update the radian label
            radian_labels(j).String = sprintf('%.3f rad', q_current(j));
        end
        
        % Compute forward kinematics
        T = dof5_robot.fkine(q_current);
        position = transl(T);  % Extract position
        orientation = tr2rpy(T, 'deg');  % Extract orientation in degrees
        
        % Update the robot plot
        dof5_robot.plot(q_current, 'workspace', [-0.5, 0.5, -0.5, 0.5, 0, 0.6], 'noname', 'noshadow', 'jaxes', 'notiles');
        
        % Update position and orientation text
        pos_text.String = sprintf('End Effector Position: [%.2f, %.2f, %.2f]', position);
        orient_text.String = sprintf('End Effector Orientation: [%.2f, %.2f, %.2f]', orientation);
    end

    % Update function for text boxes
    function update_from_text(joint_index)
        % Get the entered value and convert to radians
        entered_angle = str2double(textboxes(joint_index).String);
        if isnan(entered_angle)
            % If invalid input, reset to the current slider value
            entered_angle = rad2deg(sliders(joint_index).Value);
            textboxes(joint_index).String = num2str(entered_angle, '%.1f');
        end
        
        % Clamp entered angle to joint limits
        entered_angle = max(min(entered_angle, rad2deg(L(joint_index).qlim(2))), rad2deg(L(joint_index).qlim(1)));
        
        % Update slider and text box with valid angle
        sliders(joint_index).Value = deg2rad(entered_angle);
        textboxes(joint_index).String = num2str(entered_angle, '%.1f');
        radian_labels(joint_index).String = sprintf('%.3f rad', deg2rad(entered_angle));
        
        % Update the robot visualization
        update_robot();
    end
end
