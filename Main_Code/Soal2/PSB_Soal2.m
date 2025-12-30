% TUGAS BESAR PSB SOAL 2

% File Matlab ini membutuhkan file sebagai berikut,
% 1. dataset 'Dataset_EKG_HR_1000Hz.csv'
% 2. file Matlab 'mynum2str.m'
% 3. file Matlab 'IIC.m'
% 4. file Matlab 'BlandAltman.m'
% di dalam folder yang sama dengan file kode PSB_Soal2.m

% Ketika kode ini dijalankan, banyak figure akan dihasilkan untuk menjadi
% bahan analisis untuk menjawab soal 2a dan 2b sehingga kode Matlab 
% yang digunakan oleh kelompok kami hanyalah satu, yaitu file ini
% PSB_Soal2.m

% -dengan hormat, Kelompok 4 Tugas Besar PSB

clear; 
clc; 
close all;

%% Import data
my_ECG = readmatrix("Dataset_EKG_HR_1000Hz.csv");
% ECG
x = my_ECG(:,1);

% HR
HR = my_ECG(:,2);

% sampling frequency
Fs = 1000;

%% Time domain signals
num_x = length(x);

figure('Color', 'w', 'Name', '2. Sinyal Domain Waktu');
yyaxis left
plot((0:num_x-1)*1/Fs, x);
yyaxis right
plot([0:num_x-1]*1/Fs, HR);

yyaxis left
title('ECG vs Heart Rate')
xlabel('waktu (detik)')
ylabel('ECG (arbitrary unit)')

yyaxis right
ylabel('Heart Rate (bpm)')

%% SOAL 2a

disp(" ");
disp("SOAL 2a"); % judul buat di command window mudah dibaca

% Filter Sinyal ECG
WnHPF = 0.5 / (Fs/2);
WnLPF = 25 / (Fs/2);

[bHPF, aHPF] = butter(2, WnHPF, "high");
[bLPF, aLPF] = butter(4, WnLPF, "low");

s_temp1 = x(:, 1);
s_temp2 = filter(bHPF, aHPF, s_temp1);
s_temp3 = filter(bLPF, aLPF, s_temp1);

% Analisis Dampak Filter Terhadap Komponen PQRST ECG
figure('Color', 'w', 'Name', '2a. PQRST ECG Tanpa Filter');
plot([0:num_x-1]*1/Fs, s_temp1);
title('Sampel Sinyal ECG Pertama')
xlabel('waktu (detik)')
ylabel('ECG (arbitrary unit)')
xlim([0 1]);

figure('Color', 'w', 'Name', '2a. PQRST ECG Setelah Filter HPF');
plot([0:num_x-1]*1/Fs, s_temp2);
title('Sampel Sinyal ECG Pertama')
xlabel('waktu (detik)')
ylabel('ECG (arbitrary unit)')
xlim([0 1]);

figure('Color', 'w', 'Name', '2a. PQRST ECG Setelah Filter LPF');
plot([0:num_x-1]*1/Fs, s_temp3);
title('Sampel Sinyal ECG Pertama')
xlabel('waktu (detik)')
ylabel('ECG (arbitrary unit)')
xlim([0 1]);

s = filter(bLPF, aLPF, s_temp2); % Filter yang diterapkan: HPF -> LPF

% Analisis PSD Sinyal ECG

disp(" ");
disp("Analisis PSD Sinyal ECG");

L = length(s);
t = (0:L-1)/Fs;
N2 = 2^(ceil(log2(L)));

win_rectangular = rectwin(L);
win_hamming = hamming(L);
win_hanning = hann(L);

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '2a. Analisis PSD - Sinyal ECG - Rectangular Window');

% Sinyal Domain Waktu
subplot(2,3,1); 
plot(t, s, 'LineWidth', 0.5);
title('Sinyal ECG');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(2,3,2);
plot(t, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(2,3,3); 
s_win_rectangular = s .* win_rectangular;
plot(t, s_win_rectangular);
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(2,3,4:6); 

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding

tic;
X2 = fft(s_win_rectangular); 
P_full = (abs(X2/L).^2); 
P_temp = P_full(1:N2/2+1);
P_temp(2:end-1) = 2 * P_temp(2:end-1);
f = Fs * (0:(N2/2)) / N2;
plot(f, 10*log10(P_temp), 'LineWidth', 0.5);
title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 Fs/2]); 
grid on;
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
tic;
N2 = 2^(ceil(log2(L)));
X2 = fft(s_win_rectangular, N2); 
P_full = (abs(X2/L).^2); 
P_temp = P_full(1:N2/2+1);
P_temp(2:end-1) = 2 * P_temp(2:end-1);
f = Fs * (0:(N2/2)) / N2;
plot(f, 10*log10(P_temp), 'LineWidth', 0.5);
title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 Fs/2]); 
grid on;
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 5]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '2a. Analisis PSD - Sinyal ECG - Hamming Window');

% Sinyal Domain Waktu
subplot(2,3,1); 
plot(t, s, 'LineWidth', 0.5);
title('Sinyal ECG');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(2,3,2);
plot(t, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(2,3,3); 
s_win_hamming = s .* win_hamming;
plot(t, s_win_hamming);
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(2,3,4:6); 

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding

tic;
X2 = fft(s_win_hamming); 
P_full = (abs(X2/L).^2); 
P_temp = P_full(1:N2/2+1);
P_temp(2:end-1) = 2 * P_temp(2:end-1);
f = Fs * (0:(N2/2)) / N2;
plot(f, 10*log10(P_temp), 'LineWidth', 0.5);
title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 Fs/2]); 
grid on;
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
tic;
N2 = 2^(ceil(log2(L)));
X2 = fft(s_win_hamming, N2); 
P_full = (abs(X2/L).^2); 
P_temp = P_full(1:N2/2+1);
P_temp(2:end-1) = 2 * P_temp(2:end-1);
f = Fs * (0:(N2/2)) / N2;
plot(f, 10*log10(P_temp), 'LineWidth', 0.5);
title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 Fs/2]); 
grid on;
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 5]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '2a. Analisis PSD - Sinyal ECG - Hanning Window');

% Sinyal Domain Waktu
subplot(2,3,1); 
plot(t, s, 'LineWidth', 0.5);
title('Sinyal ECG');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(2,3,2);
plot(t, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(2,3,3); 
s_win_hanning = s .* win_hanning;
plot(t, s_win_hanning);
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(2,3,4:6); 

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding

tic;
X2 = fft(s_win_hanning); 
P_full = (abs(X2/L).^2); 
P_temp = P_full(1:N2/2+1);
P_temp(2:end-1) = 2 * P_temp(2:end-1);
f = Fs * (0:(N2/2)) / N2;
plot(f, 10*log10(P_temp), 'LineWidth', 0.5);
title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 Fs/2]); 
grid on;
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
tic;
N2 = 2^(ceil(log2(L)));
X2 = fft(s_win_hanning, N2); 
P_full = (abs(X2/L).^2); 
P_temp = P_full(1:N2/2+1);
P_temp(2:end-1) = 2 * P_temp(2:end-1);
f = Fs * (0:(N2/2)) / N2;
plot(f, 10*log10(P_temp), 'LineWidth', 0.5);
title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 Fs/2]); 
grid on;
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 5]); 

grid on;

%% SOAL 2b

disp(" ");
disp("SOAL 2b");

% Menentukan Grafik myHR Menggunakan Sliding Windows
window_seconds = 5; 
windowSize = round(window_seconds * Fs);
sampel = 1; 
L = length(s);
myHR = nan(L, 1); 
max_i = floor((L - windowSize) / sampel);
N2_seg = 8192; 

for i = 1:max_i
    j0 = (i-1) * sampel + 1;
    j1 = j0 + windowSize - 1;
    seg_ECG = s(j0:j1);
    L_seg = length(seg_ECG);
    s_win = seg_ECG .* hann(L_seg);
    s_fft = fft(s_win, N2_seg);
    P_full = (abs(s_fft/L_seg).^2);
    P_side = P_full(1:N2_seg/2+1);
    P_side(2:end-1) = 2 * P_side(2:end-1);
    f_axis = Fs * (0:(N2_seg/2)) / N2_seg;
    idx_search = find(f_axis >= 0.5 & f_axis <= 2.5);
    [~, max_idx] = max(P_side(idx_search));
    f_heart = f_axis(idx_search(max_idx));
    target_idx = round((j0 + j1) / 2);
    myHR(target_idx) = f_heart * 60; 
end

% Buang 1 detik awal
HR = HR(1*Fs+1:end);
myHR = myHR(1*Fs+1:end);
num_x_new = length(HR);

% Gambar domain waktu
figure('Color', 'w', 'Name', '2b. Perbandingan HR dan myHR');
hold on;
plot([0:num_x_new-1]*1/Fs, HR,'bo-' );
plot([0:num_x_new-1]*1/Fs, myHR, 'rx-');
legend('HR domain waktu', 'myHR domain frekuensi')
title('HR vs myHR')
xlabel('waktu (detik)')
ylabel('bpm')

% Gambar korelasi
label_HR = {'HR domain waktu', 'myHR domain frekuensi', 'bpm'};
judul = {'Correlation and Bland-Altman Plots'};

BlandAltman(HR, myHR, label_HR, judul);
