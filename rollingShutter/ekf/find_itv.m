function [idxa, idxb, w, idxstart] = find_itv(gyrostamp, t, idxstart)

% 2012-3-3
% find the gyroreading index interval around time t and corresponding weight w
% w = (t-ta)/(tb-ta)

i = idxstart;
while gyrostamp(i) < t
	i = i+1;
end
if i>1
	idxa = i-1;
else
	idxa = i;
end

idxb = idxa+1;
w = (t-gyrostamp(idxa))/(gyrostamp(idxb)-gyrostamp(idxa));
idxstart = idxa;