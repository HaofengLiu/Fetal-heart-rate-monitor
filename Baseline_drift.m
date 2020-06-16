% Using morphology to eliminate the interference of baseline drift
% [QRS], [T and P waves] are extracted by open and close operations separately
% By setting different value of length, it will have different performance
%
% Author: Haofeng Liu 

function out = Baseline_drift(in)
%%
%-----------QRS wave extraction---------%
seA = strel('line', 20, 0);  % Set to linear, length 20, angle 0
fo = imopen(in, seA);
fc = imclose(in, seA);
foc = imclose(fo, seA); 
fco = imopen(fc, seA);
xb2 = floor((foc + fco)/2);
QRSx = in - xb2;

%%
%---------P and T wave extraction-------%
seB = strel('line', 45, 0);  % Set to linear, length 45, angle 0
fo = imopen(xb2, seB);
fc = imclose(xb2, seB);
foc = imclose(fo, seB); 
fco = imopen(fc, seB);
xc = floor((foc + fco)/2);        
TPx = xb2- xc;

%% Output and plot
out = QRSx + TPx;

figure;
subplot(2,1,1);
plot(in);
title('Original signal')
xlabel('Sampling point');
ylabel('Amplitude (uV)');

subplot(2,1,2);
plot(out);
title('Improved signal')
xlabel('Sampling point');
ylabel('Amplitude (uV)');