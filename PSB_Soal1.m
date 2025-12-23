% TUGAS BESAR PSB SOAL 1
clear;
clc;
close all;

%% SOAL 1A
% Baca File Audio
[x, Fs] = audioread('kereta.aac');
n = length(x);
t = (0:n-1) / Fs;

% Membuat Sinyal Domain Waktu
figure(1);
subplot(2,1,1);
plot(t, x(:,1));
title('Sinyal Domain Waktu Suara Kereta Speaker Kiri');
xlabel('Waktu (t), Satuan Detik');
ylabel('Amplitudo [x(t)]');
subplot(2,1,2);
plot(t, x(:,2));
title('Sinyal Domain Waktu Suara Kereta Speaker Kanan');
xlabel('Waktu (t), Satuan Detik');
ylabel('Amplitudo [x(t)]');