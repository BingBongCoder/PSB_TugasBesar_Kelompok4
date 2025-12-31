%% Analisis PSD Sinyal Noise

Fs = 44100;

disp(" ");
disp("Analisis PSD Sinyal Noise");

x = audioread("mySpeechInput_noise.wav");
n = length(x);
t = (0:n-1) / Fs;
s = x(:,1); 
L = length(s);

% Membuat Sinyal Domain Waktu
figure('Color', 'w', 'Name', '3. Analisis Domain Waktu - Sinyal Noise');
plot(t, x(:,1));
title('Sinyal Domain Waktu Suara Kereta');
xlabel('Waktu (t), Satuan Detik');
ylabel('Amplitudo [x(t)]');

% Analisis PSD dengan Hanning Window

win_hanning = hann(L);

figure('Color', 'w', 'Name', '3. PSD Sinyal Noise');

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
xlim([0 2000]); 

grid on;

%% Analisis PSD Sinyal Suara Manusia dengan Noise

disp(" ");
disp("Analisis PSD Sinyal Suara Manusia dengan Noise");

x = audioread("mySpeechInput_speech.wav");
n = length(x);
t = (0:n-1) / Fs;
s = x(:,1); 
L = length(s);

% sampling frequency

Fs = 44100;

% Membuat Sinyal Domain Waktu
figure('Color', 'w', 'Name', '3. Analisis Domain Waktu - Sinyal Ucapan Manusia + Noise');
plot(t, x(:,1));
title('Sinyal Domain Waktu Suara Kereta');
xlabel('Waktu (t), Satuan Detik');
ylabel('Amplitudo [x(t)]');

% Analisis PSD dengan Hanning Window

win_hanning = hann(L);

figure('Color', 'w', 'Name', '3. PSD Sinyal Ucapan Manusia + Noise');

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
xlim([0 2000]); 

grid on;

%% Filter

x = audioread("mySpeechInput_speech.wav");

orde_LPF = 8;
resolusi_resp_frek = 32768;
impulse_signal = [1, zeros(1, 100)];
bandwidth_notch = 40;
bandwidth_comb = 80;

% Desain Filter

disp(" ");
disp("Desain Filter")

% Parameter Filter

Q = 35;
[b1, a1] = iirnotch(1300/(Fs/2), (1300/(Fs/2))/Q);
[b2, a2] = iirnotch(2000/(Fs/2), (2000/(Fs/2))/Q);

btot = conv(b1, b2);
atot = conv(a1, a2);

[z, p, k] = tf2zp(btot, atot);

[H, w] = freqz(btot, atot, resolusi_resp_frek, Fs);
htot = filter(btot, atot, impulse_signal);

figure('Color', 'w', 'Name', '3. Filter - Sinyal Noise - Butter Built-In');
disp(" ");
disp("Representasi Sistem Filter");

subplot(2,2,1);
plot(htot, 'LineWidth', 1.5);
title({'Respons Impuls Filter'});
xlabel('Sampel (n)'); 
ylabel('Amplitudo [h(n)]');
xlim([0 100]);

fprintf('Persamaan LCCDE Filter\n');
fprintf('y(n) = ');
for k = 2:length(atot)
    val_a = -atot(k);
    if (abs(val_a) < 1e-10)
        continue;
    elseif (k == 2)
        fprintf('(%.4g)y[n-%d] ', val_a, k-1);
    else
        sign_c = '+ '; if val_a < 0, sign_c = ''; end
        fprintf('%s(%.4g)y[n-%d] ', sign_c, val_a, k-1);
    end
end
fprintf('+ ');
for k = 1:length(btot)
    if k == 1
        fprintf('(%.4g)x[n] ', btot(k));
    else
        sign_c = '+ '; if btot(k) < 0, sign_c = ''; end
        fprintf('%s(%.4g)x[n-%d] ', sign_c, btot(k), k-1);
    end
end
disp(" ");

subplot(2,2,2);
zplane(z, p);
title({'Peta Pole-Zero Filter'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

subplot(2,2,3);
plot(w, 20*log10(abs(H)), 'LineWidth', 0.5);
title({'Respons Magnitudo Filter'});
xlabel('Frekuensi (Hz)'); 
ylabel('Magnitudo (dB)');
xlim([0 3250]); 

subplot(2,2,4);
plot(w, angle(H), 'Color', [0.85, 0.1, 0.1], 'LineWidth', 0.5);
title({'Respons Fasa Filter'});
xlabel('Frekuensi (Hz)'); 
ylabel('Fasa (rad)');
xlim([0 3250]);

disp(" ");
disp("Menghasilkan Audio Terfilter");

y_temp = filter(b1, a1, x);
y = filter(b2, a2, y_temp);

y_norm = y / max(abs(y));
audiowrite('mySpeechOutput.wav', y_norm, Fs);
disp(" ");
disp("File audio hasil keluaran filter telah dibuat");
