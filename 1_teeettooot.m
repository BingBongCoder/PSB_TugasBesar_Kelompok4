%% 1. Persiapan Data
[x, Fs] = audioread('kereta.aac');
s = x(:,1); 

% Titik mulai siklus "teeet-tooot" diambil dari waktu mulai tiap "teeet" ideal
% Data t_starts berdasarkan perhitungan perioda t2 sampai t15 di laporan [cite: 2840-2846]
t_starts_gabung = [1.60646, 3.43342, 5.26565, 7.08896, 8.91415, 10.7427, ...
                   12.5639, 14.3965, 16.2361, 18.0407, 19.8694, 21.6945, ...
                   23.525, 25.3521]; 

durasi_siklus = 1.8269; % Perioda rata-rata (T) gabungan teeet-tooot [cite: 2850]
nfft = 16384;           % Zero padding tetap digunakan untuk resolusi visual

%% 2. Inisialisasi Plotting
figure('Color', 'w', 'Name', 'Analisis PSD Gabungan - teeet...tooot...');

% --- a. Measured Signals (Sekumpulan Siklus Gabungan) ---
subplot(3,2,1); hold on;
colors = lines(length(t_starts_gabung)); 
for i = 1:length(t_starts_gabung)
    idx = round(t_starts_gabung(i)*Fs) : round((t_starts_gabung(i)+durasi_siklus)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['a. Sinyal "teeet-tooot" (', num2str(length(t_starts_gabung)), ' Siklus)']);
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- b. Hamming Windowing Function ---
subplot(3,2,3);
win = hamming(round(durasi_siklus*Fs) + 1);
plot((0:length(win)-1)/Fs, win, 'r', 'LineWidth', 1.5);
title('b. Hamming Window');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- c. Windowed Signals (Siklus Gabungan) ---
subplot(3,2,5); hold on;
for i = 1:length(t_starts_gabung)
    idx = round(t_starts_gabung(i)*Fs) : round((t_starts_gabung(i)+durasi_siklus)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win)-1)/Fs, seg_win, 'Color', colors(i,:));
end
title('c. Windowed Signals');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- d. Masing-masing Spektrum (Dua Puncak Dominan) ---
subplot(3,2,2); hold on;
P_total = [];
for i = 1:length(t_starts_gabung)
    idx = round(t_starts_gabung(i)*Fs) : round((t_starts_gabung(i)+durasi_siklus)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    [P_temp, f] = periodogram(seg_win, [], nfft, Fs);
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    
    if isempty(P_total); P_total = P_temp; else; P_total = P_total + P_temp; end
end
title('d. Single Spectrum');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;

% --- e. Averaged Spectrum (CLT Gabungan) ---
subplot(3,2,4);
P_averaged = P_total / length(t_starts_gabung);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title('e. Averaged Spectrum');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;
