function loss = costFunction_L2I_quat_interp(pose_1, pose_2, x0)
mu = [1, 1, 1e6, 1e6]; % weight
quat = x0(1, 4 : 7);
% quat = normalize(quat); % Do Not Use!!!
quat = quat / sqrt(sum(quat.^2));
R = quat2rotm(quat);
t = x0(1, 1 : 3)';
loss = 0;
[n, ~] = size(pose_1);
for i = 2 : n
    [R_1, t_1] = calcRelativePose_quat(pose_1(i - 1, :), pose_1(i, :));
    [R_2, t_2] = calcRelativePose_quat(pose_2(i - 1, :), pose_2(i, :));
    loss = loss + mu(1) * norm(R_1 * R - R * R_2, 2) + ...
        mu(2) * norm(R_1 * t + t_1 - R * t_2 - t, 2); % Work
%     loss = loss + mu(1) * norm(R_1 * R - R * R_2, 2) + ...
%         mu(2) * norm(R_1 * t + t_1 - R * t_2 - t, 2) + ...
%         mu(2) * norm(x0(1, 1 : 3) - [0.35, 0, -0.13], 2); % Consider Measurement
%     loss = loss + mu(1) * (norm(R_1 * R - R * R_2, 2))^2 + ...
%         mu(2) * (norm(R_1 * t + t_1 - R * t_2 - t, 2))^2; % Worse
%     loss = loss + mu(1) * sum(sum((R_1 * R - R * R_2).^2)) + ...
%         mu(2) * sum(sum((R_1 * t + t_1 - R * t_2 - t).^2)); % Test
end
% loss = loss + mu(3) * norm(R * R' - eye(3), 2) + mu(4) * norm(R * R' - eye(3), 2); % Not Needed
end