% Ganti bagian Setting dan Loop dengan kode di bawah ini:

%% Setting
Fs = 44100; 
frameSize = 1024;

mic = audioDeviceReader('SampleRate', Fs, 'SamplesPerFrame', frameSize);
speaker = audioDeviceWriter('SampleRate', Fs);

fileWriterInput = dsp.AudioFileWriter('mySpeechInput.wav','FileFormat','WAV','SampleRate',Fs);
fileWriterOutput = dsp.AudioFileWriter('mySpeechOutput.wav','FileFormat','WAV','SampleRate',Fs);

% Desain Filter Notch untuk 1300 Hz dan 2000 Hz
Q = 35; 
[b1, a1] = iirnotch(1300/(Fs/2), (1300/(Fs/2))/Q);
[b2, a2] = iirnotch(2000/(Fs/2), (2000/(Fs/2))/Q);

% Inisialisasi State
z1 = zeros(max(length(a1), length(b1))-1, 1);
z2 = zeros(max(length(a2), length(b2))-1, 1);

%% Proses
disp('Silakan bicara sekarang...');
hFig = figure('Name','Tekan tombol apapun untuk berhenti','KeyPressFcn', @(src,event) set(src,'UserData',1));
set(hFig,'UserData',0);

while ishandle(hFig) && get(hFig,'UserData') == 0
    audioIn  = mic();
    
    % --- Implementasi Filter Cascaded dengan State Management ---
    % Filter tahap 1: Potong 1300 Hz
    [temp, z1] = filter(b1, a1, audioIn, z1);
    
    % Filter tahap 2: Potong 2000 Hz
    [audioOut, z2] = filter(b2, a2, temp, z2);
    
    speaker(audioOut);
    fileWriterInput(audioIn);
    fileWriterOutput(audioOut);
    drawnow;
end

disp('Selesai');
% ... (release memori tetap sama)
