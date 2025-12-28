%% 1. Persiapan Data
[x, Fs] = audioread('kereta.aac');
s = x(:,1); 

% Mengambil seluruh segmen "tooot" (t1 sampai t15) berdasarkan laporan 
% Data waktu mulai (t_starts) diambil dari perhitungan manual Anda
t_starts_tooot = [0.695306, 2.52227, 4.35088, 6.17624, 8.00308, 9.82995, ...
                  11.6568, 13.4838, 15.3159, 17.1375, 18.9644, 20.7913, ...
                  22.6182, 24.4451, 26.2721]; 

durasi_tooot = 0.9094; % Rata-rata durasi tooot ideal [cite: 699]
nfft = 16384;          % Zero padding untuk hasil spektrum yang halus

%% 2. Inisialisasi Plotting
figure('Color', 'w', 'Name', 'Analisis PSD Lengkap - Sinyal Tooot');

% --- a. Measured Signals (Seluruh Segmen Tooot) ---
subplot(3,2,1); hold on;
colors = lines(length(t_starts_tooot)); 
for i = 1:length(t_starts_tooot)
    idx = round(t_starts_tooot(i)*Fs) : round((t_starts_tooot(i)+durasi_tooot)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['a. Sekumpulan Sinyal "tooot" (', num2str(length(t_starts_tooot)), ' Segmen)']);
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- b. Hamming Windowing Function ---
subplot(3,2,3);
win = hamming(round(durasi_tooot*Fs) + 1);
plot((0:length(win)-1)/Fs, win, 'r', 'LineWidth', 1.5);
title('b. Hamming Windowing Function');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- c. Windowed Signals (Seluruh Segmen Tooot) ---
subplot(3,2,5); hold on;
for i = 1:length(t_starts_tooot)
    idx = round(t_starts_tooot(i)*Fs) : round((t_starts_tooot(i)+durasi_tooot)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win)-1)/Fs, seg_win, 'Color', colors(i,:));
end
title('c. Windowed Signals (Seluruh Segmen)');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- d. Masing-masing Spektrum (Eksplorasi Variansi) ---
subplot(3,2,2); hold on;
P_total = [];
for i = 1:length(t_starts_tooot)
    idx = round(t_starts_tooot(i)*Fs) : round((t_starts_tooot(i)+durasi_tooot)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    [P_temp, f] = periodogram(seg_win, [], nfft, Fs);
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    
    if isempty(P_total); P_total = P_temp; else; P_total = P_total + P_temp; end
end
title('d. Masing-masing Spektrum Segmen');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;

% --- e. Averaged Spectrum (Teorema Central Limit) ---
subplot(3,2,4);
P_averaged = P_total / length(t_starts_tooot);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['e. Averaged Spectrum (CLT - ', num2str(length(t_starts_tooot)), ' Segmen)']);
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;
