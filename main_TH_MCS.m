close all

%% signal definition
L = 4096;
t = (0:L-1)'/L;

A = 45;
B = 4000;
phi1 = A*t+3/4*B*(t.^2)/2;
phi2 = 10*A*t+4/5*B*(t.^2)/2;
s_clean = exp(2*1i*pi*phi1) + exp(2*1i*pi*phi2);

Nr = 2;

%%
sigma_s = 1/sqrt(B);
% eta_lim = 1/sqrt(2*pi)*sqrt(1/sigma^2 + sigma^2*phipp^2);

Nfft = 512;
cas = 1;

% noise = (2.237)*(randn(L,1)+1i*randn(L,1));
FILE_ = load('noise3.mat');
noise = FILE_.noise;
% s_noise = sigmerge(s_clean, noise, -5);
s_noise = s_clean + noise;

[g, Lg] = create_gaussian_window(L, Nfft, sigma_s);

%% 2nd order computation
[TFR_noise, omega, omega2, q] = FM_operators(s_noise, Nfft, g, Lg, sigma_s);

% figure;
% imagesc(1:L, 1:Nfft, abs(TFR_noise));
% set(gca,'ydir','normal');
% axis square
% pause

[Cs] = exridge_n2_MCS(TFR_noise, q, Nr, sigma_s);

Cs(Cs == 0) = nan;

figure;
imagesc(1:L, 1:Nfft, abs(TFR_noise));
set(gca,'ydir','normal');
axis square
colormap(flipud(gray));
hold on;
plot(1:L, Cs);
hold off;
