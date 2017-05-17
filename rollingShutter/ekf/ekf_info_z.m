function [z_k, matchstart, y_k] = ekf_info_z (t, match_start, match_idx, match_x1, match_x2)

% prepare for z_k
i = match_start;
while match_idx(i) < t;
	i = i+1;
end
tempa = i;

if match_idx(i) == t
	% if the matches exist
	while match_idx(i) < t+1;
		i = i+1;
	end
	tempb = i-1;
	y_k = reshape(match_x1(tempa:tempb, :)', 2*(tempb-tempa+1), 1);
	z_k = reshape(match_x2(tempa:tempb, :)', 2*(tempb-tempa+1), 1);
	matchstart = i;
else 
	% if not then no matching
	matchstart = i;
	y_k = Inf;
	z_k = Inf;
end

	




