%% 1. Persiapan Data
[x, Fs] = audioread('kereta.aac');
s = x(:,1); 

% Mengambil segmen "teeet" tapi dipotong sangat pendek untuk simulasi "tet"
% Kita gunakan titik mulai yang sama dengan teeet ideal (t2-t15) [cite: 739]
t_starts_tet = [1.60646, 3.43342, 5.26565, 7.08896, 8.91415, 10.7427, ...
                11.6568, 13.4838, 15.3159, 18.0407, 19.8694, 21.6945, ...
                23.525, 25.3521]; 

durasi_tet = 0.05; % Durasi sangat pendek (50ms) untuk simulasi suara "tet"
nfft = 16384;      % Zero padding tetap digunakan untuk kehalusan visual [cite: 742]

%% 2. Inisialisasi Plotting
figure('Color', 'w', 'Name', 'Analisis PSD Sinyal TET (Durasi Pendek)');

% --- a. Measured Signals (Sekumpulan Sinyal TET) ---
subplot(3,2,1); hold on;
colors = lines(length(t_starts_tet)); 
for i = 1:length(t_starts_tet)
    idx = round(t_starts_tet(i)*Fs) : round((t_starts_tet(i)+durasi_tet)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:));
end
title(['a. Sekumpulan Sinyal "tet" (', num2str(length(t_starts_tet)), ' Segmen)']);
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- b. Hamming Windowing Function ---
subplot(3,2,3);
win = hamming(round(durasi_tet*Fs) + 1);
plot((0:length(win)-1)/Fs, win, 'r', 'LineWidth', 1.5);
title('b. Hamming Windowing Function');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- c. Windowed Signals (TET) ---
subplot(3,2,5); hold on;
for i = 1:length(t_starts_tet)
    idx = round(t_starts_tet(i)*Fs) : round((t_starts_tet(i)+durasi_tet)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win)-1)/Fs, seg_win, 'Color', colors(i,:));
end
title('c. Windowed Signals');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- d. Masing-masing Spektrum (Resolusi Rendah) ---
subplot(3,2,2); hold on;
P_total = [];
for i = 1:length(t_starts_tet)
    idx = round(t_starts_tet(i)*Fs) : round((t_starts_tet(i)+durasi_tet)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    [P_temp, f] = periodogram(seg_win, [], nfft, Fs);
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    
    if isempty(P_total); P_total = P_temp; else; P_total = P_total + P_temp; end
end
title('d. Single Spectrum');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;

% --- e. Averaged Spectrum (CLT pada Durasi Pendek) ---
subplot(3,2,4);
P_averaged = P_total / length(t_starts_tet);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title('e. Averaged Spectrum');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;
