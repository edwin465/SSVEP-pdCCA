%% Demo of multi-stimulus CCA or TRCA for SSVEP Recognition %%%
% In this code, we provide an example of using multi-stimulus canonical
% correlation analysis (msCCA) and for the ensemble task-related component
% analysis (eTRCA) SSVEP recognition. Besides, the extended CCA (eCCA) and
% the traditional eTRCA are also provided for comparison study.
% For the above algorithms, please refer the following papers for
% more details:
% msCCA: Wong, C. M., et al. (2019). Learning across multi-stimulus enhances target recognition methods in SSVEP-based BCIs. Journal of neural engineering.
% ms-eTRCA: Wong, C. M., et al. (2019). Learning across multi-stimulus enhances target recognition methods in SSVEP-based BCIs. Journal of neural engineering.
% eCCA: Chen, X., et al. (2015). High-speed spelling with a noninvasive brain¡Vcomputer interface. Proceedings of the national academy of sciences, 112(44), E6058-E6067.
% eTRCA: Nakanishi, M., et al. (2017). Enhancing detection of SSVEPs for a high-speed brain speller using task-related component analysis. IEEE Transactions on Biomedical Engineering, 65(1), 104-112.

% In this example, most parameters (such as number of harmonics, time-window lengths and number
% of neighboring templates) can be adjusted manually to explore their
% effects on the final performance
%

% This code is prepared by Chi Man Wong (chiman465@gmail.com)
% Date: 16 May 2020
% if you use this code for a publication, please cite the following papers
% @article{wong2020learning,
%   title={Learning across multi-stimulus enhances target recognition methods in SSVEP-based BCIs},
%   author={Wong, Chi Man and Wan, Feng and Wang, Boyu and Wang, Ze and Nan, Wenya and Lao, Ka Fai and Mak, Peng Un and Vai, Mang I and Rosa, Agostinho},
%   journal={Journal of Neural Engineering},
%   volume={17},
%   number={1},
%   pages={016026},
%   year={2020},
%   publisher={IOP Publishing}
% }
% @article{wong2020spatial,
%   title={Spatial Filtering in SSVEP-based BCIs: Unified Framework and New Improvements},
%   author={Wong, Chi Man and Wang, Boyu and Wang, Ze and Lao, Ka Fai and Rosa, Agostinho and Wan, Feng},
%   journal={IEEE Transactions on Biomedical Engineering},
%   year={2020},
%   publisher={IEEE}
% }

clear all;
close all;
% Please download the SSVEP benchmark dataset for this code
% Wang, Y., et al. (2016). A benchmark dataset for SSVEP-based brain¡Vcomputer interfaces. IEEE Transactions on Neural Systems and Rehabilitation Engineering, 25(10), 1746-1752.
% Then indicate where the directory of the dataset is :
% str_dir=cd; % Directory of the SSVEP Dataset (Change it if necessary)
str_dir='..\TH_MFSC\';
addpath('..\mytoolbox\');

num_of_subj=8; % Number of subjects (35 if you have the benchmark dataset)

Fs=250; % sample rate
ch_used=[1:9]; % Pz, PO5, PO3, POz, PO4, PO6, O1,Oz, O2 (in SSVEP benchmark dataset)
% ch_used=[
% ch_used=[1:9];

num_of_trials=5;                    % Number of training trials (1<=num_of_trials<=2)
num_of_harmonics=5;                 % for all cca-based methods
num_of_signal_templates=12;         % for mscca (1<=num_of_signal_templates<=40)
num_of_signal_templates2=2;         % for ms-etrca (1<=num_of_signal_templates<=40)
num_of_r=4;                         % for ecca
num_of_subbands=6;                  % for filter bank analysis
FB_coef0=[1:num_of_subbands].^(-1.25)+0.25; % for filter bank analysis
latencyDelay = round(0.14*Fs);% time windows for CCA training
% About the above parameter, please check the related paper:
% Chen, X., et al. (2015). Filter bank canonical correlation analysis for implementing a high-speed SSVEP-based brain¡Vcomputer interface. Journal of neural engineering, 12(4), 046008.

% time-window length (min_length:delta_t:max_length)
min_length=4*0.9;
delta_t=0.2;
max_length=min_length;                     % [min_length:delta_t:max_length]

enable_bit=[1 0 0 0];               % Select the algorithms: bit 1: eCCA, bit 2: msCCA, bit 3: eTRCA, bit 4: ms-eTRCA, e.g., enable_bit=[1 1 1 1]; -> select all four algorithms
is_center_std=0;                    % 0: without , 1: with (zero mean, and unity standard deviation)

% Chebyshev Type I filter design
% for k=1:num_of_subbands
%     bandpass1(1)=8*k;
%     bandpass1(2)=90;
%     [b2(k,:),a2(k,:)] = cheby1(4,1,[bandpass1(1)/(Fs/2) bandpass1(2)/(Fs/2)],'bandpass');
% end
%bandpass filter
for k=1:num_of_subbands
    Wp = [(8*k)/(Fs/2) 90/(Fs/2)];
    Ws = [(8*k-2)/(Fs/2) 100/(Fs/2)];
    [N,Wn] = cheb1ord(Wp,Ws,3,40);
    [subband_signal(k).bpB,subband_signal(k).bpA] = cheby1(N,0.5,Wn);
    %         subband(k).bpdata=zeros(length(eeg_channels),round(max(epochTime)*srate),length(condition),length(blocknum),length(sub));
end
%notch
Fo = 50;
Q = 35;
BW = (Fo/(Fs/2))/Q;

% coeff1=[0:0.25:4];coeff2=[0:0.25:4];ct=1;

% coeff1=[1.25];coeff2=[0.25];ct=1;
% for a1=1:length(coeff1)
%     for a2=1:length(coeff2)
%         tmp=[1:num_of_subbands].^(-coeff1(a1))+coeff2(a2);
%         %         tmp=[1:num_of_subbands2].^(-1.25)+0.25;
%         save_coef(:,ct)=tmp;
%         ct=ct+1;
%     end
% end
[notchB,notchA] = iircomb(Fs/Fo,BW,'notch');
seed = RandStream('mt19937ar','Seed','shuffle');
mycounter=1;

load([str_dir 'reqCodeword.mat']);

for sn=1:num_of_subj
    tic
    %     load(strcat(str_dir,'\','exampleData.mat'));
    load(strcat(str_dir,'\Offline\S',num2str(sn),'.mat'));
    
    %  pre-stimulus period: 0.5 sec
    %  latency period: 0.14 sec
    eeg=data(ch_used,:,:,:);    
    
    [d1_,d2_,d3_,d4_]=size(eeg);
    d1=d3_;d2=d4_;d3=d1_;d4=d2_;
    no_of_class=d1;
    % d1: num of stimuli
    % d2: num of trials
    % d3: num of channels % Pz, PO5, PO3, POz, PO4, PO6, O1, Oz, O2
    % d4: num of sampling points
    for i=1:1:d1
        for j=1:1:d2
            y0=reshape(eeg(:,:,i,j),d3,d4);
            SSVEPdata(:,:,j,i)=reshape(y0,d3,d4,1,1);
            y = filtfilt(notchB, notchA, y0.'); %notch
            y = y.';
            for sub_band=1:num_of_subbands
                
                for ch_no=1:d3
                    %                     if is_CAR==1
                    %                         y(ch_no,:)=y(ch_no,:)-mean(y([1:ch_no-1,ch_no+1:end],:));
                    %                     end
                    %                     if (num_of_subbands==1)
                    %                         y_sb(ch_no,:)=y(ch_no,:);
                    %                     else
                    %                         tmp2 = filtfilt(b2(sub_band,:),a2(sub_band,:),y(ch_no,:));
                    tmp2=filtfilt(subband_signal(sub_band).bpB,subband_signal(sub_band).bpA,y(ch_no,:));
                    y_sb(ch_no,:) = tmp2(latencyDelay+1:latencyDelay+4*Fs);
                    %                     end
                end
                
                subband_signal(sub_band).SSVEPdata(:,:,j,i)=reshape(y_sb,d3,length(y_sb),1,1);
            end
            
        end
    end
    
    clear eeg
    %% Initialization
    
    n_ch=size(SSVEPdata,1);
    
    TW=min_length:delta_t:max_length;
    TW_p=round(TW*Fs);
    n_run=d2;                                % number of used runs
    
    pha_val=[0 0.5 1 1.5 0 0.5 1 1.5]*pi;
    sti_f=[8:15];
    n_sti=length(sti_f);                     % number of stimulus frequencies
%     temp=reshape([1:40],8,5);
%     temp=temp';
%     target_order=temp(:)';
%     SSVEPdata=SSVEPdata(:,:,:,target_order);
%     for sub_band=1:num_of_subbands
%         subband_signal(sub_band).SSVEPdata=subband_signal(sub_band).SSVEPdata(:,:,:,target_order); % To sort the orders of the data as 8.0, 8.2, 8.4, ..., 15.8 Hz
%     end
    
    
    for tw_length=1:length(TW)
        sig_len=floor(TW_p(tw_length)/4);        
        for j=1:no_of_class
            ref4=[];ref4a=[];
            for k=1:4
                jj=reqCodeword(j,k)+1;
                ref0=ref_signal_nh(sti_f(jj),Fs,pha_val(jj),sig_len,num_of_harmonics);
                ref4=[ref4 ref0];
                ref0=ref_signal_nh(sti_f(jj),Fs,0,sig_len,num_of_harmonics);
                ref4a=[ref4a ref0];
            end
            
            NewYref{tw_length}(:,:,j)=ref4;      
            NewYrefa{tw_length}(:,:,j)=ref4a;  
        end
        
        for j=1:length(sti_f)
            
            ref1=ref_signal_nh(sti_f(j),Fs,pha_val(j),sig_len,num_of_harmonics);
            Yref{tw_length}(:,:,j)=ref1;            
        end
        
        %         Yref{tw_length}=REF;
    end
   
    FB_coef=FB_coef0'*ones(1,no_of_class);
    %     n_correct=zeros(length(TW),size(save_coef,2)); % Count how many correct detection
    n_correct=zeros(length(TW),5); % Count how many correct detection
    
    seq_0=zeros(d2,num_of_trials);
    
    idx_testdata=1:n_run; % index of the testing trials
    
    
    for run_test=1:length(idx_testdata)
        for tw_length=1:length(TW)
            sig_len=TW_p(tw_length);
            seg_len=floor(TW_p(tw_length)/4); 
%             test_signal=zeros(d3,sig_len);
            fprintf('Testing TW %fs, No.crossvalidation %d \n',TW(tw_length),idx_testdata(run_test));
            old_test_signal=zeros(d3,sig_len,num_of_subbands);
            NACCAR=[];
            for i=1:no_of_class
                
                
                for sub_band=1:num_of_subbands
                    test_signal=subband_signal(sub_band).SSVEPdata(:,1:4*Fs,idx_testdata(run_test),i);
                    
                    if (is_center_std==1)
                        test_signal=test_signal-mean(test_signal,2)*ones(1,length(test_signal));
                        test_signal=test_signal./(std(test_signal')'*ones(1,length(test_signal)));
                    end
                    
                    for j=1:no_of_class
                        Y=NewYref{tw_length}(:,:,j);
                        [A,B,r]=canoncorr(test_signal(:,[1:seg_len,Fs+1:Fs+seg_len,2*Fs+1:2*Fs+seg_len,3*Fs+1:3*Fs+seg_len])',Y');
                        mscca_r(sub_band,j)=r(1)*FB_coef0(sub_band);
                        
                        Y=NewYrefa{tw_length}(:,:,j);
                        [A,B,r]=canoncorr(test_signal(:,[1:seg_len,Fs+1:Fs+seg_len,2*Fs+1:2*Fs+seg_len,3*Fs+1:3*Fs+seg_len])',Y');
                        mscca_r2(sub_band,j)=r(1)*FB_coef0(sub_band);
                    end
                    for k=1:4
                        X=test_signal(:,(k-1)*Fs+1:(k-1)*Fs+seg_len);
                        for j=1:n_sti
                            Y=Yref{tw_length}(:,:,j);
                            [A,B,r]=canoncorr(X',Y');
                            cca_r(sub_band,j,k)=r(1)*FB_coef0(sub_band);
                        end
                    end
%                     for j=1:no_of_class
%                         for k=1:4
%                             X=test_signal(:,(k-1)*Fs+1:k*Fs);
%                             Y=NewYrefa{tw_length}(:,(k-1)*Fs+1:k*Fs,j);
%                             [A,B,r]=canoncorr(X',Y');
%                             cca_r(sub_band,j,k)=r(1)*FB_coef0(sub_band);
%                         end
%                     end

%                     old_test_signal(:,:,sub_band)=test_signal;
                end
                MSCCAR=squeeze(sum(mscca_r,1));
%                 MSCCAR=sum((mscca_r).*FB_coef,1);
                [~,idx]=max(MSCCAR);
                if idx==i
                    n_correct(tw_length,3)=n_correct(tw_length,3)+1;
                end
                MSCCAR2=squeeze(sum(mscca_r2,1));
                [~,idx]=max(MSCCAR2);
                if idx==i
                    n_correct(tw_length,2)=n_correct(tw_length,2)+1;
                end
                
                cca_r1=squeeze(sum(cca_r,1));
                for j=1:no_of_class
%                     CCAR(j)=sqrt(cca_r1(j,1)^2+...
%                         cca_r1(j,2)^2+...
%                         cca_r1(j,3)^2+...
%                         cca_r1(j,4)^2);
                    CCAR(j)=sqrt(cca_r1(reqCodeword(j,1)+1,1)^2+...
                        cca_r1(reqCodeword(j,2)+1,2)^2+...
                        cca_r1(reqCodeword(j,3)+1,3)^2+...
                        cca_r1(reqCodeword(j,4)+1,4)^2);
                end
                [~,idx]=max(CCAR);
                if idx==i
                    n_correct(tw_length,1)=n_correct(tw_length,1)+1;
                end
                
                MSCCAR3=MSCCAR+CCAR/4;
                [~,idx]=max(MSCCAR3);
                if idx==i
                    n_correct(tw_length,5)=n_correct(tw_length,5)+1;
                end
                MSCCAR4=MSCCAR2+CCAR/4;
                [~,idx]=max(MSCCAR4);
                if idx==i
                    n_correct(tw_length,4)=n_correct(tw_length,4)+1;
                end
                
                
            end
        end
    end
    %         idx_train_run(run,:)=idx_traindata;
    %         idx_test_run(run,:)=idx_testdata;
    %         seq_0(run,:)=seq1;
    %     end
    
    
    %% Save results
    toc
    accuracy=100*n_correct/no_of_class/length(idx_testdata)
    for tw_length=1:length(TW)
        itr(tw_length,:)=itr_bci(accuracy(tw_length,:)/100,no_of_class,(TW(tw_length)*ones(1,5)+0.5));
    end
    itr
    % column 1: CCA
    % column 2: eCCA
    % column 3: msCCA
    % column 4: eTRCA
    % column 5: ms-eTRCA
    xlswrite('acc_file.xlsx',accuracy'/100,strcat('Sheet',num2str(sn)));
    xlswrite('itr_file.xlsx',itr',strcat('Sheet',num2str(sn)));
    
    disp(sn)
end
% save cnn_data.mat cnn_data

