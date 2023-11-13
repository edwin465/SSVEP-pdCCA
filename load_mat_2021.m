close all
clear all
filename=mfilename('fullpath');
for sn=1:8
    if sn==3
        K=2;
    else
        K=3;
    end
    data=zeros(9,1035,160,K);
    for block_no=1:K
        loaddata=load([cd '\S' num2str(sn) '\' num2str(block_no) '.mat']);
        data1 = permute(loaddata.EEG_downsample,[2 3 1]);
        data(:,:,:,block_no)=data1;
    end
    save(['S' num2str(sn) '.mat'],'data','filename');
end