
function [tshat,envelope,coeff]=f0param(ts,f0,fs)
%Uses the time series sigma, the guessed frequency f0 and the sample
%frequency fs to parameterize the signal. The output sighat is the
%parameterized reconstruction of sigma, envelope is the envelope of the
%signal (average of sliding minimum and maximum), body is the body
%component of the signal (sliding minimum) and coeff contains the
%coefficients for the sine and cosine functions describing the oscillating
%signal component.

vert=size(ts,2)>size(ts,1);

if vert
    ts=ts';
end

L=length(ts);
t=(1:L)'/fs;



envelope=envfilt(sum(ts,2),f0,fs); % Common anvelope for all bands
envelope=envelope/max(envelope); % Same normalization as wave functions


regressor=ones(L,1);

for h=1:floor((fs/2)/f0) % Here it is possible to add harmonics beyound Nyquist
    regressor=[regressor sin(2*pi*h*f0*t) cos(2*pi*h*f0*t)];
    
end

regressor=regressor.*repmat(envelope,[1 size(regressor,2)]); % Apodizing wave functions with envelope (super important step)


for b=1:size(ts,2) %
    
    coeff(:,b)=regressor\ts(:,b);
    
    if vert
    tshat(b,:)=(regressor*coeff(:,b))';
    else
    tshat(:,b)=regressor*coeff(:,b);        
    end
end
end