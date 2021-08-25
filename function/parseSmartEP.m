function [ABR, time] = parseSmartEP(inputDir,outputFilename)
%PARSESMARTEP: Parse the text file recorded from SmartEP to .mat file
%   The function has the following arguments:
%   INPUT inputDir: string
%               the direction contains all SmartEP text files.
%           outputFilename: (Optional) string
%               the filename saved as a .mat file in the inputDir.
%
%   OUTPUT time: [1xN] double 
%               a timeline sampled from the text records.
%           ABR: [1xN] struct
%               sort ABR sweeps from descending SPL.
%Author: Haoyu Wang <whaoyu3@hotmail.com>

if ispc()
    path=[inputDir '\'];
elseif isunix()
    path=[inputDir '/'];
end

filenames=dir([path '*db.TXT']);    %read all text files including ABR records

for j =1:length(filenames)
    data_t=[];
    [A,delimiterOut,hearlinesOut]=importdata([path filenames(j).name],',',21);
    intensity_temp=str2double(string(split(A.textdata{6,1},',')));
    intensity=intensity_temp(find(~isnan(intensity_temp)));
    sweeps_temp=str2double(string(split(A.textdata{9,1},',')));
    sweeps=sweeps_temp(find(~isnan(sweeps_temp)));
    sampStr=str2double(string(split(A.textdata{11,1},',')));
    sampP=sampStr(find(~isnan(sampStr),1,'first'))/1e3;
    zeroPStr=str2double(string(split(A.textdata{20,1},',')));
    zeroP=zeroPStr(find(~isnan(zeroPStr),1,'first'));
    ave_pos=find(string(A.colheaders)=="Average(uV):");    
    data_tmp=A.data(zeroP:end,ave_pos);
    numRecord=length(intensity);
    [sweeps_sorted,idx_sort]=sort(sweeps);
    data_tmp=data_tmp(:,idx_sort);
    data_t(:,1:6)=data_tmp(:,1:6);
    data_t(:,7:9)=(data_tmp(:,randperm(3))+data_tmp(:,randperm(3)+3)*2)/3;  %random weighted averaging 1500 sweeps
    data_t(:,10:12)=data_tmp(:,7:9);
    data_t(:,13:15)=(data_tmp(:,randperm(3))+data_tmp(:,randperm(3)+6)*4)/5;%random weighted averaging 2500 sweeps
    data_t(:,16:18)=(data_tmp(:,randperm(3)+3)*2+data_tmp(:,randperm(3)+6)*4)/6;%random weighted averaging 3000 sweeps
    data_t(:,19:21)=(data_tmp(:,randperm(3))+data_tmp(:,randperm(3)+3)*2+data_tmp(:,randperm(3)+6)*4)/7;%random weighted averaging 3500 sweeps
    data(j).intensity=intensity(1);
    data(j).wave=data_t;
    data(j).sweeps=[sweeps_sorted(1:6);1500;1500;1500;2000;2000;2000;2500;2500;2500;3000;3000;3000;3500;3500;3500];
    data(j).sampP=sampP;
    k=(65-intensity(1))/5;
    ABR(k).intensity=intensity(1);
    ABR(k).sweeps=data(j).sweeps;
    ABR(k).sampP=sampP;
    ABR(k).p=data_t';
end

time=0:sampP:(size(data_t,1)-1)*sampP;  %set the timeline

if exist('outputFilename')
    save([path outputFilename '.mat'],'time','ABR') %save timeline & ABR records as .mat file
end

end

