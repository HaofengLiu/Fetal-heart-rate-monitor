% This function is use 'subplot' to plot some figures, just for convenience
function Plot(signalName,signal)

figure('NumberTitle', 'off', 'Name', signalName);
Number = size(signal,1);
set(gcf,'unit','centimeters','position',[20 5 25 12]);

for count = 1:Number
    subplot(Number,1,count);
    plot(signal(count,:));
    xlabel('Sampling point');
    ylabel('Amplitude (uV)');
end