function x = calibfun(p, match_x1, match_x2, match_idx, gyrostamp, gyrogap, anglev, framestamp, w, h)

% This function is the implementation of the following paper:
% "Digital video stabilization and rolling shutter correction using gyroscopes", A. Karpenko, et. al.
% The difference is that we use levenberg marquardt instead of direct gradient descent
% This function is used as the measurement function in nonlinear least square problems
% This function will be used in the Levmar solver
% p is the variable, x is the measurements
% p includes:
%	ts		1*1		image scan time of each frame (duty cycle)
%	td		1*1		time delay of framestamps relative to gyrostamps
%	wd		1*3		avg drift of gyro readings
%   f		1*1		focal length
%   pp1,pp2 1*1     optical center

if length(p) ~= 8
	fprintf('error: the length of variable is wrong \n');
end

% parse the variables from p
ts = p(1);
td = p(2);
wd = p(3:5)';
f = p(6);
pp1 = p(7);
pp2 = p(8);

num_match = length(match_idx);
x = zeros(2*num_match, 1);

% prepare the intrinsic matrix K
K = [f, 0, pp1; 0, f, pp2; 0 0 1];
Kinv = inv(K);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

idxstarta = 1; % the starting timestamp index in R interpolation
idxstartb = 1;
pre_fidx = -1;
for i = 1:num_match
	idxa = match_idx(i);
	idxb = idxa + 1;
	if pre_fidx ~= idxa
	% set a new tstart for these two frames;
		pre_fidx = idxa;
		ta = framestamp(idxa) + td;
		gyroidxa = findgyroidx(gyrostamp, ta, idxstarta);
		idxstarta = gyroidxa;
		tb = framestamp(idxb) + td;
		gyroidxb = findgyroidx(gyrostamp, tb, idxstartb);
		idxstartb = gyroidxb;
	end
	ta = framestamp(idxa) + ts*match_x1(i,2)/h + td;
	tb = framestamp(idxb) + ts*match_x2(i,2)/h + td;
	gyroidxa = findgyroidx(gyrostamp, ta, idxstarta);
	gyroidxb = findgyroidx(gyrostamp, tb, idxstartb);
	hom = diffrotation(gyrostamp, gyroidxa, gyroidxb, ta, tb, wd, anglev, gyrogap);
	A = [0 1 0; -1 0 0; 0 0 1]*[1 0 0; 0 -1 0;0 0 -1];
	y = K*A'*hom'*A*Kinv*[match_x1(i,:)';1];
	if y(3) == 0
		y(3) = 1E-10;
	end
	x(2*i-1 : 2*i) = y(1:2)./y(3);
end