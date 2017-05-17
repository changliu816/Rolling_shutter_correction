function [overlap_idx_pre, overlap_idx] = find_overlap(y_k, pre_z_k)

% Aug 2012 by Chao Jia
% This function is used to find the overlap between feature point matches
% For KLT tracking this function may not be necessary, but for SIFT matching it is necessary

overlap_idx_pre = [];
overlap_idx = [];
if pre_z_k == Inf
	return;
else
	num_feat = length(y_k)/2;
	y_k = reshape(y_k,2,num_feat);
	num_feat2 = length(pre_z_k)/2;
	pre_z_k = reshape(pre_z_k,2,num_feat2);
	
	for i = 1:num_feat
		temp = y_k(1,i);
		for j = 1:num_feat2
			temp2 = pre_z_k(1,j);
			if temp == temp2
				overlap_idx = [overlap_idx; i];
				overlap_idx_pre = [overlap_idx_pre; j];
				break;
			end
		end
	end
end
	
	