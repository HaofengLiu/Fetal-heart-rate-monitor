% Fast Independent Component Analysis (FastICA)
%
% Five files can be used, but the '08' data is bad, so the performance is the worst one.
% To change the file, first  -> Change the load file (line 14)
%                     second -> Base on output signal, select the best performance channel 
%                               and modify 'Baseline shift part', generally,
%                               it should be channel 4 (line 30)
%
% Author: Haofeng Liu 
%% Strart part
% Load heartrate signal and build orginal data, you can use function
% 'plotATM' to plot reference data directly.
clear;
load ('r04_edfm');                    % The fetal heartrate signal
signal_1 = val(2,:)/10;               % First channel of the signal, the gain of the 
                                      % cited signal is 10, so we need to divide it.(in the '.info file')
signal_2 = val(3,:)/10;               % Second
signal_3 = val(4,:)/10;               % Third
signal_4 = val(5,:)/10;               % Fourth

%% Prepare part
Signal = [signal_1;signal_2;signal_3;signal_4];  % Use four signals to build original signal matrix
Plot('Original signal',Signal);                  % Plot original signals

%% Fast ICA part
Output = FastICA(Signal);                        % Do the fast ICA
Plot('Output signal',Output);                    % Plot ouput signal

%% Baseline shift part
out = Output(4,:);                               % Select one channel of the output signal
Baseline_drift(out);                             % Eliminate baseline drift interference