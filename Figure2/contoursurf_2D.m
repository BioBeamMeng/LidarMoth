clc
close all
clear

load('Merged_Moth_Temp_Hum_wind_wintoutrain.mat')

%% Load frTime, when setup turned on each day
% ddn='C:\Users\Meng\OneDrive - Lund University\Experiment 2023\To Hui\Stensoffa Data';
% dff='C:\Users\Meng\OneDrive - Lund University\Experiment 2023\To Hui\Stensoffa Data\';
% dfn=dir([ddn '\*Pwr.mat']);
% frTime=[];
% for d=1:length(dfn)
%     tmp=load([dff dfn(d).name],'frTime');
%     frTime=[frTime tmp.frTime];
% end


load('frTime.mat')
frTime=datetime(datestr (frTime));
solarNoon=(1+6/60)/24;%https://www.timeanddate.com/sun/@2675692?month=6&year=2020
frTime=frTime-solarNoon;

%% read out parameters, range, temp, wind, hum, rain
r=[obs.rCoM];
t=[obs.t];
t=datetime(datestr (t)); %convert to datetime %maybe dont need for 2018 version
t=t-solarNoon;

Height=[obs.rCoM]*0.5;
Weather_temp=[obs.temperature];
wind=[obs.wind];
hum=[obs.humidity];
rain=[obs.Rain];

%% define time, temp and range resolution, all bins
tres=20; % Minutes
tbin=linspace(0+tres/(2*60),24-tres/(2*60),24*60/tres); %Time
Tbin=linspace(10,30,42); %Temperature
Hbin=logspace(log10(1E0),log10(4E2),length(tbin)+1); %Height
Hum_bin=linspace(min(hum), max(hum), 40); 

dayt=(hour(t)+minute(t)/60)';

unique_dates = unique(dateshift(t, 'start', 'day'));
num_unique_dates = length(unique_dates);

%% Histgrams of frtime and dayt
figure
hist(hour(frTime)+minute(frTime)/60,tbin);
xlabel('Solar time (HH)')
ylabel('Files (#)')
title('Observation hours')
axis tight

figure
hist(dayt,tbin);
xlabel('Solar time (HH)')
ylabel('Observations (#)')
title('Observation hours')
axis tight

ftDist=hist(hour(frTime)+minute(frTime)/60,tbin);
tDist=hist(dayt,tbin);
% calibrate obs time and range with number of files
tDist_nom=max(tDist)*max(ftDist)*tDist./(max(tDist)*ftDist); %calculate the probability 
% tDist_nom=tDist./(ftDist./max(ftDist)); 
figure,
plot(tbin,ftDist,'k','Linewidth',2)
set(gca,'Linewidth',2,'Fontsize',16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
xlabel('Solar Time (HH)','Fontsize',18,'Fontweight','bold')
ylabel('Files (#)')
ylim([min(ftDist)*0.5 max(ftDist)/0.9])
grid on
set(gca, 'YScale', 'log');
yticks([0 1000, 2000,4000]);
ylim([0 5000])
set(gca, 'Yscale','log')

figure, hist(dayt,tbin);hold on;
b1=bar(tbin,tDist_nom,'r');b1.FaceAlpha = 0.3;
xlim([0 24])
set(gca,'Linewidth',2,'Fontsize',16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
xlabel('Solar Time (HH)','Fontsize',18,'Fontweight','bold')
ylabel('Total Insect Activity Pattern Over 21-Day ','Fontsize',18,'Fontweight','bold')




figure
p1=plot(tbin,tDist_nom,'k','Linewidth',2); 
xlim([0 24])
set(gca,'Linewidth',2,'Fontsize',16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
yticks([0 500 1000 1500])  % Set y-axis ticks at 0, 500, 1000, and 1500
xlabel('Solar Time (HH)','Fontsize',18,'Fontweight','bold')
ylabel('# Observations ','Fontsize',18,'Fontweight','bold')
ylim([0 1500])


%% contour, time vs height
% 
% figure
% HeightvsTime = hist3([ Height'+0.1 dayt'], {Hbin tbin });
% data = log10(HeightvsTime);
% contourf( tbin,Hbin, data)
% colormap(inferno)
% colorbar('Ticks', [0 1 2], 'Ticklabels', {'10^0', '10^1', '10^2'})
% set(gca, 'Xscale', 'linear', 'Yscale', 'log')
% set(gca, 'CLim', [0, 2]);
% axis tight
% xlabel('Solar Time (HH)', 'Fontsize', 18, 'Fontweight', 'bold')
% ylabel('Height (m)', 'Fontsize', 18, 'Fontweight', 'bold')
% set(gca, 'Linewidth', 2, 'Fontsize', 16)
% xticks([0.25 6 12 18 23.75])
% xlim([0, 24])
% axis tight
% xticklabels({'00', '06', '12', '18', '24'})
% ylim([22.5, 256]); yticks([32 64 128 256]); yticklabels({'32', '64','128','256'}) 
% grid on
% title('Before calibration')
% 
% dimention=size(data);
% caliMap = repmat( ftDist , dimention(1), 1);
% figure,
% tRDist_nom=HeightvsTime./(caliMap./max(caliMap(:)));
% data_nom = log10(tRDist_nom);
% contourf( tbin,Hbin, data_nom)
% colormap(inferno)
% colorbar('Ticks', [0 1 2], 'Ticklabels', {'10^0', '10^1', '10^2'})
% set(gca, 'Xscale', 'linear', 'Yscale', 'log')
% set(gca, 'CLim', [0, 2]);
% axis tight
% xlabel('Solar Time (HH)', 'Fontsize', 18, 'Fontweight', 'bold')
% ylabel('Height (m)', 'Fontsize', 18, 'Fontweight', 'bold')
% set(gca, 'Linewidth', 2, 'Fontsize', 16)
% xticks([0.25 6 12 18 23.75])
% xlim([0, 24])
% axis tight
% xticklabels({'00', '06', '12', '18', '24'})
% ylim([22.5, 256]); yticks([32 64 128 256]); yticklabels({'32', '64','128','256'}) 
% grid on
% title('After calibration')

%% surf time vs height

figure
HeightvsTime = hist3([ Height'+0.1 dayt'], {Hbin tbin });
data = log10(HeightvsTime);
surf(tbin,Hbin, data,'EdgeColor','none')
view(0,90)
colormap(inferno)
colorbar('Ticks', [0 1 2], 'Ticklabels', {'10^0', '10^1', '10^2'})
set(gca, 'Xscale', 'linear', 'Yscale', 'log')
set(gca, 'CLim', [0, 2]);
axis tight
xlabel('Solar Time (HH)', 'Fontsize', 18, 'Fontweight', 'bold')
ylabel('Height (m)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'Linewidth', 2, 'Fontsize', 16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
ylim([23.5, 256]); yticks([32 64 128 256]); yticklabels({'32', '64','128','256'}) 
grid on
title('Before calibration')
box on

dimention=size(data);
caliMap = repmat( ftDist , dimention(1), 1);
figure,
tRDist_nom=HeightvsTime./(caliMap./max(caliMap(:)));
data_nom = log10(tRDist_nom);
surf( tbin,Hbin, data_nom,'EdgeColor','none')
view(0,90)
colormap(inferno)
colorbar('Ticks', [0 1 2], 'Ticklabels', {'10^0', '10^1', '10^2'})
set(gca, 'Xscale', 'linear', 'Yscale', 'log')
set(gca, 'CLim', [0, 2]);
axis tight
xlabel('Solar Time (HH)', 'Fontsize', 18, 'Fontweight', 'bold')
ylabel('Height (m)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'Linewidth', 2, 'Fontsize', 16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
ylim([23.5, 256]);
yticks([32 64 128 256])
yticklabels({'32', '64','128','256'})
ax=gca;
ax.YTick=[32 64 128 256];
ax.YAxis.MinorTick='off';
grid on

title('After calibration')
box on


dimention=size(data);
caliMap = repmat( ftDist , dimention(1), 1);
figure,
tRDist_nom=HeightvsTime./(caliMap./max(caliMap(:)));
data_nom = log10(tRDist_nom);
surf( tbin,Hbin, data_nom,'EdgeColor','none')
view(0,90)
colormap(inferno)
colorbar('Ticks', [0 1 2], 'Ticklabels', {'10^0', '10^1', '10^2'})
set(gca, 'Xscale', 'linear', 'Yscale', 'log')
set(gca, 'CLim', [0, 2]);
axis tight
xlabel('Solar Time (HH)', 'Fontsize', 18, 'Fontweight', 'bold')
ylabel('Height (m)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'Linewidth', 2, 'Fontsize', 16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
ylim([23.5, 256]);
yticks([32 64 128 256])
yticklabels({'32', '64','128','256'})
hold on % to add grid lines
for y = [32 64 128 256]
    plot3(get(gca, 'xlim'), [y y], [0 0], 'k:','LineWidth',2) % use plot3 to add a line at the surface level
end
hold off
grid off % turn the automatic grid off
colorbar('Ticks',[0 1 2], 'Ticklabels', {'1','10','100'})
box on

%% surf time vs Temperature

figure
TempvsTime_temp_1 = hist3([ Weather_temp'+0.1 dayt'], {Tbin tbin });
data_nom_temp_1 = log10(TempvsTime_temp_1);
surf(tbin,Tbin, data_nom_temp_1,'EdgeColor','none')
view(0,90)
colormap(viridis)
colorbar('Ticks', [0 1 2 3], 'Ticklabels', {'10^0', '10^1', '10^2', '10^3'})
set(gca, 'CLim', [0, 2.5]);
axis tight
xlabel('Solar Time (HH)', 'Fontsize', 18, 'Fontweight', 'bold')
ylabel('Temperature (^oC)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'Linewidth', 2, 'Fontsize', 16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
ylim([10, 30]);
grid on
title('Before calibration')
box on

figure
TempvsTime_temp_2 = hist3([ Weather_temp'+0.1 dayt'], {Tbin tbin });
data_temp_2 = log10(TempvsTime_temp_2);
dimention_temp_2=size(data_temp_2);
load('frTimetmp.mat')
TDist=hist(frTimeTemp_temperature,Tbin);
caliMap_temp_2 = repmat( ftDist , dimention_temp_2(1), 1).*(repmat( TDist , dimention_temp_2(2), 1))';
% caliMap_temp_2 = repmat( ftDist , dimention_temp_2(1), 1);%
tTDist_nom_temp_2=TempvsTime_temp_2./(caliMap_temp_2./max(caliMap_temp_2(:)));
data_nom_temp_2 = log10(tTDist_nom_temp_2);
surf( tbin,Tbin, data_nom_temp_2,'EdgeColor','none')
view(0,90)
colormap(viridis)
colorbar('Ticks', [0 1 2 3], 'Ticklabels', {'10^0', '10^1', '10^2', '10^3'})
set(gca, 'CLim', [0, 2.5]);
axis tight
xlabel('Solar Time (HH)', 'Fontsize', 18, 'Fontweight', 'bold')
ylabel('Temperature (^oC)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'Linewidth', 2, 'Fontsize', 16)
xticks([0.25 6 12 18 23.75])
xlim([0, 24])
axis tight
xticklabels({'00', '06', '12', '18', '24'})
ylim([10, 30]);
grid on
title('After calibration')
box on

figure,
plot(TDist,Tbin,'k','Linewidth',2)
set(gca,'Linewidth',2,'Fontsize',16)
grid on
ylabel('Temperature (^oC)', 'Fontsize', 18, 'Fontweight', 'bold')
xlabel('File Temperature (#)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'XAxisLocation', 'top')



%% surf Temperature vs height

figure
TempvsHeight = hist3([Height'+0.1 Weather_temp' ], {Hbin Tbin });
data_TH = log10(TempvsHeight);
surf( Tbin,Hbin, data_TH,'EdgeColor','none')
view(0,90)
colormap(turbo)
set(gca, 'Xscale', 'linear', 'Yscale', 'log')
colorbar('Ticks', [0 1 2 3], 'Ticklabels', {'10^0', '10^1', '10^2', '10^3'})
set(gca, 'CLim', [0, 3]);
ylabel('Height (m)', 'Fontsize', 18, 'Fontweight', 'bold')
xlabel('Temperature (°C)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'Linewidth', 2, 'Fontsize', 16)
grid on
title('Before calibration')
box on
xlim([10 28])
ylim([22.5, 256]); yticks([32 64 128 256]); yticklabels({'32', '64','128','256'}) 

figure,
dimention_TH=size(data_TH);
caliMap_TH = repmat( TDist , dimention_TH(1), 1);
THDist_nom=TempvsHeight./(caliMap_TH./max(caliMap_TH(:)));
TH_nom = log10(THDist_nom);
surf( Tbin,Hbin, TH_nom,'EdgeColor','none')
view(0,90)
colormap(turbo)
set(gca, 'Xscale', 'linear', 'Yscale', 'log')
colorbar('Ticks', [0 1 2 3], 'Ticklabels', {'10^0', '10^1', '10^2', '10^3'})
set(gca, 'CLim', [0, 3 ]);
ylabel('Height (m)', 'Fontsize', 18, 'Fontweight', 'bold')
xlabel('Temperature (°C)', 'Fontsize', 18, 'Fontweight', 'bold')
set(gca, 'Linewidth', 2, 'Fontsize', 16)
grid on
title('After calibration')
box on
axis tight
ylim([22.5, 256]); yticks([32 64 128 256]); yticklabels({'32', '64','128','256'}) 
xlim([10 28])

figure,
plot(Tbin,TDist,'k','Linewidth',2)
set(gca,'Linewidth',2,'Fontsize',16)
xlabel('Temperature (°C)', 'Fontsize', 18, 'Fontweight', 'bold')
ylabel('Files (#)')
ylim([min(ftDist)*0.5 max(ftDist)/0.9])
grid on
axis tight
xlim([10 28])



