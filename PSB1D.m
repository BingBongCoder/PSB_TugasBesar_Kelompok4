% TUGAS BESAR PSB - 1D Audio Filter dan Pemutaran
clear; 
clc; 
[x, Fs] = audioread('kereta.aac');

% Gunakan saluran pertama (kiri) jika stereo
if size(x, 2) > 1
    s = x(:,1);
else
    s = x;
end

%Parameter Filter
f_tooot = 554.48; % Frekuensi fundamental tooot
f_teeet = 759.045; % Frekuensi fundamental teeet
bw = 50; % Bandwidth (kurang lebih 50Hz)
orde_butter = 4; % Orde filter Butterworth

% Normalisasi frekuensi dengan Nyquist (Fs/2)
wn_tooot = [(f_tooot - bw), (f_tooot + bw)]/(Fs/2);
wn_teeet = [(f_teeet - bw), (f_teeet + bw)]/(Fs/2);

%  frekuensi dalam rentang [0, 1]
wn_tooot = max(min(wn_tooot, 1), 0);
wn_teeet = max(min(wn_teeet, 1), 0);

%Filter Butterworth Bandpass
[b_tooot,a_tooot]= butter(orde_butter,wn_tooot,'bandpass');
[b_teeet,a_teeet]= butter(orde_butter,wn_teeet,'bandpass');

y_tooot= filtfilt(b_tooot, a_tooot, s);%Filter diterapkan ke sinyal
y_teeet= filtfilt(b_teeet, a_teeet, s);

%Plot sinyal setelah difilter
figure('Name', 'Sinyal Hasil Filter', 'Color', 'w');
subplot(3,1,1);
plot((0:length(s)-1)/Fs, s);
title('Sinyal Asli');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

subplot(3,1,2);
plot((0:length(y_tooot)-1)/Fs, y_tooot);
title('Sinyal "tooot" (554.48 Hz +/- 50 Hz)');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

subplot(3,1,3);
plot((0:length(y_teeet)-1)/Fs, y_teeet);
title('Sinyal "teeet" (759.045 Hz +/- 50 Hz)');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

%Pemutaran sinyal hasil filter
disp('Pemutaran sinyal "tooot"'); %Pemutaran sinyal tooot
sound(y_tooot, Fs);
pause(length(y_tooot)/Fs + 0.5);%Jeda ke pemutaran sinyal teeet
disp('Pemutaran sinyal "teeet"');
sound(y_teeet, Fs);


