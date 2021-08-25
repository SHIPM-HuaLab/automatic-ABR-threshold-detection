function  [filter_signal,time]=filterMiceABR(inputDir,outputDir)
%FILTERMICEABR exclude large fluctuation and baseline subtraction
%   The function has the following arguments:
%   INPUT inputDir: string
%               the direction contains all spl**.mat files.
%           outputDir:  string
%               the direction will sav as a .mat file.
%
%   OUTPUT filter_signal: [1xN] struct
%               sort ABR sweeps from descending SPL.
%          time: [1xN] double 
%               a timeline sampled at 0.041 ms.
%           
%Written by Yunfeng Hua <yunfeng.hua@outlook.com>
%           Haoyu Wang <whaoyu3@hotmail.com>

if ispc()
    path=[inputDir '\'];
    outputPath=[outputDir '\'];
elseif isunix()
    path=[inputDir '/'];
    outputPath=[outputDir '/'];
end

filename = dir([path 'spl*.mat']);
load([path filename(1).name]);

time = 0:14.9914/(length(ABR(1).p)-1):14.9914; % get the timeline, default timeline: 0-15ms,sampled by 0.041ms
exclude = 5.5e-5; % exclude recordings having large fluctuation
for j = 1:length(filename)
    level=str2double(filename(j).name(4:5))
    load([path filename(j).name]);
    count=0;
    for i = length(ABR):-1:1
        if ~isempty(ABR(i).p) && length(ABR(i).p)==366
            if max(ABR(i).p)<exclude&&min(ABR(i).p)>-exclude
                count = count + 1;
                tmp = ABR(i).p;
                f = fit(time',tmp,'smoothingspline','SmoothingParam',0.5); %baseline subtraction
                yfit = f(time);
                sABR(count,:) = tmp - yfit; 
            end
        end
    end
    data(j).spl=level;
    data(j).time=time;
    data(j).sABR=sABR;
    clear sABR;
end
[~,index] = sortrows([data.spl].'); data = data(index(end:-1:1)); clear index;
for j=1:length(data)
    filter_signal(j).spl=data(j).spl;
    filter_signal(j).active_num=length(data(j).sABR);
    filter_signal(j).data=data(j).sABR;
end
data_name=path(end-5:end-1);
save([outputPath path(end-5:end-1) '.mat'],'data_name','filter_signal','time');

end

