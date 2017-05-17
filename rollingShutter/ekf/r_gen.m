function r_seq = r_gen(angles, dt)

% generate the sequence of rotation matrices R(-w*dt)

a_num = length(angles)/3;
anglev = reshape(angles, 3, a_num)';
anglev = anglev.*dt(:,[1 1 1]);
theta = sqrt(sum(anglev.^2, 2));
eq_z = (theta == 0);
theta = theta+eq_z;
anglev = anglev./theta(:,[1 1 1]);
theta = theta-eq_z;
r_seq = zeros(3,3,a_num);
for i = 1:a_num
	omega = anglev(i,:);
	skew_matrix = [0 -omega(3) omega(2); omega(3) 0 -omega(1); -omega(2) omega(1) 0];
	r_seq(:,:,i) = eye(3) + sin(theta(i)).*skew_matrix' + (1-cos(theta(i))).*(skew_matrix*skew_matrix)';
end



