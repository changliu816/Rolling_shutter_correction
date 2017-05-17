function save_sift(imagepath, match_idx, match_x1, match_x2)

%

fid = fopen([imagepath,'/match_idx.txt'],'w');
fprintf(fid,'%d\n',match_idx);
fclose(fid);
fid = fopen([imagepath,'/match_x1.txt'],'w');
fprintf(fid,'%f,%f,\n',match_x1');
fclose(fid);
fid = fopen([imagepath,'/match_x2.txt'],'w');
fprintf(fid,'%f,%f,\n',match_x2');
fclose(fid);