Fs = 44100;
Q = 35;     

[b1, a1] = iirnotch(1300/(Fs/2), (1300/(Fs/2))/Q);
[b2, a2] = iirnotch(2000/(Fs/2), (2000/(Fs/2))/Q);

b_total = conv(b1, b2);
a_total = conv(a1, a2);

figure('Color', [1 1 1]);

% Respons Impuls
subplot(2,2,1);
[h, t] = impz(b_total, a_total, 101);
stem(t, h, 'LineWidth', 1.5, 'Marker', 'none');
title('Respons Impuls Filter');
xlabel('Sampel (n)');
ylabel('Amplitudo [h(n)]');
grid on;

% Peta Pole-Zero
subplot(2,2,2);
zplane(b_total, a_total);
title('Peta Pole-Zero Filter');
grid on;

% Respons Magnitudo (dB)
subplot(2,2,3);
[H, f] = freqz(b_total, a_total, 1024, Fs);
plot(f, 20*log10(abs(H)), 'LineWidth', 1.5);
title('Respons Magnitudo Filter');
xlabel('Frekuensi (Hz)');
ylabel('Magnitudo (dB)');
xlim([0 3250]); % Disesuaikan dengan gambar Anda
ylim([-50 5]);
grid on;

% Respons Fasa
subplot(2,2,4);
plot(f, angle(H), 'r', 'LineWidth', 1.5);
title('Respons Fasa Filter');
xlabel('Frekuensi (Hz)');
ylabel('Fasa (rad)');
xlim([0 3250]);
grid on;

sgtitle('Analisis Karakteristik Cascaded Notch Filter');v
