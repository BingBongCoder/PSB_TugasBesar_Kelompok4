% TUGAS BESAR PSB SOAL 1

% File Matlab ini membutuhkan File Audio 'kereta.aac' di dalam folder
% yang sama dengan file kode PSB_Soal1.m

% Ketika kode ini dijalankan, banyak figure akan dihasilkan untuk menjadi
% bahan analisis untuk menjawab soal 1a hingga 1d sehingga kode Matlab 
% yang digunakan oleh kelompok kami hanyalah satu, yaitu file ini
% PSB_Soal1.m

% Selain dari menghasilkan figure, 8 file audio mp3 akan dihasilkan dalam
% folder yang sama dengan file kode PSB_Soal1.m

% -dengan hormat, Kelompok 4 Tugas Besar PSB

clear;
clc;
close all;

%% SOAL 1a

disp(" ");
disp("SOAL 1a"); % judul buat di command window mudah dibaca

% Baca File Audio
[x, Fs] = audioread('kereta.aac');
n = length(x);
t = (0:n-1) / Fs;

% Memeriksa Apakah Audio Speaker Kiri Sama dengan Audio Speaker Kanan
KananKiriEqual = isequal(x(:,1), x(:,2));
disp(" ");
if(KananKiriEqual)
    disp("Audio speaker kanan dan kiri sama");
else
    disp("Audio speaker kanan dan kiri tidak sama");
end

% Membuat Sinyal Domain Waktu
figure('Color', 'w', 'Name', '1a. Analisis Domain Waktu');
if(KananKiriEqual)
    plot(t, x(:,1));
    title('Sinyal Domain Waktu Suara Kereta');
    xlabel('Waktu (t), Satuan Detik');
    ylabel('Amplitudo [x(t)]');
else
    subplot(2,1,1);
    plot(t,x(:,1));
    title('Sinyal Domain Waktu Suara Kereta Speaker Kiri');
    xlabel('Waktu (t), Satuan Detik');
    ylabel('Amplitudo [x(t)]');
    subplot(2,1,2);
    plot(t,x(:,1));
    title('Sinyal Domain Waktu Suara Kereta Speaker Kanan');
    xlabel('Waktu (t), Satuan Detik');
    ylabel('Amplitudo [x(t)]');
end

%% SOAL 1b

disp(" ");
disp("SOAL 1b");

s = x(:,1); 

% Analisis PSD Sinyal "teeet"

disp(" ");
disp("Analisis PSD Sinyal teeet");

durasi = 0.9169985714; 

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts = [1.60646, 3.43342, 5.26565, 7.08896, 8.91415, 10.7427, ...
            12.5639, 14.3965, 16.2361, 18.0407, 19.8694, 21.6945, ...
            23.525, 25.3521]; 

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD Sinyal "tooot"

disp(" ");
disp("Analisis PSD Sinyal tooot");

durasi = 0.9094676; 

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts = [0.695306, 2.52227, 4.35088, 6.17624, 8.00308, 9.82995, ...
            11.6568, 13.4838, 15.3159, 17.1375, 18.9644, 20.7913, ...
            22.6182, 24.4451, 26.2721];

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tooot" - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tooot" - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tooot" - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD Sinyal "teeet" "tooot"

disp(" ");
disp("Analisis PSD Sinyal teeet tooot");

durasi = 1.826345714;

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts = [1.60646, 3.43342, 5.26565, 7.08896, 8.91415, 10.7427, ...
            12.5639, 14.3965, 16.2361, 18.0407, 19.8694, 21.6945, ...
            23.525, 25.3521];

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" "tooot" - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" "tooot" - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" "tooot" - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD Sinyal "tet" "tot"

disp(" ");
disp("Analisis PSD Sinyal tet tot");

durasi = 0.05;

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts_tet = [1.60646, 3.43342, 5.26565, 7.08896, 8.91415, 10.7427, ...
                12.5639, 14.3965, 16.2361, 18.0407, 19.8694, 21.6945, ...
                23.525, 25.3521];
t_starts_tot = [0.695306, 2.52227, 4.35088, 6.17624, 8.00308, 9.82995, ...
                11.6568, 13.4838, 15.3159, 17.1375, 18.9644, 20.7913, ...
                22.6182, 24.4451, 26.2721];

t_starts = [t_starts_tet, t_starts_tot];

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tet" "tot" - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tet" "tot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tet" "tot" - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tet" "tot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tet" "tot" - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tet" "tot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD Sinyal "teeet" Satu Segmen

disp(" ");
disp("Analisis PSD Sinyal teeet Satu Segmen");

durasi = 0.9169985714; 

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts = [1.60646];

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" Satu Segmen - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" Satu Segmen - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "teeet" Satu Segmen - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "teeet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD Sinyal "tooot" Satu Segmen

disp(" ");
disp("Analisis PSD Sinyal tooot Satu Segmen");

durasi = 0.9094676; 

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts = [0.695306];

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tooot" Satu Segmen - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tooot" Satu Segmen - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tooot" Satu Segmen - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tooot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD Sinyal "tet" Satu Segmen

disp(" ");
disp("Analisis PSD Sinyal tet Satu Segmen");

durasi = 0.05;

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts = [1.60646];

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tet" Satu Segmen - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tet" Satu Segmen - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tet" Satu Segmen - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD Sinyal "tot" Satu Segmen

disp(" ");
disp("Analisis PSD Sinyal tot Satu Segmen");

durasi = 0.05;

% Deklarasi Window
win_rectangular = rectwin(round(durasi*Fs) + 1);
win_hamming = hamming(round(durasi*Fs) + 1);
win_hanning = hann(round(durasi*Fs) + 1);

t_starts = [0.695306];

% Analisis PSD dengan Rectangular Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tot" Satu Segmen - Rectangular Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Rectangular Window
subplot(3,3,2);
plot((0:length(win_rectangular)-1)/Fs, win_rectangular, 'r', 'LineWidth', 1.5);
title('Fungsi Rectangular Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_rectangular = s(idx) .* rectwin(length(s(idx)));
    plot((0:length(seg_win_rectangular)-1)/Fs, seg_win_rectangular, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Rectangular Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* rectwin(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* rectwin(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hamming Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tot" Satu Segmen - Hamming Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hamming Window
subplot(3,3,2);
plot((0:length(win_hamming)-1)/Fs, win_hamming, 'r', 'LineWidth', 1.5);
title('Fungsi Hamming Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hamming = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win_hamming)-1)/Fs, seg_win_hamming, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hamming Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hamming(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hamming(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Analisis PSD dengan Hanning Window

figure('Color', 'w', 'Name', '1b. Analisis PSD - Sinyal "tot" Satu Segmen - Hanning Window');

% Sinyal Domain Waktu
subplot(3,3,1); 
hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['Sinyal "tot" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Fungsi Hanning Window
subplot(3,3,2);
plot((0:length(win_hanning)-1)/Fs, win_hanning, 'r', 'LineWidth', 1.5);
title('Fungsi Hanning Window');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Sinyal Hasil Windowing
subplot(3,3,3); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win_hanning = s(idx) .* hann(length(s(idx)));
    plot((0:length(seg_win_hanning)-1)/Fs, seg_win_hanning, 'Color', colors(i,:));
end
title('Sinyal Hasil Windowing');
xlabel('Waktu (detik)'); 
ylabel('Amplitudo'); 
grid on;

% Spektrum Tunggal
subplot(3,3,4:6); 
hold on;

disp(" ");
disp("FFT dengan Hanning Window");

% tanpa Zero Padding
P_total = [];

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    L = length(x_seg);
    x_win = x_seg .* hann(L); 
    X1 = fft(x_win);
    P2 = (abs(X1/L).^2); 
    P1 = P2(1:floor(L/2)+1);
    P1(2:end-1) = 2 * P1(2:end-1);
    f_seg = Fs * (0:floor(L/2)) / L;
    plot(f_seg, 10*log10(P1), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total)
        P_total = P1;
    else
        P_total = P_total + P1;
    end
end
disp("Waktu FFT tanpa zero padding = " + string(toc) + " detik");

% dengan Zero Padding
P_total = [];
L = length(round(t_starts(1)*Fs) : round((t_starts(1)+durasi)*Fs)); 
N2 = 2^(ceil(log2(L)));

tic;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    x_seg = s(idx);
    x_win = x_seg .* hann(length(x_seg));
    X2 = fft(x_win, N2); 
    P_full = (abs(X2/L).^2); 
    P_temp = P_full(1:N2/2+1);
    P_temp(2:end-1) = 2 * P_temp(2:end-1);
    f = Fs * (0:(N2/2)) / N2;
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    if isempty(P_total) 
        P_total = P_temp; 
    else 
        P_total = P_total + P_temp; 
    end
end
disp("Waktu FFT dengan zero padding = " + string(toc) + " detik");

title('Spektrum Tunggal');
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

% Spektrum Rata-Rata
subplot(3,3,7:9);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['Spektrum Rata-Rata']);
xlabel('Frekuensi (Hz)'); 
ylabel('Power (dB)'); 
xlim([0 2500]); 
grid on;

%% SOAL 1c

disp(" ");
disp("SOAL 1c");

orde = 4;
orde_fir1 = 1000;
Rp = 0.5;
resolusi_resp_frek = 32768;
impulse_signal = [1, zeros(1, 3000)];
impulse_signal_fir1 = [1, zeros(1, 600)];
bandwidth = 80;
r = 1 - (bandwidth/Fs * pi);

% Desain Filter Sinyal "teeet"

disp(" ");
disp("Desain Filter Sinyal teeet")

% Parameter Filter
f_teeet = [758.372, 1516.74, 2275.12];

f_low_teeet1 = f_teeet(1) - bandwidth/2;
f_high_teeet1 = f_teeet(1) + bandwidth/2;

f_low_teeet2 = f_teeet(2) - bandwidth/2;
f_high_teeet2 = f_teeet(2) + bandwidth/2;

f_low_teeet3 = f_teeet(3) - bandwidth/2;
f_high_teeet3 = f_teeet(3) + bandwidth/2;

wn_teeet1 = [f_low_teeet1, f_high_teeet1] / (Fs/2);
wn_teeet2 = [f_low_teeet2, f_high_teeet2] / (Fs/2);
wn_teeet3 = [f_low_teeet3, f_high_teeet3] / (Fs/2);

w_teeet1 = 2 * pi * (f_teeet(1) / Fs);
w_teeet2 = 2 * pi * (f_teeet(2) / Fs);
w_teeet3 = 2 * pi * (f_teeet(3) / Fs);

% Konstanta LCCDE
[bteeet1_butter, ateeet1_butter] = butter(orde, wn_teeet1, 'bandpass');
[bteeet2_butter, ateeet2_butter] = butter(orde, wn_teeet2, 'bandpass');
[bteeet3_butter, ateeet3_butter] = butter(orde, wn_teeet3, 'bandpass');
[bteeet1_cheby1, ateeet1_cheby1] = cheby1(orde, Rp, wn_teeet1, 'bandpass');
[bteeet2_cheby1, ateeet2_cheby1] = cheby1(orde, Rp, wn_teeet2, 'bandpass');
[bteeet3_cheby1, ateeet3_cheby1] = cheby1(orde, Rp, wn_teeet3, 'bandpass');
bteeet1_fir1 = fir1(orde_fir1, wn_teeet1, 'bandpass');
bteeet2_fir1 = fir1(orde_fir1, wn_teeet2, 'bandpass');
bteeet3_fir1 = fir1(orde_fir1, wn_teeet3, 'bandpass');
ateeet1_fir1 = zeros(1, length(bteeet1_fir1)); 
ateeet2_fir1 = zeros(1, length(bteeet2_fir1)); 
ateeet3_fir1 = zeros(1, length(bteeet3_fir1)); 
ateeet1_fir1(1) = 1;
ateeet2_fir1(1) = 1;
ateeet3_fir1(1) = 1;

% Komponen Pole dan Zero
[zteeet1_butter, pteeet1_butter, kteeet1_butter] = tf2zp(bteeet1_butter, ateeet1_butter);
[zteeet2_butter, pteeet2_butter, kteeet2_butter] = tf2zp(bteeet2_butter, ateeet2_butter);
[zteeet3_butter, pteeet3_butter, kteeet3_butter] = tf2zp(bteeet3_butter, ateeet3_butter);
[zteeet1_cheby1, pteeet1_cheby1, kteeet1_cheby1] = tf2zp(bteeet1_cheby1, ateeet1_cheby1);
[zteeet2_cheby1, pteeet2_cheby1, kteeet2_cheby1] = tf2zp(bteeet2_cheby1, ateeet2_cheby1);
[zteeet3_cheby1, pteeet3_cheby1, kteeet3_cheby1] = tf2zp(bteeet3_cheby1, ateeet3_cheby1);
[zteeet1_fir1, pteeet1_fir1, kteeet1_fir1] = tf2zp(bteeet1_fir1, ateeet1_fir1);
[zteeet2_fir1, pteeet2_fir1, kteeet2_fir1] = tf2zp(bteeet2_fir1, ateeet2_fir1);
[zteeet3_fir1, pteeet3_fir1, kteeet3_fir1] = tf2zp(bteeet3_fir1, ateeet3_fir1);
p1_teeet1 = r * exp(1i * w_teeet1);     
p2_teeet1 = r * exp(-1i * w_teeet1);
list_p_teeet1 = [p1_teeet1, p2_teeet1];
p1_teeet2 = r * exp(1i * w_teeet2);     
p2_teeet2 = r * exp(-1i * w_teeet2);
list_p_teeet2 = [p1_teeet2, p2_teeet2];
p1_teeet3 = r * exp(1i * w_teeet3);     
p2_teeet3 = r * exp(-1i * w_teeet3);
list_p_teeet3 = [p1_teeet3, p2_teeet3];
list_z = [1; -1];
p_teeet1 = [];
z_teeet1 = [];
p_teeet2 = [];
z_teeet2 = [];
p_teeet3 = [];
z_teeet3 = [];

for i = 1:3
    p_teeet1 = [p_teeet1; list_p_teeet1(:)];
    z_teeet1 = [z_teeet1; list_z(:)];
    p_teeet2 = [p_teeet2; list_p_teeet2(:)];
    z_teeet2 = [z_teeet2; list_z(:)];
    p_teeet3 = [p_teeet3; list_p_teeet3(:)];
    z_teeet3 = [z_teeet3; list_z(:)];
end

zall_teeet = [z_teeet1(:); z_teeet2(:); z_teeet3(:)];
pall_teeet = [p_teeet1(:); p_teeet2(:); p_teeet3(:)];

% Konstanta LCCDE untuk Filter Peletakkan Pole-Zero Sederhana
k = 1;
[b_teeet1, a_teeet1] = zp2tf(z_teeet1, p_teeet1, k);
[b_teeet2, a_teeet2] = zp2tf(z_teeet2, p_teeet2, k);
[b_teeet3, a_teeet3] = zp2tf(z_teeet3, p_teeet3, k);

% Komponen Respons Frekuensi Sistem
[Hteeet1_butter, wteeet1_butter] = freqz(bteeet1_butter, ateeet1_butter, resolusi_resp_frek, Fs);
[Hteeet2_butter, wteeet2_butter] = freqz(bteeet2_butter, ateeet2_butter, resolusi_resp_frek, Fs);
[Hteeet3_butter, wteeet3_butter] = freqz(bteeet3_butter, ateeet3_butter, resolusi_resp_frek, Fs);
[Hteeet1_cheby1, wteeet1_cheby1] = freqz(bteeet1_cheby1, ateeet1_cheby1, resolusi_resp_frek, Fs);
[Hteeet2_cheby1, wteeet2_cheby1] = freqz(bteeet2_cheby1, ateeet2_cheby1, resolusi_resp_frek, Fs);
[Hteeet3_cheby1, wteeet3_cheby1] = freqz(bteeet3_cheby1, ateeet3_cheby1, resolusi_resp_frek, Fs);
[Hteeet1_fir1, wteeet1_fir1] = freqz(bteeet1_fir1, ateeet1_fir1, resolusi_resp_frek, Fs);
[Hteeet2_fir1, wteeet2_fir1] = freqz(bteeet2_fir1, ateeet2_fir1, resolusi_resp_frek, Fs);
[Hteeet3_fir1, wteeet3_fir1] = freqz(bteeet3_fir1, ateeet3_fir1, resolusi_resp_frek, Fs);
[Hteeet1, wteeet1] = freqz(b_teeet1, a_teeet1, resolusi_resp_frek, Fs);
[Hteeet2, wteeet2] = freqz(b_teeet2, a_teeet2, resolusi_resp_frek, Fs);
[Hteeet3, wteeet3] = freqz(b_teeet3, a_teeet3, resolusi_resp_frek, Fs);

Hteeet_butter = Hteeet1_butter + Hteeet2_butter + Hteeet3_butter;
Hteeet_cheby1 = Hteeet1_cheby1 + Hteeet2_cheby1 + Hteeet3_cheby1;
Hteeet_fir1 = Hteeet1_fir1 + Hteeet2_fir1 + Hteeet3_fir1;
Hteeet = Hteeet1 + Hteeet2 + Hteeet3;

w = wteeet1_butter;

% Komponen Respons Impuls
hteeet1_butter = filter(bteeet1_butter, ateeet1_butter, impulse_signal);
hteeet2_butter = filter(bteeet2_butter, ateeet2_butter, impulse_signal);
hteeet3_butter = filter(bteeet3_butter, ateeet3_butter, impulse_signal);
hteeet1_cheby1 = filter(bteeet1_cheby1, ateeet1_cheby1, impulse_signal);
hteeet2_cheby1 = filter(bteeet2_cheby1, ateeet2_cheby1, impulse_signal);
hteeet3_cheby1 = filter(bteeet3_cheby1, ateeet3_cheby1, impulse_signal);
hteeet1_fir1 = conv(bteeet1_fir1, impulse_signal_fir1);
hteeet2_fir1 = conv(bteeet2_fir1, impulse_signal_fir1);
hteeet3_fir1 = conv(bteeet3_fir1, impulse_signal_fir1);
hteeet1 = filter(b_teeet1, a_teeet1, impulse_signal);
hteeet2 = filter(b_teeet2, a_teeet2, impulse_signal);
hteeet3 = filter(b_teeet3, a_teeet3, impulse_signal);

% Representasi Sistem
% Filter Butter Built-In
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "teeet" - Butter Built-In');
disp(" ");
disp("Representasi Sistem Filter Butter Built-In");

% Respons Impuls
subplot(2,3,1);
plot(hteeet1_butter, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(hteeet2_butter, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(hteeet3_butter, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(ateeet1_butter)
        val_a = -ateeet1_butter(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(bteeet1_butter)
    if k == 1
        fprintf('%s(%.4g)x[n] ', bteeet1_butter(k));
    else
        sign_char = '+'; 
        if bteeet1_butter(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, bteeet1_butter(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(ateeet2_butter)
        val_a = -ateeet2_butter(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(bteeet2_butter)
    if k == 1
        fprintf('%s(%.4g)x[n] ', bteeet2_butter(k));
    else
        sign_char = '+'; 
        if bteeet2_butter(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, bteeet2_butter(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(ateeet3_butter)
        val_a = -ateeet3_butter(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(bteeet3_butter)
    if k == 1
        fprintf('%s(%.4g)x[n] ', bteeet3_butter(k));
    else
        sign_char = '+'; 
        if bteeet3_butter(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, bteeet3_butter(k), k-1);
    end
end

disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(zteeet1_butter, pteeet1_butter);
hold on;
zplane(zteeet2_butter, pteeet2_butter);
zplane(zteeet3_butter, pteeet3_butter);
hold off;
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wteeet1_butter, 20*log10(abs(Hteeet1_butter)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2_butter, 20*log10(abs(Hteeet2_butter)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3_butter, 20*log10(abs(Hteeet3_butter)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Hteeet_butter)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

% Fasa
subplot(2,3,3);
plot(wteeet1_butter, angle(Hteeet1_butter), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2_butter, angle(Hteeet2_butter), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3_butter, angle(Hteeet3_butter), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

subplot(2,3,6);
plot(w, angle(Hteeet_butter), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

% Filter Cheby1 Built-In
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "teeet" - Cheby1 Built-In');
disp(" ");
disp("Representasi Sistem Filter Cheby1 Built-In");

% Respons Impuls
subplot(2,3,1);
plot(hteeet1_cheby1, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(hteeet2_cheby1, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(hteeet3_cheby1, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(ateeet1_cheby1)
        val_a = -ateeet1_cheby1(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(bteeet1_cheby1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', bteeet1_cheby1(k));
    else
        sign_char = '+'; 
        if bteeet1_cheby1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, bteeet1_cheby1(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(ateeet2_cheby1)
        val_a = -ateeet2_cheby1(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(bteeet2_cheby1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', bteeet2_cheby1(k));
    else
        sign_char = '+'; 
        if bteeet2_cheby1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, bteeet2_cheby1(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(ateeet3_cheby1)
        val_a = -ateeet3_cheby1(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(bteeet3_cheby1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', bteeet3_cheby1(k));
    else
        sign_char = '+'; 
        if bteeet3_cheby1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, bteeet3_cheby1(k), k-1);
    end
end

disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(zteeet1_cheby1, pteeet1_cheby1);
hold on;
zplane(zteeet2_cheby1, pteeet2_cheby1);
zplane(zteeet3_cheby1, pteeet3_cheby1);
hold off;
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wteeet1_cheby1, 20*log10(abs(Hteeet1_cheby1)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2_cheby1, 20*log10(abs(Hteeet2_cheby1)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3_cheby1, 20*log10(abs(Hteeet3_cheby1)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Hteeet_cheby1)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

% Fasa
subplot(2,3,3);
plot(wteeet1_cheby1, angle(Hteeet1_cheby1), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2_cheby1, angle(Hteeet2_cheby1), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3_cheby1, angle(Hteeet3_cheby1), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

subplot(2,3,6);
plot(w, angle(Hteeet_cheby1), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

% Filter FIR1 Built-In
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "teeet" - FIR1 Built-In');
disp(" ");
disp("Representasi Sistem Filter FIR1 Built-In");

% Respons Impuls
subplot(2,3,1);
plot(hteeet1_fir1, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(hteeet2_fir1, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(hteeet3_fir1, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');
xlim([0 1200]); 

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');

for k = 2:length(ateeet1_fir1)
    val_a = -ateeet1_fir1(k);
    if (val_a ~= 0)
        if (k > 2)
            if (val_a > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_a < 0)
                fprintf('- ');
            end
        end
        fprintf('(%.4g)y[n-%d] ', abs(val_a), k-1);
    end
end

for k = 1:length(bteeet1_fir1)
    val_b = bteeet1_fir1(k);
    if (val_b ~= 0)
        is_very_first = (k == 1 && ~any(ateeet1_fir1(2:end)));
        if (~is_very_first)
            if (val_b > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_b < 0)
                fprintf('- ');
            end
        end
        
        if (k == 1)
            fprintf('(%.4g)x[n] ', abs(val_b));
        else
            fprintf('(%.4g)x[n-%d] ', abs(val_b), k-1);
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');

for k = 2:length(ateeet2_fir1)
    val_a = -ateeet2_fir1(k);
    if (val_a ~= 0)
        if (k > 2)
            if (val_a > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_a < 0)
                fprintf('- ');
            end
        end
        fprintf('(%.4g)y[n-%d] ', abs(val_a), k-1);
    end
end

for k = 1:length(bteeet2_fir1)
    val_b = bteeet2_fir1(k);
    if (val_b ~= 0)
        is_very_first = (k == 1 && ~any(ateeet2_fir1(2:end)));
        if (~is_very_first)
            if (val_b > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_b < 0)
                fprintf('- ');
            end
        end
        
        if (k == 1)
            fprintf('(%.4g)x[n] ', abs(val_b));
        else
            fprintf('(%.4g)x[n-%d] ', abs(val_b), k-1);
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');

for k = 2:length(ateeet3_fir1)
    val_a = -ateeet3_fir1(k);
    if (val_a ~= 0)
        if (k > 2)
            if (val_a > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_a < 0)
                fprintf('- ');
            end
        end
        fprintf('(%.4g)y[n-%d] ', abs(val_a), k-1);
    end
end

for k = 1:length(bteeet3_fir1)
    val_b = bteeet3_fir1(k);
    if (val_b ~= 0)
        is_very_first = (k == 1 && ~any(ateeet3_fir1(2:end)));
        if (~is_very_first)
            if (val_b > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_b < 0)
                fprintf('- ');
            end
        end
        
        if (k == 1)
            fprintf('(%.4g)x[n] ', abs(val_b));
        else
            fprintf('(%.4g)x[n-%d] ', abs(val_b), k-1);
        end
    end
end
disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(zteeet1_fir1, pteeet1_fir1);
hold on;
zplane(zteeet2_fir1, pteeet2_fir1);
zplane(zteeet3_fir1, pteeet3_fir1);
hold off;
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wteeet1_fir1, 20*log10(abs(Hteeet1_fir1)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2_fir1, 20*log10(abs(Hteeet2_fir1)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3_fir1, 20*log10(abs(Hteeet3_fir1)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Hteeet_fir1)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

% Fasa
subplot(2,3,3);
plot(wteeet1_fir1, angle(Hteeet1_fir1), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2_fir1, angle(Hteeet2_fir1), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3_fir1, angle(Hteeet3_fir1), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

subplot(2,3,6);
plot(w, angle(Hteeet_fir1), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

% Filter dengan Peletakkan Manual Pole-Zero Sederhana
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "teeet" - Peletakkan Manual Pole-Zero Sederhana');
disp(" ");
disp("Representasi Sistem Filter Peletakkan Manual Pole-Zero Sederhana");

% Respons Impuls
subplot(2,3,1);
plot(hteeet1, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(hteeet2, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(hteeet3, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(a_teeet1)
    val_a = -a_teeet1(k);
    if (val_a ~= 0)
        if (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            if (val_a > 0)
                fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
            else
                fprintf('- (%.4g)y[n-%d] ', abs(val_a), k-1);
            end
        end
    end
end
for k = 1:length(b_teeet1)
    val_b = b_teeet1(k);
    if (val_b ~= 0)
        if (k == 1)
            if (~any(a_teeet1(2:end)))
                fprintf('(%.4g)x[n] ', val_b);
            else
                if (val_b > 0)
                    fprintf('+ (%.4g)x[n] ', val_b);
                else
                    fprintf('- (%.4g)x[n] ', abs(val_b));
                end
            end
        else
            if (val_b > 0)
                fprintf('+ (%.4g)x[n-%d] ', val_b, k-1);
            else
                fprintf('- (%.4g)x[n-%d] ', abs(val_b), k-1);
            end
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(a_teeet2)
    val_a = -a_teeet2(k);
    if (val_a ~= 0)
        if (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            if (val_a > 0)
                fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
            else
                fprintf('- (%.4g)y[n-%d] ', abs(val_a), k-1);
            end
        end
    end
end
for k = 1:length(b_teeet2)
    val_b = b_teeet2(k);
    if (val_b ~= 0)
        if (k == 1)
            if (~any(a_teeet2(2:end)))
                fprintf('(%.4g)x[n] ', val_b);
            else
                if (val_b > 0)
                    fprintf('+ (%.4g)x[n] ', val_b);
                else
                    fprintf('- (%.4g)x[n] ', abs(val_b));
                end
            end
        else
            if (val_b > 0)
                fprintf('+ (%.4g)x[n-%d] ', val_b, k-1);
            else
                fprintf('- (%.4g)x[n-%d] ', abs(val_b), k-1);
            end
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(a_teeet3)
    val_a = -a_teeet3(k);
    if (val_a ~= 0)
        if (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            if (val_a > 0)
                fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
            else
                fprintf('- (%.4g)y[n-%d] ', abs(val_a), k-1);
            end
        end
    end
end
for k = 1:length(b_teeet3)
    val_b = b_teeet3(k);
    if (val_b ~= 0)
        if (k == 1)
            if (~any(a_teeet3(2:end)))
                fprintf('(%.4g)x[n] ', val_b);
            else
                if (val_b > 0)
                    fprintf('+ (%.4g)x[n] ', val_b);
                else
                    fprintf('- (%.4g)x[n] ', abs(val_b));
                end
            end
        else
            if (val_b > 0)
                fprintf('+ (%.4g)x[n-%d] ', val_b, k-1);
            else
                fprintf('- (%.4g)x[n-%d] ', abs(val_b), k-1);
            end
        end
    end
end
disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(zall_teeet, pall_teeet);
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wteeet1, 20*log10(abs(Hteeet1)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2, 20*log10(abs(Hteeet2)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3, 20*log10(abs(Hteeet3)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Hteeet)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

% Fasa
subplot(2,3,3);
plot(wteeet1, angle(Hteeet1), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wteeet2, angle(Hteeet2), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wteeet3, angle(Hteeet3), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

subplot(2,3,6);
plot(w, angle(Hteeet), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]);

% Desain Filter Sinyal "tooot"

disp(" ");
disp("Desain Filter Sinyal tooot")

% Parameter Filter

f_tooot = [555.826, 1111.65, 1667.48];

f_low_tooot1 = f_tooot(1) - bandwidth/2;
f_high_tooot1 = f_tooot(1) + bandwidth/2;

f_low_tooot2 = f_tooot(2) - bandwidth/2;
f_high_tooot2 = f_tooot(2) + bandwidth/2;

f_low_tooot3 = f_tooot(3) - bandwidth/2;
f_high_tooot3 = f_tooot(3) + bandwidth/2;

wn_tooot1 = [f_low_tooot1, f_high_tooot1] / (Fs/2);
wn_tooot2 = [f_low_tooot2, f_high_tooot2] / (Fs/2);
wn_tooot3 = [f_low_tooot3, f_high_tooot3] / (Fs/2);

w_tooot1 = 2 * pi * (f_tooot(1) / Fs);
w_tooot2 = 2 * pi * (f_tooot(2) / Fs);
w_tooot3 = 2 * pi * (f_tooot(3) / Fs);

% Konstanta LCCDE
[btooot1_butter, atooot1_butter] = butter(orde, wn_tooot1, 'bandpass');
[btooot2_butter, atooot2_butter] = butter(orde, wn_tooot2, 'bandpass');
[btooot3_butter, atooot3_butter] = butter(orde, wn_tooot3, 'bandpass');
[btooot1_cheby1, atooot1_cheby1] = cheby1(orde, Rp, wn_tooot1, 'bandpass');
[btooot2_cheby1, atooot2_cheby1] = cheby1(orde, Rp, wn_tooot2, 'bandpass');
[btooot3_cheby1, atooot3_cheby1] = cheby1(orde, Rp, wn_tooot3, 'bandpass');
btooot1_fir1 = fir1(orde_fir1, wn_tooot1, 'bandpass');
btooot2_fir1 = fir1(orde_fir1, wn_tooot2, 'bandpass');
btooot3_fir1 = fir1(orde_fir1, wn_tooot3, 'bandpass');
atooot1_fir1 = zeros(1, length(btooot1_fir1)); 
atooot2_fir1 = zeros(1, length(btooot2_fir1)); 
atooot3_fir1 = zeros(1, length(btooot3_fir1)); 
atooot1_fir1(1) = 1;
atooot2_fir1(1) = 1;
atooot3_fir1(1) = 1;

% Komponen Pole dan Zero
[ztooot1_butter, ptooot1_butter, ktooot1_butter] = tf2zp(btooot1_butter, atooot1_butter);
[ztooot2_butter, ptooot2_butter, ktooot2_butter] = tf2zp(btooot2_butter, atooot2_butter);
[ztooot3_butter, ptooot3_butter, ktooot3_butter] = tf2zp(btooot3_butter, atooot3_butter);
[ztooot1_cheby1, ptooot1_cheby1, ktooot1_cheby1] = tf2zp(btooot1_cheby1, atooot1_cheby1);
[ztooot2_cheby1, ptooot2_cheby1, ktooot2_cheby1] = tf2zp(btooot2_cheby1, atooot2_cheby1);
[ztooot3_cheby1, ptooot3_cheby1, ktooot3_cheby1] = tf2zp(btooot3_cheby1, atooot3_cheby1);
[ztooot1_fir1, ptooot1_fir1, ktooot1_fir1] = tf2zp(btooot1_fir1, atooot1_fir1);
[ztooot2_fir1, ptooot2_fir1, ktooot2_fir1] = tf2zp(btooot2_fir1, atooot2_fir1);
[ztooot3_fir1, ptooot3_fir1, ktooot3_fir1] = tf2zp(btooot3_fir1, atooot3_fir1);
p1_tooot1 = r * exp(1i * w_tooot1);     
p2_tooot1 = r * exp(-1i * w_tooot1);
list_p_tooot1 = [p1_tooot1, p2_tooot1];
p1_tooot2 = r * exp(1i * w_tooot2);     
p2_tooot2 = r * exp(-1i * w_tooot2);
list_p_tooot2 = [p1_tooot2, p2_tooot2];
p1_tooot3 = r * exp(1i * w_tooot3);     
p2_tooot3 = r * exp(-1i * w_tooot3);
list_p_tooot3 = [p1_tooot3, p2_tooot3];
list_z = [1; -1];
p_tooot1 = [];
z_tooot1 = [];
p_tooot2 = [];
z_tooot2 = [];
p_tooot3 = [];
z_tooot3 = [];

for i = 1:3
    p_tooot1 = [p_tooot1; list_p_tooot1(:)];
    z_tooot1 = [z_tooot1; list_z(:)];
    p_tooot2 = [p_tooot2; list_p_tooot2(:)];
    z_tooot2 = [z_tooot2; list_z(:)];
    p_tooot3 = [p_tooot3; list_p_tooot3(:)];
    z_tooot3 = [z_tooot3; list_z(:)];
end

zall_tooot = [z_tooot1(:); z_tooot2(:); z_tooot3(:)];
pall_tooot = [p_tooot1(:); p_tooot2(:); p_tooot3(:)];

% Konstanta LCCDE untuk Filter Peletakkan Manual Pole-Zero Sederhana
k = 1;
[b_tooot1, a_tooot1] = zp2tf(z_tooot1, p_tooot1, k);
[b_tooot2, a_tooot2] = zp2tf(z_tooot2, p_tooot2, k);
[b_tooot3, a_tooot3] = zp2tf(z_tooot3, p_tooot3, k);

% Komponen Respons Frekuensi Sistem
[Htooot1_butter, wtooot1_butter] = freqz(btooot1_butter, atooot1_butter, resolusi_resp_frek, Fs);
[Htooot2_butter, wtooot2_butter] = freqz(btooot2_butter, atooot2_butter, resolusi_resp_frek, Fs);
[Htooot3_butter, wtooot3_butter] = freqz(btooot3_butter, atooot3_butter, resolusi_resp_frek, Fs);
[Htooot1_cheby1, wtooot1_cheby1] = freqz(btooot1_cheby1, atooot1_cheby1, resolusi_resp_frek, Fs);
[Htooot2_cheby1, wtooot2_cheby1] = freqz(btooot2_cheby1, atooot2_cheby1, resolusi_resp_frek, Fs);
[Htooot3_cheby1, wtooot3_cheby1] = freqz(btooot3_cheby1, atooot3_cheby1, resolusi_resp_frek, Fs);
[Htooot1_fir1, wtooot1_fir1] = freqz(btooot1_fir1, atooot1_fir1, resolusi_resp_frek, Fs);
[Htooot2_fir1, wtooot2_fir1] = freqz(btooot2_fir1, atooot2_fir1, resolusi_resp_frek, Fs);
[Htooot3_fir1, wtooot3_fir1] = freqz(btooot3_fir1, atooot3_fir1, resolusi_resp_frek, Fs);
[Htooot1, wtooot1] = freqz(b_tooot1, a_tooot1, resolusi_resp_frek, Fs);
[Htooot2, wtooot2] = freqz(b_tooot2, a_tooot2, resolusi_resp_frek, Fs);
[Htooot3, wtooot3] = freqz(b_tooot3, a_tooot3, resolusi_resp_frek, Fs);

Htooot_butter = Htooot1_butter + Htooot2_butter + Htooot3_butter;
Htooot_cheby1 = Htooot1_cheby1 + Htooot2_cheby1 + Htooot3_cheby1;
Htooot_fir1 = Htooot1_fir1 + Htooot2_fir1 + Htooot3_fir1;
Htooot = Htooot1 + Htooot2 + Htooot3;
w = wtooot1_butter;

% Komponen Respons Impuls
htooot1_butter = filter(btooot1_butter, atooot1_butter, impulse_signal);
htooot2_butter = filter(btooot2_butter, atooot2_butter, impulse_signal);
htooot3_butter = filter(btooot3_butter, atooot3_butter, impulse_signal);
htooot1_cheby1 = filter(btooot1_cheby1, atooot1_cheby1, impulse_signal);
htooot2_cheby1 = filter(btooot2_cheby1, atooot2_cheby1, impulse_signal);
htooot3_cheby1 = filter(btooot3_cheby1, atooot3_cheby1, impulse_signal);
htooot1_fir1 = conv(btooot1_fir1, impulse_signal_fir1);
htooot2_fir1 = conv(btooot2_fir1, impulse_signal_fir1);
htooot3_fir1 = conv(btooot3_fir1, impulse_signal_fir1);
htooot1 = filter(b_tooot1, a_tooot1, impulse_signal);
htooot2 = filter(b_tooot2, a_tooot2, impulse_signal);
htooot3 = filter(b_tooot3, a_tooot3, impulse_signal);

% Representasi Sistem
% Filter Butter Built-In
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "tooot" - Butter Built-In');
disp(" ");
disp("Representasi Sistem Filter Butter Built-In");

% Respons Impuls
subplot(2,3,1);
plot(htooot1_butter, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(htooot2_butter, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(htooot3_butter, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(atooot1_butter)
        val_a = -atooot1_butter(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(btooot1_butter)
    if k == 1
        fprintf('%s(%.4g)x[n] ', btooot1_butter(k));
    else
        sign_char = '+'; 
        if btooot1_butter(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, btooot1_butter(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(atooot2_butter)
        val_a = -atooot2_butter(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(btooot2_butter)
    if k == 1
        fprintf('%s(%.4g)x[n] ', btooot2_butter(k));
    else
        sign_char = '+'; 
        if btooot2_butter(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, btooot2_butter(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(atooot3_butter)
        val_a = -atooot3_butter(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(btooot3_butter)
    if k == 1
        fprintf('%s(%.4g)x[n] ', btooot3_butter(k));
    else
        sign_char = '+'; 
        if btooot3_butter(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, btooot3_butter(k), k-1);
    end
end

disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(ztooot1_butter, ptooot1_butter);
hold on;
zplane(ztooot2_butter, ptooot2_butter);
zplane(ztooot3_butter, ptooot3_butter);
hold off;
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wtooot1_butter, 20*log10(abs(Htooot1_butter)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2_butter, 20*log10(abs(Htooot2_butter)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3_butter, 20*log10(abs(Htooot3_butter)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 2250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Htooot_butter)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 2250]); 

% Fasa
subplot(2,3,3);
plot(wtooot1_butter, angle(Htooot1_butter), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2_butter, angle(Htooot2_butter), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3_butter, angle(Htooot3_butter), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 2250]); 

subplot(2,3,6);
plot(w, angle(Htooot_butter), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 2250]); 

% Filter Cheby1 Built-In
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "tooot" - Cheby1 Built-In');
disp(" ");
disp("Representasi Sistem Filter Cheby1 Built-In");

% Respons Impuls
subplot(2,3,1);
plot(htooot1_cheby1, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(htooot2_cheby1, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(htooot3_cheby1, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(atooot1_cheby1)
        val_a = -atooot1_cheby1(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(btooot1_cheby1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', btooot1_cheby1(k));
    else
        sign_char = '+'; 
        if btooot1_cheby1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, btooot1_cheby1(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(atooot2_cheby1)
        val_a = -atooot2_cheby1(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(btooot2_cheby1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', btooot2_cheby1(k));
    else
        sign_char = '+'; 
        if btooot2_cheby1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, btooot2_cheby1(k), k-1);
    end
end

disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(atooot3_cheby1)
        val_a = -atooot3_cheby1(k); % Dibalik tandanya karena pindah ruas ke kanan
        if (val_a == 0 || val_a == -0)
            fprintf('');
        elseif (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
        end
end
fprintf('+ ');
for k = 1:length(btooot3_cheby1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', btooot3_cheby1(k));
    else
        sign_char = '+'; 
        if btooot3_cheby1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, btooot3_cheby1(k), k-1);
    end
end

disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(ztooot1_cheby1, ptooot1_cheby1);
hold on;
zplane(ztooot2_cheby1, ptooot2_cheby1);
zplane(ztooot3_cheby1, ptooot3_cheby1);
hold off;
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wtooot1_cheby1, 20*log10(abs(Htooot1_cheby1)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2_cheby1, 20*log10(abs(Htooot2_cheby1)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3_cheby1, 20*log10(abs(Htooot3_cheby1)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 2250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Htooot_cheby1)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 2250]); 

% Fasa
subplot(2,3,3);
plot(wtooot1_cheby1, angle(Htooot1_cheby1), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2_cheby1, angle(Htooot2_cheby1), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3_cheby1, angle(Htooot3_cheby1), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 2250]); 

subplot(2,3,6);
plot(w, angle(Htooot_cheby1), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 2250]); 

% Filter FIR1 Built-In
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "tooot" - FIR1 Built-In');
disp(" ");
disp("Representasi Sistem Filter FIR1 Built-In");

% Respons Impuls
subplot(2,3,1);
plot(htooot1_fir1, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(htooot2_fir1, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(htooot3_fir1, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');
xlim([0 1200]); 

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');

for k = 2:length(atooot1_fir1)
    val_a = -atooot1_fir1(k);
    if (val_a ~= 0)
        if (k > 2)
            if (val_a > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_a < 0)
                fprintf('- ');
            end
        end
        fprintf('(%.4g)y[n-%d] ', abs(val_a), k-1);
    end
end

for k = 1:length(btooot1_fir1)
    val_b = btooot1_fir1(k);
    if (val_b ~= 0)
        is_very_first = (k == 1 && ~any(atooot1_fir1(2:end)));
        if (~is_very_first)
            if (val_b > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_b < 0)
                fprintf('- ');
            end
        end
        
        if (k == 1)
            fprintf('(%.4g)x[n] ', abs(val_b));
        else
            fprintf('(%.4g)x[n-%d] ', abs(val_b), k-1);
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');

for k = 2:length(atooot2_fir1)
    val_a = -atooot2_fir1(k);
    if (val_a ~= 0)
        if (k > 2)
            if (val_a > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_a < 0)
                fprintf('- ');
            end
        end
        fprintf('(%.4g)y[n-%d] ', abs(val_a), k-1);
    end
end

for k = 1:length(btooot2_fir1)
    val_b = btooot2_fir1(k);
    if (val_b ~= 0)
        is_very_first = (k == 1 && ~any(atooot2_fir1(2:end)));
        if (~is_very_first)
            if (val_b > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_b < 0)
                fprintf('- ');
            end
        end
        
        if (k == 1)
            fprintf('(%.4g)x[n] ', abs(val_b));
        else
            fprintf('(%.4g)x[n-%d] ', abs(val_b), k-1);
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');

for k = 2:length(atooot3_fir1)
    val_a = -atooot3_fir1(k);
    if (val_a ~= 0)
        if (k > 2)
            if (val_a > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_a < 0)
                fprintf('- ');
            end
        end
        fprintf('(%.4g)y[n-%d] ', abs(val_a), k-1);
    end
end

for k = 1:length(btooot3_fir1)
    val_b = btooot3_fir1(k);
    if (val_b ~= 0)
        is_very_first = (k == 1 && ~any(atooot3_fir1(2:end)));
        if (~is_very_first)
            if (val_b > 0)
                fprintf('+ ');
            else
                fprintf('- ');
            end
        else
            if (val_b < 0)
                fprintf('- ');
            end
        end
        
        if (k == 1)
            fprintf('(%.4g)x[n] ', abs(val_b));
        else
            fprintf('(%.4g)x[n-%d] ', abs(val_b), k-1);
        end
    end
end
disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(ztooot1_fir1, ptooot1_fir1);
hold on;
zplane(ztooot2_fir1, ptooot2_fir1);
zplane(ztooot3_fir1, ptooot3_fir1);
hold off;
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wtooot1_fir1, 20*log10(abs(Htooot1_fir1)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2_fir1, 20*log10(abs(Htooot2_fir1)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3_fir1, 20*log10(abs(Htooot3_fir1)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 2250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Htooot_fir1)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 2250]); 

% Fasa
subplot(2,3,3);
plot(wtooot1_fir1, angle(Htooot1_fir1), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2_fir1, angle(Htooot2_fir1), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3_fir1, angle(Htooot3_fir1), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 2250]); 

subplot(2,3,6);
plot(w, angle(Htooot_fir1), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 2250]); 

% Filter dengan Peletakkan Manual Pole-Zero Sederhana
figure('Color', 'w', 'Name', '1c. Filter - Sinyal "tooot" - Peletakkan Manual Pole-Zero Sederhana');
disp(" ");
disp("Representasi Sistem Filter Peletakkan Manual Pole-Zero Sederhana");

% Respons Impuls
subplot(2,3,1);
plot(htooot1, 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(htooot2, 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(htooot3, 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Impuls Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo Respons Impuls [h(n)]');

% LCCDE
fprintf('Persamaan LCCDE Filter Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(a_tooot1)
    val_a = -a_tooot1(k);
    if (val_a ~= 0)
        if (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            if (val_a > 0)
                fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
            else
                fprintf('- (%.4g)y[n-%d] ', abs(val_a), k-1);
            end
        end
    end
end
for k = 1:length(b_tooot1)
    val_b = b_tooot1(k);
    if (val_b ~= 0)
        if (k == 1)
            if (~any(a_tooot1(2:end)))
                fprintf('(%.4g)x[n] ', val_b);
            else
                if (val_b > 0)
                    fprintf('+ (%.4g)x[n] ', val_b);
                else
                    fprintf('- (%.4g)x[n] ', abs(val_b));
                end
            end
        else
            if (val_b > 0)
                fprintf('+ (%.4g)x[n-%d] ', val_b, k-1);
            else
                fprintf('- (%.4g)x[n-%d] ', abs(val_b), k-1);
            end
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(a_tooot2)
    val_a = -a_tooot2(k);
    if (val_a ~= 0)
        if (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            if (val_a > 0)
                fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
            else
                fprintf('- (%.4g)y[n-%d] ', abs(val_a), k-1);
            end
        end
    end
end
for k = 1:length(b_tooot2)
    val_b = b_tooot2(k);
    if (val_b ~= 0)
        if (k == 1)
            if (~any(a_tooot2(2:end)))
                fprintf('(%.4g)x[n] ', val_b);
            else
                if (val_b > 0)
                    fprintf('+ (%.4g)x[n] ', val_b);
                else
                    fprintf('- (%.4g)x[n] ', abs(val_b));
                end
            end
        else
            if (val_b > 0)
                fprintf('+ (%.4g)x[n-%d] ', val_b, k-1);
            else
                fprintf('- (%.4g)x[n-%d] ', abs(val_b), k-1);
            end
        end
    end
end
disp(" ");

fprintf('Persamaan LCCDE Filter Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(a_tooot3)
    val_a = -a_tooot3(k);
    if (val_a ~= 0)
        if (k == 2)
            fprintf('(%.4g)y[n-%d] ', val_a, k-1);
        else
            if (val_a > 0)
                fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
            else
                fprintf('- (%.4g)y[n-%d] ', abs(val_a), k-1);
            end
        end
    end
end
for k = 1:length(b_tooot3)
    val_b = b_tooot3(k);
    if (val_b ~= 0)
        if (k == 1)
            if (~any(a_tooot3(2:end)))
                fprintf('(%.4g)x[n] ', val_b);
            else
                if (val_b > 0)
                    fprintf('+ (%.4g)x[n] ', val_b);
                else
                    fprintf('- (%.4g)x[n] ', abs(val_b));
                end
            end
        else
            if (val_b > 0)
                fprintf('+ (%.4g)x[n-%d] ', val_b, k-1);
            else
                fprintf('- (%.4g)x[n-%d] ', abs(val_b), k-1);
            end
        end
    end
end
disp(" ");

% Peta Pole-Zero
subplot(2,3,4);
zplane(zall_tooot(:), pall_tooot(:));
title({'Peta Pole-Zero Filter Fundamental, Harmonik 1, dan Harmonik 2'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% Respons Frekuensi
% Magnitudo
subplot(2,3,2);
plot(wtooot1, 20*log10(abs(Htooot1)), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2, 20*log10(abs(Htooot2)), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3, 20*log10(abs(Htooot3)), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Magnitudo Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

subplot(2,3,5);
plot(w, 20*log10(abs(Htooot)), 'k', 'LineWidth', 1.5);
title('Respons Magnitudo Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

% Fasa
subplot(2,3,3);
plot(wtooot1, angle(Htooot1), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 1.5);
hold on;
plot(wtooot2, angle(Htooot2), 'Color', [0, 0.4, 0.8], 'LineWidth', 1.5);
plot(wtooot3, angle(Htooot3), 'Color', [0.1, 0.6, 0.2], 'LineWidth', 1.5);
hold off;
legend('Filter Fundamental', 'Filter Harmonik 1', 'Filter Harmonik 2', 'Location','southeast');
title({'Respons Fasa Filter Fundamental', ', Harmonik 1, dan Harmonik 2'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]); 

subplot(2,3,6);
plot(w, angle(Htooot), 'k', 'LineWidth', 1.5);
title('Respons Fasa Filter Total');
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]);

%% Soal 1d

disp(" ");
disp("SOAL 1d");

% Audio Suara "teeet"
disp(" ");
disp("Audio Suara teeet");

yteeet1_butter = filter(bteeet1_butter, ateeet1_butter, x);
yteeet2_butter = filter(bteeet2_butter, ateeet2_butter, x);
yteeet3_butter = filter(bteeet3_butter, ateeet3_butter, x);
yteeet1_cheby1 = filter(bteeet1_cheby1, ateeet1_cheby1, x);
yteeet2_cheby1 = filter(bteeet2_cheby1, ateeet2_cheby1, x);
yteeet3_cheby1 = filter(bteeet3_cheby1, ateeet3_cheby1, x);
yteeet1_fir1 = filter(bteeet1_fir1, ateeet1_fir1, x);
yteeet2_fir1 = filter(bteeet2_fir1, ateeet2_fir1, x);
yteeet3_fir1 = filter(bteeet3_fir1, ateeet3_fir1, x);
yteeet1_pzmanual = filter(b_teeet1, a_teeet1, x);
yteeet2_pzmanual = filter(b_teeet2, a_teeet2, x);
yteeet3_pzmanual = filter(b_teeet3, a_teeet3, x);

yteeet_butter = yteeet1_butter + yteeet2_butter + yteeet3_butter;
yteeet_cheby1 = yteeet1_cheby1 + yteeet2_cheby1 + yteeet3_cheby1;
yteeet_fir1 = yteeet1_fir1 + yteeet2_fir1 + yteeet3_fir1;
yteeet_pzmanual = yteeet1_pzmanual + yteeet2_pzmanual + yteeet3_pzmanual;

y_butter_norm = yteeet_butter / max(abs(yteeet_butter));
y_cheby1_norm = yteeet_cheby1 / max(abs(yteeet_cheby1));
y_fir1_norm   = yteeet_fir1 / max(abs(yteeet_fir1));
y_pzmanual_norm = yteeet_pzmanual / max(abs(yteeet_pzmanual));

audiowrite('teeet_butterworth.mp3', y_butter_norm, Fs);
audiowrite('teeet_chebyshev1.mp3', y_cheby1_norm, Fs);
audiowrite('teeet_fir1.mp3', y_fir1_norm, Fs);
audiowrite('teeet_polezero_manual.mp3', y_pzmanual_norm, Fs);

disp("File audio mp3 sinyal teeet hasil keluaran filter telah dibuat");

% Audio Suara "tooot"
disp(" ");
disp("Audio Suara tooot");

ytooot1_butter = filter(btooot1_butter, atooot1_butter, x);
ytooot2_butter = filter(btooot2_butter, atooot2_butter, x);
ytooot3_butter = filter(btooot3_butter, atooot3_butter, x);
ytooot1_cheby1 = filter(btooot1_cheby1, atooot1_cheby1, x);
ytooot2_cheby1 = filter(btooot2_cheby1, atooot2_cheby1, x);
ytooot3_cheby1 = filter(btooot3_cheby1, atooot3_cheby1, x);
ytooot1_fir1 = filter(btooot1_fir1, atooot1_fir1, x);
ytooot2_fir1 = filter(btooot2_fir1, atooot2_fir1, x);
ytooot3_fir1 = filter(btooot3_fir1, atooot3_fir1, x);
ytooot1_pzmanual = filter(b_tooot1, a_tooot1, x);
ytooot2_pzmanual = filter(b_tooot2, a_tooot2, x);
ytooot3_pzmanual = filter(b_tooot3, a_tooot3, x);

ytooot_butter = ytooot1_butter + ytooot2_butter + ytooot3_butter;
ytooot_cheby1 = ytooot1_cheby1 + ytooot2_cheby1 + ytooot3_cheby1;
ytooot_fir1 = ytooot1_fir1 + ytooot2_fir1 + ytooot3_fir1;
ytooot_pzmanual = ytooot1_pzmanual + ytooot2_pzmanual + ytooot3_pzmanual;

y_butter_norm = ytooot_butter / max(abs(ytooot_butter));
y_cheby1_norm = ytooot_cheby1 / max(abs(ytooot_cheby1));
y_fir1_norm   = ytooot_fir1 / max(abs(ytooot_fir1));
y_pzmanual_norm = ytooot_pzmanual / max(abs(ytooot_pzmanual));

audiowrite('tooot_butterworth.mp3', y_butter_norm, Fs);
audiowrite('tooot_chebyshev1.mp3', y_cheby1_norm, Fs);
audiowrite('tooot_fir1.mp3', y_fir1_norm, Fs);
audiowrite('tooot_polezero_manual.mp3', y_pzmanual_norm, Fs);

disp(" ");
disp("File audio mp3 sinyal tooot hasil keluaran filter telah dibuat");
