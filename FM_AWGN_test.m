%%
%Import audio, take clip, upsample and do AMR
[audio, f_audio] = audioread('02.mp3');

samp_ratio = fs/f_audio;
N_s_audio = ceil(Ns / samp_ratio); %number of audio samples that would translate to desired numer of samples if upsampled
t_clip = 0:1/f_audio:N_s_audio/f_audio; %timebase of the audio clip, prior to upsampling

f_c = 80e3;
clips = 1000;

P_fm = zeros(1,clips);
sigma_dp_fm = zeros(1,clips);
gamma_max_fm = zeros(1,clips);
for i = 1:clips
    si = round((length(audio)-2*N_s_audio)*rand()) + N_s_audio;
    sf = si + N_s_audio;
    audio_clip = audio(si:sf); %take random clip from audio
    
    %upsample the clip using cubic interpolation.
    x = interp1(t_clip, audio_clip, ts, 'cubic'); 
    
    s_fm = cos(2*pi*f_c.*ts + cumsum(x)) + clips/i*normrnd(1,1,1,Ns);
    s_fm = conv(s_fm, filter, 'same');
    
    [P_fm(i), sigma_dp_fm(i), gamma_max_fm(i)] = AMRA(s_fm, ts, fs);
end

figure;
dot_size = 10;
scatter3(gamma_max_am, (1:1:clips)/clips , sigma_dp_am, dot_size, [1,0,0], 'fill');
xlabel('gamma_ma}');
ylabel('signal to noise raio');
zlabel('sigma_dp');
