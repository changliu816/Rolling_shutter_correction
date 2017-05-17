function [newimg, idxstart] = gyrosteady(oldimg, gyrostamp, gyrogap, anglev, idxstart, tb, para, stabi_diff)

% image warping to rectify the rolling shutter effects
% 'tb' here includes the timestamp of the current frame and the delay
tb = tb + para.td;
K = para.K;
Kinv = para.Kinv;
w = para.w;
h = para.h;
ts = para.ts;
wd = [0,0,0];

% update idxstart
t = tb;
idxstart = findgyroidx(gyrostamp, t, idxstart);

% reference time
%tr = tb + ts/2;
tr = tb;
idxr = findgyroidx(gyrostamp, tr, idxstart);

% mapping using 'griddata' function
opt = 0; % 1: forward mapping; 0: inverse mapping
x = zeros(h,w);
y = zeros(h,w);
zr = zeros(h,w);
zg = zeros(h,w);
zb = zeros(h,w);
for i = 0:(h-1)
	coord = [[0:(w-1)]; i.*ones(1,w); ones(1,w)];
	t = tb + ts*(i/h);
	idx = findgyroidx(gyrostamp, t, idxstart);
	if t<tr
		hom = diffrotation(gyrostamp, idx, idxr, t, tr, wd, anglev, gyrogap);
	elseif t>tr
		hom = diffrotation(gyrostamp, idxr, idx, tr, t, wd, anglev, gyrogap);
		hom = hom';
	else
		hom = eye(3);
	end

	A = [0 1 0; -1 0 0; 0 0 1]*[1 0 0; 0 -1 0;0 0 -1];
	hom = A'*stabi_diff'*hom'*A;
	if opt == 0
		hom = hom'; % used for inverse mapping
	end
	
	newcoord = K*hom*Kinv*coord;
	newcoord = newcoord(1:2,:)./newcoord([3,3],:);
	
	x(i+1,:) = newcoord(1,:);
	y(i+1,:) = newcoord(2,:);
	zr(i+1,:) = oldimg(i+1,:,1);
	zg(i+1,:) = oldimg(i+1,:,2);
	zb(i+1,:) = oldimg(i+1,:,3);
end

[ZRI,ZGI,ZBI] = inverse_interp(x,y,zr,zg,zb);

newimg = zeros(h,w,3);
newimg(:,:,1) = ZRI;
newimg(:,:,2) = ZGI;
newimg(:,:,3) = ZBI;

	
	
