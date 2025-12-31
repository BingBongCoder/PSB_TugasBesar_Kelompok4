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

s1 = zeros(2, 1); 
s2 = zeros(2, 1);

while ishandle(hFig) && get(hFig,'UserData') == 0
    audioIn = mic();
    temp = zeros(size(audioIn));
    audioOut = zeros(size(audioIn));
    
    for n = 1:length(audioIn)
        w_curr = audioIn(n) - a1(2)*s1(1) - a1(3)*s1(2);
        curr_y = b1(1)*w_curr + b1(2)*s1(1) + b1(3)*s1(2);
        s1 = [w_curr; s1(1)];
        temp(n) = curr_y;
    end
    
    for n = 1:length(temp)
        w_curr = temp(n) - a2(2)*s2(1) - a2(3)*s2(2);
        curr_y = b2(1)*w_curr + b2(2)*s2(1) + b2(3)*s2(2);
        s2 = [w_curr; s2(1)];
        audioOut(n) = curr_y;
    end
    
    speaker(audioOut);
    fileWriterInput(audioIn);
    fileWriterOutput(audioOut);
    drawnow;
end

disp('Selesai');

%% Pekerjaan rutin: release memori
release(mic)
release(speaker)
release(fileWriterInput)
release(fileWriterOutput)
if ishandle(hFig)
    close(hFig);
end
