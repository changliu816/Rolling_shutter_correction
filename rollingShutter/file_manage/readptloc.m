function [frameidx, fploc, fploc2] = readptloc(filepath, framenum, ptnum)

% read the 2D locations of feature points in each keyframe

frameidx = zeros(framenum,1);
fploc = zeros(ptnum,2,framenum);
fploc2 = zeros(2,ptnum,framenum);

fid = fopen(filepath);
for i = 1:framenum
	frameidx(i) = fscanf(fid,['#timeindex' '%d']);
	temp = fscanf(fid, '%f');
	fploc(:,:,i) = reshape(temp,[2,ptnum])';
	fploc2(:,:,i) = fploc(:,:,i)';
end
fclose(fid);
