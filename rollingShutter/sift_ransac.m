function [inlier_idx, best_error] = sift_ransac(current_frame, base_frame, input_pt, base_pt, dist_thresh, inlier_thresh)

% this function is used to re-select the feature point matching between two adjacent frames by RANSAC

s = warning('off', 'Images:maketform:conditionNumberofAIsHigh');

if size(input_pt,2) < 3
    input_pt(:,3) = ones(size(input_pt,1),1);
end

num_pt = size(input_pt, 1);
num_iter = 500;

dist_thresh = dist_thresh^2;

best_error = inf;
inlier_idx = [];

if size(input_pt,1) < inlier_thresh
    return;
end

for i=1:num_iter
    found_points = 0;
    while ~found_points
        try
            % randomly pick a set of points
            while 1
                idx = floor(rand(4,1)*num_pt) + 1;
                if numel(unique(idx)) == numel(idx)
                    break;
                end
            end

            % compute a transformation
            TFORM = cp2tform(input_pt(idx,1:2), base_pt(idx,:), 'projective');
            if isfield(TFORM.tdata, 'T')
                found_points = 1;
            end
        catch e
            %warning(e.message);
        end
    end
    
    warped_pt = input_pt * TFORM.tdata.T;
    warped_pt = warped_pt(:,1:2) ./ warped_pt(:,[3 3]);
    err = base_pt - warped_pt;
    err = sum(err .* err, 2);
    
    idx = err < dist_thresh;
    num_inliers = sum(idx);
    if (num_inliers > inlier_thresh)
        % refine transformation estimate
        TFORM = cp2tform(input_pt(idx,1:2), base_pt(idx,:), 'projective');
		warped_pt = input_pt(idx,:) * TFORM.tdata.T;
        warped_pt = warped_pt(:,1:2) ./ warped_pt(:,[3 3]);
        err = base_pt(idx,:) - warped_pt;
        err = mean(sum(err .* err, 2));
        
        inlier_thresh = num_inliers;
        
        best_error = err;
        inlier_idx = find(idx);
    end
end

warning(s);