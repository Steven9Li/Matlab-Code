% 使用GCCA工具包进行格兰杰因果分析

clear;
clc;

% matla画图脚本

clear;
clc;
load('IRP_CCA.mat');

%   demo parameters
N       =   200;       % number of observations
PVAL    =   0.01;       % probability threshold for Granger causality significance
NLAGS   =   -1;         % if -1, best model order is assessed automatically
Fs      =   250;        % sampling frequency  (for spectral analysis only)
freqs   =   1:50;    % frequency range to analyze (spectral analysis only)

X = IRP;
sfile = 'ccairp.net';
nvar = size(X,1);

% detrend and demean data
disp('detrending and demeaning data');
X = cca_detrend(X);
X = cca_rm_temporalmean(X);

% check covariance stationarity
disp('checking for covariance stationarity ...');
uroot = cca_check_cov_stat(X,10);
% inx = find(uroot);
if sum(uroot) == 0
    disp('OK, data is covariance stationary by ADF');
else
    disp('WARNING, data is NOT covariance stationary by ADF');
    %disp(['unit roots found in variables: ',num2str(inx)]);
end

% check covariance stationarity again using KPSS test
[kh,kpss] = cca_kpss(X);
inx = find(kh==0);
if isempty(inx)
    disp('OK, data is covariance stationary by KPSS');
else
    disp('WARNING, data is NOT covariance stationary by KPSS');
    disp(['unit roots found in variables: ',num2str(inx)]);
end
    
% find best model order
if NLAGS == -1
    disp('finding best model order ...');
    [bic,aic] = cca_find_model_order(X,2,12);
    disp(['best model order by Bayesian Information Criterion = ',num2str(bic)]);
    disp(['best model order by Aikaike Information Criterion = ',num2str(aic)]);
    NLAGS = aic;
end

%-------------------------------------------------------------------------
% analyze time-domain granger

% find time-domain conditional Granger causalities [THIS IS THE KEY FUNCTION]
disp('finding conditional Granger causalities ...');
ret = cca_granger_regress(X,NLAGS,1);   % STATFLAG = 1 i.e. compute stats

% check that residuals are white
dwthresh = 0.05/nvar;    % critical threshold, Bonferroni corrected
waut = zeros(1,nvar);
for ii=1:nvar
    if ret.waut<dwthresh
        waut(ii)=1;
    end
end
inx = find(waut==1);
if isempty(inx)
    disp('All residuals are white by corrected Durbin-Watson test');
else
    disp(['WARNING, autocorrelated residuals in variables: ',num2str(inx)]);
end

% check model consistency, ie. proportion of correlation structure of the
% data accounted for by the MVAR model
if ret.cons>=80
    disp(['Model consistency is OK (>80%), value=',num2str(ret.cons)]);
else
    disp(['Model consistency is <80%, value=',num2str(ret.cons)]);
end
        
% analyze adjusted r-square to check that model accounts for the data (2nd
% check)
rss = ret.rss_adj;
inx = find(rss<0.3);
if isempty(inx)
    disp(['Adjusted r-square is OK: >0.3 of variance is accounted for by model, val=',num2str(mean(rss))]);
else
    disp(['WARNING, low (<0.3) adjusted r-square values for variables: ',num2str(inx)]);
    disp(['corresponding values are ',num2str(rss(inx))]);
    disp('try a different model order');
end

% find significant Granger causality interactions (Bonferonni correction)
[PR,q] = cca_findsignificance(ret,PVAL,1);
disp(['testing significance at P < ',num2str(PVAL), ', corrected P-val = ',num2str(q)]);

% extract the significant causal interactions only
GC = ret.gc;
GC2 = GC.*PR;

% calculate causal connectivity statistics
disp('calculating causal connectivity statistics');
causd = cca_causaldensity(GC,PR);
causf = cca_causalflow(GC,PR);

disp(['time-domain causal density = ',num2str(causd.cd)]);
disp(['time-domain causal density (weighted) = ',num2str(causd.cdw)]);

% create Pajek readable file
cca_pajek(PR,GC,sfile);

%-------------------------------------------------------------------------
% plot time-domain granger results
figure(1); clf reset;
FSIZE = 8;
colormap(flipud(bone));

% plot granger causalities as matrix
% subplot(121);
% set(gca,'FontSize',FSIZE);
% imagesc(GC);
% axis('square');
% set(gca,'Box','off');
% title(['Granger causality, p<',num2str(PVAL)]);
% xlabel('from');
% ylabel('to');
% set(gca,'XTick',[1:N]);
% set(gca,'XTickLabel',1:N);
% set(gca,'YTick',[1:N]);
% set(gca,'YTickLabel',1:N);
% 
% % plot granger causalities as a network
% subplot(122);
cca_plotcausality(GC2',[],5);


%-------------------------------------------------------------------------

% %% 获得ICA数据
% %导入必备的数据文件
% load('Data\Img_IRP.mat');
% %load('data\music_erp.mat');        % ERP数据文件
% load('data\labels.mat');            % 电极信息文件
% load('data\featureStr.mat');        % 特征信息文件
% load('small_channal_Index.mat');    % 电极排布的信息文件
% 
% stmi_index = 1;
% channal_num = 62;
% epoch_sum = zeros(62,300);
% epoch_sum2 = zeros(62,300);
% 
% % 视觉
% for sub_index = 1:7
%     for k=1:7
%         epoch_sum = epoch_sum + Img_IRP{sub_index,stmi_index+k-1};
%         epoch_sum2 = epoch_sum2 + Img_IRP{sub_index,stmi_index+7+k-1};
%     end
% end
% 
% epoch_sum = epoch_sum/49;
% epoch_sum2 = epoch_sum2/49;
% 
% loc_num = 62;
% simple_channal_num = 13;
% epoch_sum_t = zeros(simple_channal_num,300);
% epoch_sum2_t = zeros(simple_channal_num,300);
% for i = 1:simple_channal_num
%     for j = 2:4
%         epoch_sum_t(i,:) = epoch_sum_t(i,:) + epoch_sum(small_channal_index(i,j),:);
%         epoch_sum2_t(i,:) = epoch_sum2_t(i,:) + epoch_sum2(small_channal_index(i,j),:);
%     end
% end
% 
% epoch_sum = epoch_sum_t/3;
% epoch_sum2 = epoch_sum2_t/3;
% 
% IRP = epoch_sum2 - epoch_sum;
% IRP = IRP(:,101:300);

