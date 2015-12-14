[ori_y,fs] = audioread('original.wav');
disp(fs)
N = length(ori_y);

% Original time domain
figure(1);
t = 1/fs:1/fs:N/fs;
plot(t,ori_y); 

% Original freq domain
figure(2);
f = linspace(-fs/2,fs/2,N);
ori_Y = fft(ori_y,N);
plot(f,fftshift(abs(ori_Y)));

[scr_y,fs] = audioread('scrambled.wav');
N = length(scr_y);

% Scrambled time domain
figure(3);
t = 1/fs:1/fs:N/fs;
plot(t,scr_y);

% Scrambled freq domain
figure(4);
f = linspace(-fs/2,fs/2,N);
scr_Y = fft(scr_y,N);
plot(f,fftshift(abs(scr_Y))); 
[pk,MaxFreq] = findpeaks(fftshift(abs(scr_Y)),'NPeaks',1,'SortStr','descend');
hold on
plot(f(MaxFreq),pk,'or')
hold off
Freq = f(MaxFreq)

% Low-pass filter
h  = fdesign.lowpass('Fp,Fst,Ap,Ast', 7000, 7500, 1, 60, fs);
Hd = design(h, 'butter');

% Remove 8kHz tone
scr_y_lp = filter(Hd, scr_y);

% Scrambled * 7kHz
sine = sin(2*pi*7000*t).';
scr_y_sin = scr_y_lp .* sine;

% Remove upper frequencies
scr_y_sin_lp = filter(Hd, scr_y_sin);

% Unscrambled freq domain
figure(5);
f = linspace(-fs/2,fs/2,N);
scr_Y_sin = fft(scr_y_sin_lp,N);
plot(f,fftshift(abs(scr_Y_sin))); 

% Play unscrambled sound
sound(scr_y_sin_lp, fs)

