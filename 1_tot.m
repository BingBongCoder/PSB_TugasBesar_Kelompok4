%% 1. Persiapan Data
[x, Fs] = audioread('kereta.aac');
s = x(:,1); 

% Mengambil segmen "tooot" tapi dipotong sangat pendek untuk simulasi "tot"
% Menggunakan 15 segmen tooot ideal dari laporan Anda 
t_starts_tot = [0.695306, 2.52227, 4.35088, 6.17624, 8.00308, 9.82995, ...
                11.6568, 13.4838, 15.3159, 17.1375, 18.9644, 20.7913, ...
                22.6182, 24.4451, 26.2721]; 

durasi_tot = 0.05; % Durasi sangat pendek (50ms) untuk simulasi suara "tot"
nfft = 16384;      % Zero padding tetap digunakan untuk kehalusan visual

%% 2. Inisialisasi Plotting
figure('Color', 'w', 'Name', 'Analisis PSD Sinyal TOT (Durasi Pendek)');

% --- a. Measured Signals (Sekumpulan Sinyal TOT) ---
subplot(3,2,1); hold on;
colors = lines(length(t_starts_tot)); 
for i = 1:length(t_starts_tot)
    idx = round(t_starts_tot(i)*Fs) : round((t_starts_tot(i)+durasi_tot)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:));
end
title(['a. Sekumpulan Sinyal "tot" (', num2str(length(t_starts_tot)), ' Segmen)']);
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- b. Hamming Windowing Function ---
subplot(3,2,3);
win = hamming(round(durasi_tot*Fs) + 1);
plot((0:length(win)-1)/Fs, win, 'r', 'LineWidth', 1.5);
title('b. Hamming Windowing Function');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- c. Windowed Signals (TOT) ---
subplot(3,2,5); hold on;
for i = 1:length(t_starts_tot)
    idx = round(t_starts_tot(i)*Fs) : round((t_starts_tot(i)+durasi_tot)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win)-1)/Fs, seg_win, 'Color', colors(i,:));
end
title('c. Windowed Signals');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- d. Masing-masing Spektrum (Pelebaran Spektrum) ---
subplot(3,2,2); hold on;
P_total = [];
for i = 1:length(t_starts_tot)
    idx = round(t_starts_tot(i)*Fs) : round((t_starts_tot(i)+durasi_tot)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    [P_temp, f] = periodogram(seg_win, [], nfft, Fs);
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    
    if isempty(P_total); P_total = P_temp; else; P_total = P_total + P_temp; end
end
title('d. Spektrum Segmen');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;

% --- e. Averaged Spectrum (CLT pada Durasi Pendek) ---
subplot(3,2,4);
P_averaged = P_total / length(t_starts_tot);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title('e. Averaged Spectrum');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;
