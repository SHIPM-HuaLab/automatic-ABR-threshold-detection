%%Plot noramilzed iteration of a wt mice by detecting ABR threshold (1dB SPL steps).
%Author: Haoyu Wang <whaoyu3@hotmail.com>

clear;
addpath('.\function');  %add functions to scritp path
data_name='wt-01.mat';
spl_data_path=['.\mice_res\res_' data_name];
load(spl_data_path);

norm_iter=(num_act_iter-1)/(max(num_act_iter)-1);
scatter(spl(find(is_signal==1)),norm_iter(find(is_signal==1)),'k.','sizedata',600);
hold on;
scatter(spl(find(is_signal==0)),norm_iter(find(is_signal==0)),'ko','sizedata',60);
[f1,gof1]=sigFit(spl,norm_iter);
plot(f1)

xData=0:0.1:90;
yData=f1(xData);
thres=xData(find(yData<=0.9,1,'first'));
disp(gof1);
plot(round(thres)*((0:0.1:1)*0+1),0:0.1:1,'r--')
disp(num_act_iter)
disp(sprintf('threshold is %0.2d dB.',round(thres)))
