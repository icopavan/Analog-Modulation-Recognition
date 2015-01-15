%%
% read real AM data
real_am_data = read_float_binary('am_usrp710.dat')';
fs = 256e3;

%%
% filter channel data

order = 50;
fc = 40.0039e3;
width = 10e3;
fcol = fc - width;
fcoh = fc + width;
filter = fir1(order, [2*fcol/fs, 2*fcoh/fs]);
real_am_1 = conv(real_am_data, filter, 'valid');

order = 50;
fc = 80e3 - 3.16;
width = 10e3;
fcol = fc - width;
fcoh = fc + width;
filter = fir1(order, [2*fcol/fs, 2*fcoh/fs]);
real_am = conv(real_am_data, filter, 'valid');

%%
% take clips from am and do AMR
Ns = 4096*2; %desired no of samples
ts = 0:1/fs:(Ns-1)/fs; %timebase at desired sampling rate

clips = 200;
P_real_am = zeros(1,clips);
sigma_dp_real_am = zeros(1,clips);
gamma_max_real_am = zeros(1,clips);
P_real_am_1 = zeros(1,clips);
sigma_dp_real_am_1 = zeros(1,clips);
gamma_max_real_am_1 = zeros(1,clips);
for i = 1:clips;
    si = floor((length(real_am)-2*Ns)*rand()) + Ns;
    sf = si + Ns-1;
    real_am_clip = real_am(si:sf);
    
    real_am_clip_1 = real_am_1(si:sf);
    
    [P_real_am(i), sigma_dp_real_am(i), gamma_max_real_am(i)] = AMRA(real_am_clip, ts, fs);
    [P_real_am_1(i), sigma_dp_real_am_1(i), gamma_max_real_am_1(i)] = AMRA(real_am_clip_1, ts, fs);
end

%%
% read real fm data
real_fm_data = read_float_binary('FM1027e5min80e3.bin')';
fs = 256e3;

%%
% filter
real_fm = conv(real_fm_data, filter, 'valid');

%% 
% take clips from FM and do AMR
P_real_fm = zeros(1,clips);
sigma_dp_real_fm = zeros(1,clips);
gamma_max_real_fm = zeros(1,clips);
for i = 1:clips;
    si = floor((length(real_fm)-2*Ns)*rand()) + Ns;
    sf = si + Ns-1;
    real_fm_clip = real_fm(si:sf);
    
    [P_real_fm(i), sigma_dp_real_fm(i), gamma_max_real_fm(i)] = AMRA(real_fm_clip, ts, fs);
end

%%
%Import audio, take clip, upsample and do AMR
[audio, f_audio] = audioread('02.mp3');

samp_ratio = fs/f_audio;
N_s_audio = ceil(Ns / samp_ratio); %number of audio samples that would translate to desired numer of samples if upsampled
t_clip = 0:1/f_audio:N_s_audio/f_audio; %timebase of the audio clip, prior to upsampling

P_am = zeros(1,clips);
sigma_dp_am = zeros(1,clips);
gamma_max_am = zeros(1,clips);
P_fm = zeros(1,clips);
sigma_dp_fm = zeros(1,clips);
gamma_max_fm = zeros(1,clips);
f_c = 80e3;
for i = 1:clips
    si = round((length(audio)-2*N_s_audio)*rand()) + N_s_audio;
    sf = si + N_s_audio;
    audio_clip = audio(si:sf); %take random clip from audio
    
    %upsample the clip using cubic interpolation.
    x = interp1(t_clip, audio_clip, ts, 'cubic'); 

    %AM and FM signal generation
    s_am = (1+x).*cos(2*pi*f_c.*ts) + 0.5*normrnd(1,1,1,Ns);
    s_am = conv(s_am,filter,'same');
    
    s_fm = cos(2*pi*f_c.*ts + cumsum(x)) + 0.5*normrnd(1,1,1,Ns);
    s_fm = conv(s_fm, filter, 'same');
    
    [P_am(i), sigma_dp_am(i), gamma_max_am(i)] = AMRA(s_am, ts, fs);
    [P_fm(i), sigma_dp_fm(i), gamma_max_fm(i)] = AMRA(s_fm, ts, fs);
end

%%
% just AWGN, no signal

P_n = zeros(1,clips);
sigma_dp_n = zeros(1,clips);
gamma_max_n = zeros(1,clips);

for i = 1:clips
   noise = conv(normrnd(1,1,1,Ns+length(filter)-1),filter,'valid');
   [P_n(i), sigma_dp_n(i), gamma_max_n(i)] = AMRA(noise,ts,fs);
end


%%
% plot
figure;
hold on
dot_size = 10;
%add to plot
scatter3(gamma_max_am, P_am, sigma_dp_am, dot_size, [1,0,0], 'fill');
scatter3(gamma_max_fm, P_fm, sigma_dp_fm, dot_size, [0,0,1], 'fill');
scatter3(gamma_max_real_am, P_real_am, sigma_dp_real_am, dot_size, [0,1,0], 'fill');
scatter3(gamma_max_real_am_1, P_real_am_1, sigma_dp_real_am_1, dot_size, [1,0,1], 'fill');
scatter3(gamma_max_real_fm, P_real_fm, sigma_dp_real_fm, dot_size, [1,1,0], 'fill');
scatter3(gamma_max_n, P_n, sigma_dp_n, dot_size, [0,1,1], 'fill');
hold off;

xlabel('gamma_max');
ylabel('P');
zlabel('sigma_dp');
legend('Music AM modulated with f_c = 80kHz, gaussian noise added', 'Music FM Modulated with f_c = 80kHz, gaussain noise added', 'Real AM, nice sound at f_c = 80kHz', 'Real AM terrible sound at f_c = 40kHz', 'Real FM', 'AWGN');