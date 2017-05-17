function H_k = ekf_info_h (y_k, z_k, x_k_km1, K, Kinv, R, rot_seq, dt, py)

% prepare for the Jacobian matrix dh/dx

feature_num = length(y_k)/2;
x_num = length(x_k_km1)/3;
Q = [0 1 0; -1 0 0; 0 0 1]*[1 0 0; 0 -1 0;0 0 -1];
H_k = zeros(2*feature_num, 3*x_num);

for i = 1:feature_num
	% initialize B and beta
	B = K*Q'*R(:,:,i);
	beta = Q*Kinv*[y_k(2*i-1:2*i);1];
	% compute dy_y
	yy = py(:,i);
	dy_y = [1/yy(3) 0 -yy(1)/(yy(3)^2); 0 1/yy(3) -yy(2)/(yy(3)^2)];
	% compute B, beta, ...
	for j = 1:x_num
		if dt(j,i) ~= 0
			% update B and beta
			B = B*rot_seq(:,:,j,i)';
			if j > 1
				beta = rot_seq(:,:,j-1,i)*beta;
			end
			
			theta_r = b2t(beta);
			dr_dw = get_dr_dw(dt(j,i));
			
			H_k((2*i-1):2*i, (3*j-2):3*j) = dy_y*B*theta_r*dr_dw;
		end
	end
end
		
		
		
	
	
		
	
	