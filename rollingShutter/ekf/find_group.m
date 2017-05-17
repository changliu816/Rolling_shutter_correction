function [idx,idxstart,flag] = find_group(gyrostamp, ta, tb, idxstart,idxb)
flag=0;
% find the gyroreading index group around the given time ta and before tb
i = idxstart;
while gyrostamp(i) < ta
	i = i+1;
end
if i>1
	tempa = i-1;
else
	tempa = i;
end

while gyrostamp(i) < tb
	i = i+1;
end
tempb = i-2;

if tempa >tempb
    idx=idxb;
    idxstart = idxstart;
    flag=1;
else
idx = [tempa:tempb];
idxstart = tempb+1;
end





