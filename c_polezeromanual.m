% Pole-zero Manual
disp ('Penempatan Pole-Zero Manual')
disp ('- Sinyal "teeet" -')
figure('Color', 'w', 'Name', 'Penempatan Pole-Zero Manual');

% Penempatan Pole-Zero Manual Sinyal "teeet"
f_teeet = [758.372, 1516.74, 2275.12];
r = 0.998; % r dari bw = 25Hz

% Parameter 
w_teeet1 = 2 * pi * (f_teeet(1) / Fs);
w_teeet2 = 2 * pi * (f_teeet(2) / Fs);
w_teeet3 = 2 * pi * (f_teeet(3) / Fs);

% Pole
p1_teeet1 = r * exp(1i * w_teeet1);     
p2_teeet1 = r * exp(-1i * w_teeet1);
list_p_teet1 = [p1_teeet1, p2_teeet1];
p1_teeet2 = r * exp(1i * w_teeet2);     
p2_teeet2 = r * exp(-1i * w_teeet2);
list_p_teet2 = [p1_teeet2, p2_teeet2];
p1_teeet3 = r * exp(1i * w_teeet3);     
p2_teeet3 = r * exp(-1i * w_teeet3);
list_p_teet3 = [p1_teeet3, p2_teeet3];

% Zero
list_z = [1; -1]; % w = pi dan 0

% Array Pole-Zero
p_teeet1 = [];
z_teeet1 = [];
p_teeet2 = [];
z_teeet2 = [];
p_teeet3 = [];
z_teeet3 = [];

% Eksekusi
p_teeet1 = [p_teeet1; list_p_teet1];
z_teeet1 = [z_teeet1; list_z];
p_teeet2 = [p_teeet2; list_p_teet2];
z_teeet2 = [z_teeet2; list_z];
p_teeet3 = [p_teeet3; list_p_teet3];
z_teeet3 = [z_teeet3; list_z];

k = 1; % Gain awal
[b_teeet1, a_teeet1] = zp2tf(z_teeet1, p_teeet1, k);
[b_teeet2, a_teeet2] = zp2tf(z_teeet2, p_teeet2, k);
[b_teeet3, a_teeet3] = zp2tf(z_teeet3, p_teeet3, k);

% Peta Pole-Zero
subplot(2,1,1);
zplane(b_teeet1, a_teeet1);
hold on;
zplane(b_teeet2, a_teeet2);
zplane(b_teeet3, a_teeet3);
hold off;
title({'Peta Pole-Zero Manual Sinyal "teeet"'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% LCCDE
fprintf('Persamaan LCCDE Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(a_teeet1)
        val_a = -a_teeet1(k); % Dibalik tandanya karena pindah ruas ke kanan
        fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
end
for k = 1:length(b_teeet1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', b_teeet1(k));
    else
        sign_char = '+'; 
        if b_teeet1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, b_teeet1(k), k-1);
    end
end
fprintf('\nPersamaan LCCDE Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(a_teeet2)
        val_a = -a_teeet2(k); % Dibalik tandanya karena pindah ruas ke kanan
        fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
end
for k = 1:length(b_teeet2)
    if k == 1
        fprintf('%s(%.4g)x[n] ', b_teeet2(k));
    else
        sign_char = '+'; 
        if b_teeet2(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, b_teeet2(k), k-1);
    end
end
fprintf('\nPersamaan LCCDE Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(a_teeet3)
        val_a = -a_teeet3(k); % Dibalik tandanya karena pindah ruas ke kanan
        fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
end
for k = 1:length(b_teeet3)
    if k == 1
        fprintf('%s(%.4g)x[n] ', b_teeet3(k));
    else
        sign_char = '+'; 
        if b_teeet3(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, b_teeet3(k), k-1);
    end
end

fprintf('\n\n')

disp ('- Sinyal "tooot" -')
% Penempatan Pole-Zero Manual Sinyal "tooot"
f_tooot = [555.826, 1111.65, 1667.48];
r = 0.998; % r dari bw = 25Hz

% Parameter 
w_tooot1 = 2 * pi * (f_tooot(1) / Fs);
w_tooot2 = 2 * pi * (f_tooot(2) / Fs);
w_tooot3 = 2 * pi * (f_tooot(3) / Fs);

% Pole
p1_tooot1 = r * exp(1i * w_tooot1);     
p2_tooot1 = r * exp(-1i * w_tooot1);
list_p_teet1 = [p1_tooot1, p2_tooot1];
p1_tooot2 = r * exp(1i * w_tooot2);     
p2_tooot2 = r * exp(-1i * w_tooot2);
list_p_teet2 = [p1_tooot2, p2_tooot2];
p1_tooot3 = r * exp(1i * w_tooot3);     
p2_tooot3 = r * exp(-1i * w_tooot3);
list_p_teet3 = [p1_tooot3, p2_tooot3];

% Zero
list_z = [1; -1]; % w = pi dan 0

% Array Pole-Zero
p_tooot1 = [];
z_tooot1 = [];
p_tooot2 = [];
z_tooot2 = [];
p_tooot3 = [];
z_tooot3 = [];

% Eksekusi
p_tooot1 = [p_tooot1; list_p_teet1];
z_tooot1 = [z_tooot1; list_z];
p_tooot2 = [p_tooot2; list_p_teet2];
z_tooot2 = [z_tooot2; list_z];
p_tooot3 = [p_tooot3; list_p_teet3];
z_tooot3 = [z_tooot3; list_z];

k = 1; % Gain awal
[b_tooot1, a_tooot1] = zp2tf(z_tooot1, p_tooot1, k);
[b_tooot2, a_tooot2] = zp2tf(z_tooot2, p_tooot2, k);
[b_tooot3, a_tooot3] = zp2tf(z_tooot3, p_tooot3, k);

% Peta Pole-Zero
subplot(2,1,2);
zplane(b_tooot1, a_tooot1);
hold on;
zplane(b_tooot2, a_tooot2);
zplane(b_tooot3, a_tooot3);
hold off;
title({'Peta Pole-Zero Manual Sinyal "tooot"'});
xlabel('Re(z)'); 
ylabel('Im(z)');
ylim([-1.5 1.5]);
xlim([-1.5 1.5]);

% LCCDE
fprintf('Persamaan LCCDE Frekuensi Fundamental\n');
fprintf('y(n) = ');
for k = 2:length(a_tooot1)
        val_a = -a_tooot1(k); % Dibalik tandanya karena pindah ruas ke kanan
        fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
end
for k = 1:length(b_tooot1)
    if k == 1
        fprintf('%s(%.4g)x[n] ', b_tooot1(k));
    else
        sign_char = '+'; 
        if b_tooot1(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, b_tooot1(k), k-1);
    end
end
fprintf('\nPersamaan LCCDE Frekuensi Harmonik 1\n');
fprintf('y(n) = ');
for k = 2:length(a_tooot2)
        val_a = -a_tooot2(k); % Dibalik tandanya karena pindah ruas ke kanan
        fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
end
for k = 1:length(b_tooot2)
    if k == 1
        fprintf('%s(%.4g)x[n] ', b_tooot2(k));
    else
        sign_char = '+'; 
        if b_tooot2(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, b_tooot2(k), k-1);
    end
end
fprintf('\nPersamaan LCCDE Frekuensi Harmonik 2\n');
fprintf('y(n) = ');
for k = 2:length(a_tooot3)
        val_a = -a_tooot3(k); % Dibalik tandanya karena pindah ruas ke kanan
        fprintf('+ (%.4g)y[n-%d] ', val_a, k-1);
end
for k = 1:length(b_tooot3)
    if k == 1
        fprintf('%s(%.4g)x[n] ', b_tooot3(k));
    else
        sign_char = '+'; 
        if b_tooot3(k) < 0
            sign_char = ''; 
        end
        fprintf('%s(%.4g)x[n-%d] ', sign_char, b_tooot3(k), k-1);
    end
end