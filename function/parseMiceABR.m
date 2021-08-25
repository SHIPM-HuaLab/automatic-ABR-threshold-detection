function parseMiceABR(inputDir)
%PARSEMICEABR: Parse the text file of mice records to sperate .mat file
%named 'SPL**.mat'
%   The function has the following arguments:
%   INPUT inputDir: string
%               the direction contains all text files.
%Written by Yunfeng Hua <yunfeng.hua@outlook.com>

if ispc()
    path=[inputDir '\'];
elseif isunix()
    path=[inputDir '/'];
end

fclose('all');
filenames = dir([path '*.txt']);
for i = 1:length(filenames)
    filenames(i).name
    fileID = fopen([path filenames(i).name]);
    Num = cell2mat(textscan(fileID,'Records: %d','HeaderLines',2));
    textscan(fileID,'','HeaderLines',9); %move to first recordings
    for i = 1:Num %parse data
        ABR(i).RecID = cell2mat(textscan(fileID,'Record Number: %d'));
        ABR(i).FrameRate = cell2mat(textscan(fileID,'Aqu. Duration: %d ms'));
        ABR(i).SPL = cell2mat(textscan(fileID,'Level = %d dB','HeaderLines',9));
        ABR(i).p = cell2mat(textscan(fileID,'%f\t','HeaderLines',4));
    end
    fclose(fileID);
    savefile = [path sprintf('spl%0.2d.mat',ABR(1).SPL)];
    if exist(savefile)
        tmp = ABR;
        load(savefile);
        ABR(length(ABR)+1:length(ABR)+length(tmp)) = tmp;
        clear tmp
        save(savefile,'ABR')
    else
        save(savefile,'ABR');
    end
    clear ABR;
end
end

