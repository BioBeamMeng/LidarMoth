
close all

dtbin=logspace(log10(0.02),log10(1),31);
dtbinc=(dtbin(1:(end-1))+dtbin(2:(end)))/2;

finc=1:41;

for k=1:length(obs)
PCo(k,:)=obs(k).PCo'./obs(k).PnCo';
PDe(k,:)=obs(k).PDe'./obs(k).PnDe';

end



clear PmCo PmDe PmnCo PmnDe
for dtt=1:(length(dtbin)-1)
    
    rind=find(([obs.dt]>dtbin(dtt)).*([obs.dt]<dtbin(dtt+1)));
    PmCo(dtt,:)=mean(PCo(rind,finc));
    PmDe(dtt,:)=mean(PDe(rind,finc));
    
    PmnCo(dtt,:)=mean(PnCo(rind,finc));
    PmnDe(dtt,:)=mean(PnDe(rind,finc));
    
    
end

subplot(1,2,1)
contour(dtbinc,linFreq(finc),log10(PmCo(:,finc))',20)
set(gca,'YScale','Log','XScale','Log')
ylabel('Modulation frequency (Hz)')
xlabel('\Deltat (s)')
axis tight
colormap jet
colorbar

caxis([-2 -1])

subplot(1,2,2)
contour(dtbinc,linFreq(finc),log10(PmDe(:,finc))',20)
set(gca,'YScale','Log','XScale','Log')
ylabel('Modulation frequency (Hz)')
xlabel('\Deltat (s)')
axis tight
colormap jet
colorbar

caxis([-2 -1])

figure

subplot(1,2,1)
contour(dtbinc,linFreq(finc),log10(PmnCo(:,finc))',20)
set(gca,'YScale','Log','XScale','Log')
ylabel('Modulation frequency (Hz)')
xlabel('\Deltat (s)')
axis tight
colormap jet
colorbar

caxis([-2 -1])

subplot(1,2,2)
contour(dtbinc,linFreq(finc),log10(PmnDe(:,finc))',20)
set(gca,'YScale','Log','XScale','Log')
ylabel('Modulation frequency (Hz)')
xlabel('\Deltat (s)')
axis tight
colormap jet
colorbar


caxis([-2 -1])