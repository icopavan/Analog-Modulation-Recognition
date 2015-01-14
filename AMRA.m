function [ P, sigma_dp, gamma_max ] = AMRA( a, t_s, f_s )
%AMRA Summary of this function goes here
%   Detailed explanation goes here

    Ns = length(a);
    
    % gamma max - a measure of the carrier power
    a_cn = a - mean(a);
    a_cn = a_cn ./ max(a_cn);
    A_cn = fft(a_cn);
    temp = abs(A_cn).^2;
    [gamma_max, n_c] = max(temp(1:round(Ns/2)));
    
%     figure;
%     plot(abs(A_cn));
%     disp(abs(A_cn(n_c)));
%     disp(n_c * f_s/Ns);
    
    %P - a measure ofthe phase symmetry
    P_l = sum(abs(A_cn(1:n_c-1)))^2;
	P_u = sum(abs(A_cn(n_c+1:round(length(A_cn)/2))))^2;
    P = (P_l - P_u)/(P_l + P_u);
    
    %instantaneous phase
    Z = A_cn;
    Z(ceil(length(Z)/2):end) = 0;
    z = ifft(Z);
    z_p = atan2(imag(z), real(z));
    z_pu = z_p;
    
    %Phase unwrapping
    for n = 1:length(z_pu)-1
        if (z_pu(n+1) > z_pu(n) + pi)
            z_pu(n+1:end) = z_pu(n+1:end) - 2*pi;
        elseif (z_pu(n+1) < z_pu(n) - pi)
            z_pu(n+1:end) = z_pu(n+1:end) + 2*pi;
        end
    end
    
    %sigma_dp
    f_c = n_c * f_s/Ns;
    phi_nl = z_pu - 2*pi*f_c*t_s; %instantaneous, non-linear phase (AM)
    sigma_dp = std((phi_nl));
end

