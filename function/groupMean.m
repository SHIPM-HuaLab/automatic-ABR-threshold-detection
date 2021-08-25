function  groupMean(data_file,outputDir,group_num)
%GROUPMEAN seperate sweeps to different steps and groups by the algo 
%   The function has the following arguments:
%   INPUT data_file: string
%               filtered mice ABR sweeps saved by function filterMiceABR.m
%               file formate (.mat)
%           outputDir:  string
%               the direction will sav as a .mat file.
%           group_num: (default 20)double
%               each iteration will add 20 sweeps to average.
%   See also filterMiceABR.   
%Written by Haoyu Wang <whaoyu3@hotmail.com>

if ispc()
    
    outputPath=[outputDir '\'];
elseif isunix()

    outputPath=[outputDir '/'];
end

load(data_file);

step_group=group_num;
max_data=step_group*3*7;

for j=1:length(filter_signal)
    data=filter_signal(j).data;
    data=data(randperm(length(data)),:);
    for i =1:3
        data_group(j).step_data(i).data=data((i-1)*140+1:i*140,:);
    end
end
steps=1:7;
spl=[filter_signal.spl];
for j=1:length(filter_signal)
    for i =1:3
        for k=steps
            data_step_mean(j,k).data(i,:)=mean(data_group(j).step_data(i).data(1:k*20,:));
        end
    end
end
save([outputPath 'grouped_' data_name], ...
    'data_name',...
    'time',...
    'filter_signal',...
    'steps',...
    'spl',...
    'data_step_mean',...
    'data_group');
end

