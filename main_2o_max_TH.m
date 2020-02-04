close all

%% signal definition
L = 4096;
t = (0:L-1)'/L;

A = 45;
B = 4000;
phi = A*t+B*(t.^2)/2;
s_clean = (3/4)*exp(2*1i*pi*phi);
phip = A + B*t;
phipp = B*ones(L, 1);

%%
sigma = 1/sqrt(B);

Nfft = 512;
cas = 1;

noise = randn(L,1)+1i*randn(L,1);
s_noise = sigmerge(s_clean, noise, -10);
% FILE_ = load('s_noise_cas1.mat');
% s_noise = FILE_.s_noise;

[g, Lg] = create_gaussian_window(L, Nfft, sigma);


[TFR_s_noise] = tfrstft(s_noise, Nfft, cas, g, Lg);

% [TFR_noise] = tfrstft(s_noise - s_clean, Nfft, cas, g, Lg);
% 
% [TFR_s] = tfrstft(s_clean, Nfft, cas, g, Lg);
% 
% diff = abs(TFR_noise) + abs(TFR_s) - abs(TFR_s_noise);
% 
% fus = diff + TFR_noise;

figure;
imagesc(1:L, 1:L, abs(TFR_noise));
set(gca,'ydir','normal');
axis square
hold on;
%zn_vt = floor(sqrt((2*Lg+1)/(2*pi)));
zn_vt = floor(2/3*Lg);
%zn_vf = zn_vt*Nfft/L;
D = 2*Lg+1;
for i=zn_vt:zn_vt:L
    plot([i, i], [1, L], 'r--');
end
for i=zn_vt:zn_vt:L
    plot([1, L], [i, i], 'k--');
end
hold off;

pause

%% 2nd order computation
[TFR_s_noise, omega, omega2, q] = FM_operators(s_noise, Nfft, g, Lg, sigma);

% [Cs] = exridge(TFR_noise, 0, 0, 10);
% figure;
% imagesc((0:L-1)/L, (L/Nfft)*(1:Nfft), abs(TFR_noise));
% set(gca,'ydir','normal');
% axis square
% hold on;
% plot((0:L-1)/L, Cs(:)*L/Nfft, 'r');
% hold off;

exridge_new(TFR_s_noise, Lg, sigma, q, omega, omega2, 2);

% tt1 = 1076;
% tt2 = 1114;
% % D = tt2-tt1+1;
% k1 = 138;
% k2 = 139;
% k3 = 140;
% % Y = zeros(D, 3);
% 
% % for n=tt1:tt2
% %     Y(n - tt1+1, 1) = mean(mean(abs(TFR_noise(k1:k2, n:(n+1)))));
% %     Y(n - tt1+1, 2) = mean(mean(abs(TFR_noise(k2, n:(n+1)))));
% %     Y(n - tt1+1, 3) = mean(mean(abs(TFR_noise(k2:k3, n:(n+1)))));
% % end
% % 
% % figure;
% % range=tt1:tt2;
% % hold on;
% % plot(range, Y(:, 1), 'DisplayName', 'Y1');
% % plot(range, Y(:, 2), 'DisplayName', 'Y2');
% % plot(range, Y(:, 3), 'DisplayName', 'Y3');
% % legend;
% % hold off;
% 
% figure;
% range=tt1:tt2;
% hold on;
% plot(abs(TFR_noise(k1, range)), 'DisplayName', 'y1');
% plot(abs(TFR_noise(k2, range)), 'DisplayName', 'y2');
% plot(abs(TFR_noise(k3, range)), 'DisplayName', 'y3');
% legend;
% hold off;