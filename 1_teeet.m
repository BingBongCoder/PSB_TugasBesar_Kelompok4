%% 1. Persiapan Data
[x, Fs] = audioread('kereta.aac');
s = x(:,1); 

% Mengambil seluruh segmen "teeet" ideal (t2 sampai t15) berdasarkan soal nomor 1
t_starts = [1.60646, 3.43342, 5.26565, 7.08896, 8.91415, 10.7427, ...
            11.6568, 13.4838, 15.3159, 18.0407, 19.8694, 21.6945, ...
            23.525, 25.3521]; 

durasi = 0.9169; 
nfft = 16384;    % Zero padding untuk resolusi visual

%% 2. Inisialisasi Plotting
figure('Color', 'w', 'Name', 'Analisis PSD Lengkap - Sinyal Teeet');

% --- a. Measured Signals (Seluruh Segmen Ideal) ---
subplot(3,2,1); hold on;
colors = lines(length(t_starts)); 
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg = s(idx);
    plot((0:length(seg)-1)/Fs, seg, 'Color', colors(i,:), 'LineWidth', 0.5);
end
title(['a. Sekumpulan Sinyal "teeet" (', num2str(length(t_starts)), ' Segmen)']);
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- b. Hamming Windowing Function ---
subplot(3,2,3);
win = hamming(round(durasi*Fs) + 1);
plot((0:length(win)-1)/Fs, win, 'r', 'LineWidth', 1.5);
title('b. Hamming Windowing Function');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- c. Windowed Signals ---
subplot(3,2,5); hold on;
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    plot((0:length(seg_win)-1)/Fs, seg_win, 'Color', colors(i,:));
end
title('c. Windowed Signals (Seluruh Segmen)');
xlabel('Waktu (detik)'); ylabel('Amplitudo'); grid on;

% --- d. Single Spectrum ---
subplot(3,2,2); hold on;
P_total = [];
for i = 1:length(t_starts)
    idx = round(t_starts(i)*Fs) : round((t_starts(i)+durasi)*Fs);
    seg_win = s(idx) .* hamming(length(s(idx)));
    [P_temp, f] = periodogram(seg_win, [], nfft, Fs);
    plot(f, 10*log10(P_temp), 'Color', colors(i,:), 'LineWidth', 0.3);
    
    if isempty(P_total); P_total = P_temp; else; P_total = P_total + P_temp; end
end
title('d. Single Spectrum');
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;

% --- e. Averaged Spectrum ---
subplot(3,2,4);
P_averaged = P_total / length(t_starts);
plot(f, 10*log10(P_averaged), 'm', 'LineWidth', 1.5);
title(['e. Averaged Spectrum']);
xlabel('Frekuensi (Hz)'); ylabel('Power (dB)'); xlim([0 2000]); grid on;
