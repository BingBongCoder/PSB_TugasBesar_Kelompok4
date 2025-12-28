%% 1. Persiapan Data
[x, Fs] = audioread('kereta.aac');
s = x(:,1); 

% Menggabungkan titik mulai "tet" (14 segmen) dan "tot" (15 segmen) ideal
% Data diambil dari perhitungan manual di laporan [cite: 1240, 1245]
t_starts_tet = [1.60646, 3.43342, 5.26565, 7.08896, 8.91415, 10.7427, ...
                11.6568, 13.4838, 15.3159, 18.0407, 19.8694, 21.6945, ...
                23.525, 25.3521];
t_starts_tot = [0.695306, 2.52227, 4.35088, 6.17624, 8.00308, 9.82995, ...
                11.6568, 13.4838, 15.3159, 17.1375, 18.9644, 20.7913, ...
                22.6182, 24.4451, 26.2721];

t_starts_combined = [t_starts_tet, t_starts_tot];

durasi_pendek = 0.05; % Durasi sangat pendek (50ms) untuk simulasi "tet-tot"
nfft = 16384;         % Zero padding untuk resolusi visual

%% 2. Inisialisasi Plotting
figure('Color', 'w', 'Name', 'Analisis PSD Gabungan Pendek - tet..tot..');

% --- a. Measured Signals (Sekumpulan Segmen Pendek) ---
subplot(3,2,1); hold on;
colors = lines(length(t_starts_combined)); 
for i = 1:length(t_starts_combined)
    idx = round(t_starts_combined(i)*Fs) : round((t_starts_combined(i)+durasi_pendek)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['a. Sinyal "tet-tot"']);
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- b. Hamming Windowing Function ---
subplot(3,2,3);
win = hamming(round(durasi_pendek*Fs) + 1);
plot((0:length(win)-1)/Fs, win, 'r', 'LineWidth', 1.5);
title('b. Hamming Window');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- c. Windowed Signals (Gabungan Pendek) ---
subplot(3,2,5); hold on;
for i = 1:length(t_starts_combined)
    idx = round(t_starts_combined(i)*Fs) : round((t_starts_combined(i)+durasi_pendek)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win)-1)/Fs, seg_win, 'Color', colors(i,:));
end
title('c. Windowed Signals');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- d. Masing-masing Spektrum (Eksplorasi Resolusi) ---
subplot(3,2,2); hold on;
P_total = [];
for i = 1:length(t_starts_combined)
    idx = round(t_starts_combined(i)*Fs) : round((t_starts_combined(i)+durasi_pendek)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    [P_temp, f] = periodogram(seg_win, [], nfft, Fs);
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.2);
    
    if isempty(P_total); P_total = P_temp; else; P_total = P_total + P_temp; end
end
title('d. Spektrum Individu');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;

% --- e. Averaged Spectrum (CLT Gabungan Pendek) ---
subplot(3,2,4);
P_averaged = P_total / length(t_starts_combined);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title('e. Averaged Spectrum');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;
