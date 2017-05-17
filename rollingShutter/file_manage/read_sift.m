function [match_idx, match_x1, match_x2] = read_sift(imagepath)

path1 = [imagepath,'/match_idx.txt'];
match_idx = textread(path1, '%d');

path2 = [imagepath,'/match_x1.txt'];
[temp1, temp2] = textread(path2, '%f,%f,');
match_x1 = [temp1,temp2];

path3 = [imagepath,'/match_x2.txt'];
[temp1, temp2] = textread(path3, '%f,%f,');
match_x2 = [temp1,temp2];
