function [fitresult, gof] = sigFit(dB, value)
%SIGFIT 
%  Create a sigmoid fit.
%
%  Input
%      X Input : dB
%      Y Output: value
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.
%Edited by Haoyu Wang <whaoyu3@hotmail.com>

%  Auto-generated by MATLAB on 27-Mar-2019 16:20:39



[xData, yData] = prepareCurveData( dB, value );

% Set up fittype and options.
ft = fittype( '1/(1+exp(0.6*(x-c)))', 'independent', 'x', 'dependent', 'y' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = 20;

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
% figure( 'Name', 'untitled fit 1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'ans vs. dB', 'untitled fit 1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % Label axes
% xlabel( 'dB', 'Interpreter', 'none' );
% ylabel( 'ans', 'Interpreter', 'none' );
% grid on

