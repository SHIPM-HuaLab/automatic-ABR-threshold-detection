%Group averaging of detecting mice ABR threshold by decsencing 1dB SPL.
%Author: Haoyu Wang <whaoyu3@hotmail.com>

clear;
addpath('.\function');  %add functions to scritp path
data_name='filter_1dB.mat';
spl_data_path=['.\micedata\1dB\' data_name];
load(spl_data_path);

step_group=20;
max_data=step_group*3*7;

for j=1:length(filter_signal)
    data=filter_signal(j).data;
    data=data(randperm(length(data)),:);
    for i =1:3
        data_group(j).step_data(i).data=data((i-1)*140+1:i*140,:);
    end
end
steps=1:7;
spl=double([filter_signal.spl]);
for j=1:length(filter_signal)
    for i =1:3
        for k=steps
            data_step_mean(j,k).data(i,:)=mean(data_group(j).step_data(i).data(1:k*20,:));
        end
    end
end
save(['.\1dB\group_' data_name], 'data_name','time','filter_signal','steps','spl','data_step_mean','data_group');