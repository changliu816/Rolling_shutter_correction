function hom = diffrotation(gyrostamp, gyroidxa, gyroidxb, ta, tb, wd, anglev, gyrogap)

%
hom = eye(3);

for i = gyroidxa:gyroidxb
	if i == gyroidxa
		dt = gyrostamp(i+1) - ta;
	elseif i == gyroidxb
		dt = tb - gyrostamp(i);
	else
		dt = gyrogap(i);
	end
	
	if gyroidxa == gyroidxb
		dt = tb - ta;
	end
	
	tempv = dt.*(anglev(i,:)+wd);
	theta = norm(tempv);
	tempv = tempv./theta;
	skewv = [0 -tempv(3) tempv(2); tempv(3) 0 -tempv(1); -tempv(2) tempv(1) 0]; % get the skew matrix
	tempr = eye(3) + sin(theta).*skewv + (1-cos(theta)).*skewv*skewv;
	hom = hom*tempr;
end