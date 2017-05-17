function [VRV_k, R, rot_seq, dt, py] = ekf_info_v (y_k, z_k, gyrostamp, gyrogap, idxa, idxb, x_k_km1, frame_a, frame_b, h, ts, K, Kinv, pn)

% prepare for the Jacobian matrix dh/dv

feature_num = length(y_k)/2;
x_num = length(x_k_km1)/3;
VRV_k = zeros(feature_num*2,feature_num*2);
Q = [0 1 0; -1 0 0; 0 0 1]*[1 0 0; 0 -1 0;0 0 -1];
R = zeros(3,3,feature_num);
rot_seq = zeros(3,3,x_num, feature_num);
dt = zeros(x_num, feature_num);
py = zeros(3, feature_num);

for i = 1:feature_num
	% compute homography
	% find time interval for each angular velocity
	ta = frame_a + ts*y_k(2*i)/h;
	tb = frame_b + ts*z_k(2*i)/h;
	dt(:,i) = find_dt(gyrostamp, gyrogap, idxa, idxb, ta, tb);
	r_seq = r_gen(x_k_km1, dt(:,i));
	rot_seq(:,:,:,i) = r_seq;
	
	R(:,:,i) = eye(3);
	for j=x_num:-1:1
		R(:,:,i) = R(:,:,i)*r_seq(:,:,j);
	end
	hom = K*Q'*R(:,:,i)*Q*Kinv;
	yy = hom*[y_k(2*i-1:2*i);1];
	py(:,i) = yy;
	dy_y = [1/yy(3) 0 -yy(1)/(yy(3)^2); 0 1/yy(3) -yy(2)/(yy(3)^2)];
	temp = [dy_y*hom*[1 0; 0 1; 0 0], eye(2)];
	VRV_k((2*i-1):2*i, (2*i-1):2*i) = temp*temp';
end
VRV_k = VRV_k.*pn;


	