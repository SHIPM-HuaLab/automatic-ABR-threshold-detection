%%Plot noramilzed iteration of a wt mice by detecting ABR threshold (1dB SPL steps).
%Author: Haoyu Wang <whaoyu3@hotmail.com>

clear;
addpath('.\function');  %add functions to scritp path
data_name='1dB.mat';    
spl_data_path=['.\micedata\1dB\res' data_name];
load(spl_data_path);        %

norm_iter=(num_act_iter-1)/(max(num_act_iter)-1);
scatter(spl(find(is_signal==1)),norm_iter(find(is_signal==1)),'k.','sizedata',600);
hold on;
scatter(spl(find(is_signal==0)),norm_iter(find(is_signal==0)),'ko','sizedata',60);
[f1,gof1]=sigFit(spl,norm_iter);
plot(f1)

xData=0:0.1:90;
yData=f1(xData);
thres=xData(find(yData<=0.9,1,'first'));
plot(thres*((0:0.1:1)*0+1),0:0.1:1,'k-.')
spl_sel=spl(1:10);
norm_iter_sel=norm_iter(1:10);
disp(sprintf('threshold is %0.2d dB',round(thres))); %show the result of ABR threshold

[f4,gof4]=expFit(spl_sel,norm_iter_sel);
x=24.5:0.1:35;

% f2=@(x)(exp(-0.6*(x-26)));
% f3=@(x)(1/(1+exp(0.6*(x-28.82))));
% 
% for i =1:length(x)
%     y1(i)=f3(x(i));
%     y2(i)=f2(x(i));
% end
% plot(x,y1);
% plot(x,y2);
plot(x,f4(x),'r--')
ylim([0,1])
xlim([15,40])