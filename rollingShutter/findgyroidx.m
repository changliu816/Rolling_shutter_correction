function idx = findgyroidx(gyrostamp, t, idxstart)

% 2012-2-19 just used to find the nearest gyrostamp for a time t

gyrol = length(gyrostamp);
idx = idxstart;
tt = gyrostamp(idx);
while t>tt & idx<gyrol
	idx = idx+1;
	tt = gyrostamp(idx);
end
if idx > 1
	idx = idx - 1;
end
