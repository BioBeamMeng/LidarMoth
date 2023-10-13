function [f0,compcurve,envres,regres,totres,coeff,paramTS,envelope]=find_f0(ts,fs,f0min,f0max,fno,fdetno)
%Finds the frequency that best describes an oscillating signal,
%compensating for biases towards both low and high frequencies. ts is the
%time series, fs is the sample frequency, f0min is the lowest evaluated
%frequency (typically 3*fs/length(ts), which corresponds to the lowest
%frequency at which three full wingbeats fit into ts, but a higher
%frequency may be used), f0max is the highest evaluated frequency
%(typically the Nyquist frequency fs/2, but a lower frequency may be used),
%fno is the number of test frequencies in the coarse evaluation and fdetno
%is the number of frequencies used in the detailed evaluation.
%
%The output f0 is the best frequency the function could find, compcurve is
%the compensated residual curve, envres is the residual of the envelope
%only, regres is the theoretical residual of the regressor based on the
%number of terms included, and totres is the total residual of the time
%series and the reconstruction of the time series.
%
%All residual curves are as function of test frequency, corresponding to
%the vector fTest=linspace(f0min,f0max,fno). The obtained frequency f0
%corresponds to the minimum of the compensated residual compcurve.
%
%The script loops through fTest and evaluates each frequency with the
%function f0param.

fTest=linspace(f0min,f0max,fno); %fTest is vector of frequencies to test
L=length(ts); %L is length of time series

if size(ts,2)>size(ts,1); ts=ts';end

%% Loop through test frequencies
for l=1:2

    %% Determine mode - coarse or fine
    if l==1 %decides if its testing frequency or detailed frequency around frequency
        fTestTemp=fTest;
    elseif l==2
        fTestTemp=linspace(0.9*f0test,1.1*f0test,fdetno);
        
        if fTestTemp(end)>f0max
            fTestTemp=fTestTemp(1:find(fTestTemp<f0max,1,'last'));
        end
        
        if fTestTemp(1)<f0min
            fTestTemp=fTestTemp(find(fTestTemp>f0min,1,'first'):end);
        end
    end

    %% Calibrate frequencies
    resEnv=zeros(length(fTestTemp),1); %initiate envelope residual vector
    resReg=zeros(length(fTestTemp),1); %initiate regressor residual vector
    resTot=zeros(length(fTestTemp),1); %initiate total residual vector

    for m=1:length(fTestTemp)
        
        %K=2*floor((fs/2)/fTestTemp(m))+1; %DOF regressor, used to get regressor residual
        
        
        [paramTS,envelope,coeff]=f0param(ts,fTestTemp(m),fs);
        
        resEnv(m)=sum((ts-envelope*coeff(1)).^2)/L; %residual in each time slot, has to divide by L to get average
        resReg(m)=1-length(coeff)/L;

        resTot(m)=sum((ts-paramTS).^2)/L;
    end
     
    resComp=resTot./(resEnv.*resReg);

    
    [~,f0ind]=min(resComp);
    f0test=fTestTemp(f0ind);
    
    if l==1
        compcurve=resComp;
        envres=resEnv;
        regres=resReg;
        totres=resTot;
    end
end
f0=f0test;
[paramTS,envelope,coeff]=f0param(ts,f0,fs);

end




























