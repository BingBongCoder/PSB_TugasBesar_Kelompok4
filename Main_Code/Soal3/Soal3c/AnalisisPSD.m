% Analisis Perbandingan menggunakan Power Spectral Density

[s_in, Fs] = audioread('mySpeechInput.wav');
[s_out, ~] = audioread('mySpeechOutput.wav');

window = hamming(2048); 
noverlap = 1024;        
nfft = 4096;            

[pxx_in, f_in] = pwelch(s_in, window, noverlap, nfft, Fs);
[pxx_out, f_out] = pwelch(s_out, window, noverlap, nfft, Fs);

figure('Color', [1 1 1]);
plot(f_in, 10*log10(pxx_in), 'r', 'LineWidth', 1, 'DisplayName', 'mySpeechInput.wav'); hold on;
plot(f_out, 10*log10(pxx_out), 'b', 'LineWidth', 1, 'DisplayName', 'mySpeechOutput.wav');

title('Analisis Perbandingan Power Spectral Density (PSD)');
xlabel('Frekuensi (Hz)');
ylabel('Power/Frequency (dB/Hz)');
xlim([0 3500]); 
grid on;
legend;

line([1300 1300], [-100 0], 'Color', 'k', 'LineStyle', '--');
line([2000 2000], [-100 0], 'Color', 'k', 'LineStyle', '--');
text(1300, -10, 'Notch 1', 'HorizontalAlignment', 'center');
text(2000, -10, 'Notch 2', 'HorizontalAlignment', 'center');
