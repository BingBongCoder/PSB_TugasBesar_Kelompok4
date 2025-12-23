% TUGAS BESAR PSB SOAL 1
clear;
clc;
close all;

%% SOAL 1a
% Baca File Audio
[x, Fs] = audioread('kereta.aac');
n = length(x);
t = (0:n-1) / Fs;

% Memeriksa Apakah Audio Speaker Kiri Sama dengan Audio Speaker Kanan
KananKiriEqual = isequal(x(:,1), x(:,2));
if(KananKiriEqual)
    disp("Audio speaker kanan dan kiri sama");
else
    disp("Audio speaker kanan dan kiri tidak sama");
end

% Membuat Sinyal Domain Waktu
figure(1);
plot(t, x(:,1));
title('Sinyal Domain Waktu Suara Kereta');
xlabel('Waktu (t), Satuan Detik');
ylabel('Amplitudo [x(t)]');
