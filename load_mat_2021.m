% The MFSC data is downloaded from Tsinghua BCI research group (http://bci.med.tsinghua.edu.cn)
% When the data is ready, then run this m-file
% This m-file is used to load the MFSC data and then stored in the specified format for our following data analysis

close all
clear all
filename=mfilename('fullpath');
dataset_no=2; % 1: offline exp., 2: online exp.
if dataset_no==1
    N_s=8;
else
    N_s=12;
end
for sn=1:N_s
    if dataset_no==1
       if sn==3 
          K=2;
       else
          K=3;
       end
    else
        K=2;
    end
    data=zeros(9,1035,160,K);
    for block_no=1:K
        if dataset_no==1
           loaddata=load([cd '\S' num2str(sn) '\' num2str(block_no) '.mat']);
        else
           loaddata=load([cd '\SS' num2str(sn) '\' num2str(block_no) '.mat']);
        end
        data1 = permute(loaddata.EEG_downsample,[2 3 1]);
        data(:,:,:,block_no)=data1;
    end
    save(['S' num2str(sn) '.mat'],'data','filename');
end
