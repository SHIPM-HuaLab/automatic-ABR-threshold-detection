function [lagIdx,res,lag,corrcoefm] = cross_test_3signal_human(signals)
%CROSS_TEST_3SIGNAL_HUMAN calculate 3 averaged ABR signals and 2-by-2 xcorr
%   The function has the following arguments:
%   INPUT signals: [3xN] double
%               3 averaged ABR signals.
%
%   OUTPUT lagIdx: [1x3] double 
%               a timeline sampled from the text records.
%           res: double
%               result of #(abs(lag)<1% data window).
%           lag: [1x3] double
%               3 lags of 2-by-2 xcorr in 3 signals.
%           corrcoefm: [1x3] double
%               3 corraltion coeffience of 2-by-2 signals.
%Author: Haoyu Wang <whaoyu3@hotmail.com>

xc12=xcorr(signals(1,:),signals(2,:));
[~,lag(1)]=max(xc12);
cc1=corrcoef(signals(1:2,:)');
corrcoefm(1)=cc1(find(triu(cc1,1)~=0));

xc23=xcorr(signals(2,:),signals(3,:));

[~,lag(2)]=max(xc23);

cc1=corrcoef(signals(2:3,:)');
corrcoefm(2)=cc1(find(triu(cc1,1)~=0));

xc13=xcorr(signals(1,:),signals(3,:));
[~,lag(3)]=max(xc13);

cc1=corrcoef(signals([1,3],:)');
corrcoefm(3)=cc1(find(triu(cc1,1)~=0));


lagIdx = find(abs(lag-size(signals,2))<=round(size(signals,2)/50));
res = length(lagIdx);
lag=abs(lag-length(signals));

end
