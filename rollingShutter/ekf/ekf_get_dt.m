function dt = ekf_get_dt (y_k, z_k, gyrostamp, gyrogap, idxa, idxb, x_k_km1, frame_a, frame_b, h, ts);

% Jul 2012 by Chao Jia

feature_num = length(y_k)/2;
x_num = length(x_k_km1)/3;
dt = zeros(x_num, feature_num);

for i = 1:feature_num
	% find time interval for each angular velocity
	ta = frame_a + ts*y_k(2*i)/h;
	tb = frame_b + ts*z_k(2*i)/h;
	dt(:,i) = find_dt(gyrostamp, gyrogap, idxa, idxb, ta, tb);
end
