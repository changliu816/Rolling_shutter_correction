function [anglev_est, tran_err, err_unftd, var_est] = ekf_r_est(match_idx, match_x1, match_x2, gyrostamp, gyrogap, anglev, framestamp, para, endidx)

% Feb 2012 by Chao Jia
% extended Kalman filtering estimation of camera rotations using gyroscope readings and visual information
% measurement model is the transfer error between adjacent frames

% prepare for some necessary parameters
ts = para.ts;
td = para.td;
f = para.f;
w = para.w;
h = para.h;
sigma = para.sigma;
pn = para.pn;
K = para.K;
Kinv = para.Kinv;
framestamp = framestamp + td;

anglev_est = anglev;
tran_err = zeros(endidx,1);
err_unftd = zeros(endidx,1);

% first group
idxstart = 1;
% find the group
[idxa, idxstart] = find_group(gyrostamp, framestamp(1), framestamp(2), idxstart);
[idxb, idxstart] = find_group(gyrostamp, framestamp(2), framestamp(3), idxstart);
x_num = length(idxa)+length(idxb);

% initialize the estimate
x_k_km1 = reshape([anglev(idxa,:)', anglev(idxb,:)'], x_num*3, 1);
p_k_km1 = sigma.*eye(x_num*3);

% prepare the matrices of ekf filtering
match_start = 1;
[z_k, match_start, y_k] = ekf_info_z (1, match_start, match_idx, match_x1, match_x2);

[VRV_k, R, rot_seq, dt, py] = ekf_info_v (y_k, z_k, gyrostamp, gyrogap, idxa, idxb, x_k_km1, framestamp(1), framestamp(2), h, ts, K, Kinv, pn);
H_k = ekf_info_h (y_k, z_k, x_k_km1, K, Kinv, R, rot_seq, dt, py);

[x_k_k, p_k_k] = ekf_update (x_k_km1, p_k_km1, H_k, VRV_k, z_k, py);
anglev_est(idxa(1):idxb(end),:) = reshape(x_k_k, 3, length(x_k_k)/3)';
tran_err(1) = ekf_error (x_k_k, dt, y_k, z_k, K, Kinv);
err_unftd(1) = ekf_error (x_k_km1, dt, y_k, z_k, K, Kinv);
var_est(1,:) = [trace(p_k_k)/size(p_k_k,1) trace(p_k_km1)/size(p_k_k,1) length(idxa) length(idxb)];
tic;
flag=0;
tmpc=0;
for i = 2:endidx
	if ~flag
    idxc = idxa;
    else
    idxc=tmpc;
    end
	idxa = idxb;
	[idxb, idxstart,flag] = find_group(gyrostamp, framestamp(i+1), framestamp(i+2), idxstart,idxb);
    if ~flag
	[x_k_km1, p_k_km1, x_unftd, A_k] = ekf_predict (x_k_k, p_k_k, idxa, idxb, idxc, anglev, sigma);
	
	[z_k, match_start, y_k] = ekf_info_z (i, match_start, match_idx, match_x1, match_x2);
    if z_k ~= Inf
        %z_k = z_k(1:120);
        %y_k = y_k(1:120);
    end
	if z_k ~= Inf
		[VRV_k, R, rot_seq, dt, py] = ekf_info_v (y_k, z_k, gyrostamp, gyrogap, idxa, idxb, x_k_km1, framestamp(i), framestamp(i+1), h, ts, K, Kinv, pn);
		H_k = ekf_info_h (y_k, z_k, x_k_km1, K, Kinv, R, rot_seq, dt, py);
	
		[x_k_k, p_k_k] = ekf_update (x_k_km1, p_k_km1, H_k, VRV_k, z_k, py);
	else
		x_k_k = x_k_km1;
		p_k_k = p_k_km1;
	end

    if ~mod(i,355)
        disp(i);
    end
   
	tran_err(i) = ekf_error (x_k_k, dt, y_k, z_k, K, Kinv);
	err_unftd(i) = ekf_error (x_unftd, dt, y_k, z_k, K, Kinv);
	anglev_est(idxa(1):idxb(end),:) = reshape(x_k_k, 3, length(x_k_k)/3)';
	var_est(i,:) = [trace(p_k_k)/size(p_k_k,1) trace(p_k_km1)/size(p_k_k,1) length(idxa) length(idxb)];
    else
    tran_err(i) = tran_err(i-1);
	err_unftd(i) = err_unftd(i-1);
	var_est(i,:) = var_est(i-1,:);  
    tmpc=idxc;    
    end
end
toc