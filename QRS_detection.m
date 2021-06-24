[filename,pathname] = uigetfile('*.*','Select the ECG Signal'); % To get the dataset
filewithpath = strcat(pathname,filename);
Fs = input('Enter Sampling Rate: ');

ecg = load(filename); % Reading ECG signal
ecgsig = (ecg.val)./200; % Normalize Gain
t = 1:length(ecgsig); % Number of samples
tx = t./Fs; % Getting Time vector in seconds

wt = modwt(ecgsig,4,'sym4'); % 4-level undecimated DWT using sym4
wtrec = zeros(size(wt)); % Initializing variable 
wtrec(3:4,:) = wt(3:4,:); % Extracting only d3 & d4 coefficients

y = imodwt(wtrec,'sym4'); %IDWT with only d3 and d4
y = abs(y).^2;% Magnitude square

avg=mean(y); %Getting average of y^2 as threshold

[Rpeaks,locs] = findpeaks(y,t,'MinPeakHeight',8*avg,'MinPeakDistance',50);
nohb = length(locs); % number of heart beats
timelimit = length(ecgsig)/Fs; 
hbpm = (nohb * 60)/timelimit;% Getting BPM
disp(strcat('Heart Rate = ',num2str(hbpm)))
% Plotting ECG and R- Peaks detection %
subplot(211)
plot(tx,ecgsig)

xlim([0,timelimit]);
grid on;
xlabel('seconds')
title('ECG signal')

subplot(212)
plot(t,y)
grid on;
xlim([0,length(ecgsig)]);
hold on
plot(locs,Rpeaks,'ro')%R-peaks with Red dot
xlabel('Samples')
title(strcat('R peaks found and Heart rate: ',num2str(hbpm)))


