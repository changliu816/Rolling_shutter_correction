
files = dir('*.log');
k=1;
for i=1:length(files)
    
file = files(i,:);
fid = fopen(file.name);
data = textscan(fid,'%s%s%f%f%f%f%f%f%f%f%f','CollectOutput',1); % only the 3rd column count
fid = fclose(fid);

%% extract  gyro data
temp2=data{1,1}(:,2);
j=1;
for i=1:length(temp2)
 if isequal('GYROSCOPE',cell2mat(temp2(i))) 
     idx(j)=i;
     j=j+1;
 end
end
idx=idx';
number=data{1,2};
number=number(idx,1:3);  % gyro number
temp2=[3*ones(length(number),1),number];
%% extract time info
temp1=data{1,1}(:,1);
temp1=temp1(idx);
temp1=cell2mat(temp1);

temp1(:,9)=[];
temp1(:,end-4)=[];
temp1(:,end)=[];
%temp1=temp1(:,10:end);
% for i=1:size(temp1,1)
% temp1(i,:)=[temp1(i,:),zeros(1,6)];
% end
start2=temp1(1,:);
%temp1=str2num(temp1);


for i=1:length(temp1)
temp3(i,1)=sscanf(temp1(i,:),'%ld');
end
%% starting point of video
start=data{1,1}(1,2);
start=cell2mat(start);
start=start(6:end);
start(9)=[];
start(end-3)=[];
td=etime(datevec(start2,'yyyymmddHHMMSSFFF'),datevec(start,'yyyymmddHHMMSSFFF'));
%% 
%output=[temp1,temp2];

% write  
    f = fopen( ['gyro',num2str(k), '.txt'],'w');
   for i=1:size(temp3,1)
   %fprintf(f,'%d,%d,%f,%f,%f,\n',output(i,:));
   fprintf(f,'%d,',temp3(i,:));
   fprintf(f,'%d,%f,%f,%f,\n',temp2(i,:));
   end
   fclose(f);
   disp(['Iteration =   ' num2str(k)]);
   k=k+1;
 
    f = fopen( ['td.txt'],'w');
    fprintf(f,'%f',td);
    fclose(f);
end




