function dt = find_dt(gyrostamp, gyrogap, idxa, idxb, ta, tb)

% find the delta_t for every angular velocity
w_num = length(idxa)+length(idxb);
dt = zeros(w_num, 1);
% get position of ta and tb
i = idxa(1);
while (gyrostamp(i) < ta) & (i <= idxa(end))
	i = i+1;
end
tempa = i-1;
if i == 1
	tempa = 1;
end

if length(idxb) == 0
	tempb = idxa(end);
else
	i = idxb(1);
	while (gyrostamp(i) < tb) & (i <= idxb(end))
		i = i+1;
	end
	tempb = i-1;
end
% assign values for td
temp = gyrogap(tempa:tempb);
temp(1) = gyrostamp(tempa+1)-ta;
temp(end) = tb-gyrostamp(tempb);

dt((tempa-idxa(1)+1):(tempb-idxa(1)+1)) = temp;