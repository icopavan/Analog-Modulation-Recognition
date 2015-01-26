%%
%Import audio
[audio, f_audio] = audioread('02.mp3');
fs = 256e3;
Ns = 4096*2; %desired no of samples

samp_ratio = fs/f_audio;
N_s_audio = ceil(Ns / samp_ratio); %number of audio samples that would translate to desired numer of samples if upsampled
t_clip = 0:1/f_audio:N_s_audio/f_audio; %timebase of the audio clip, prior to upsampling


ts = 0:1/fs:(Ns-1)/fs; %timebase at desired sampling rate

%%
% filter
order = 50;
fc = 80e3 - 3.16;
width = 10e3;
fcol = fc - width;
fcoh = fc + width;
filter = fir1(order, [2*fcol/fs, 2*fcoh/fs]);

%%
% Generation and feature extraction
f_c = 80e3;
j_max = 10000;

snr = zeros(1,j_max);
sigma_dp = zeros(1,j_max);
gamma_max = zeros(1,j_max);

for j = 1:j_max
    si = round((length(audio)-2*N_s_audio)*rand()) + N_s_audio;
    sf = si + N_s_audio;
    audio_clip = audio(si:sf);
    
    x = interp1(t_clip, audio_clip, ts, 'cubic'); 
    
    s = cos(2*pi*f_c.*ts + cumsum(x)) + 0.5*normrnd(1,1,1,Ns);
    s = conv(s, filter, 'same');
    
    [~, sigma_dp(j), gamma_max(j)] = AMRA(s, ts, fs);
end
%%
hist(sigma_dp,100)
