% load('C:\Users\Meng\OneDrive - Lund University\transfer\To Hui\Stensoffa Data\Thu21JulyStats.mat')
close all
clear
clc
load('moth_event_rtmap.mat')
load('moth_event_info.mat')
load('pixAng.mat')
frCo=event.rtCo;
frDe=event.rtDe;
range=event_v2.range;
height=range(event_v2.rInd)/2;

y_labels = [1628 1629 1630 1631 1632 1633 1634 1635 1636 1637 1638 1639 1640 1641 1642 1643 1644 1645 1646 1647 1648 1649 1650 1651 1652 1653 1654 1655];

% your selected labels
y_labels_selected = [1630 1635 1640 1645 1650 1655];

% find indices corresponding to the selected labels
y_indices = find(ismember(y_labels, y_labels_selected));

figure,
imagesc(frCo)
figure,
imagesc(frDe)

RGB(:,:,1)=frDe;
RGB(:,:,2)=frCo;
RGB(:,:,3)=zeros(size(frDe));
figure,
imagesc(double(RGB)/320)

xlabel('Exposure (#)','FontSize',16,'FontWeight','bold')

% Here we replace y axis
yticks(y_indices) % Setting tick locations
yticklabels(y_labels_selected) % Replacing the labels with your selected list

ylabel('Pixel (#)','FontSize',16,'FontWeight','bold')
set(gca,'FontSize', 16)


figure,
% plot(sum(frCo'),height,'.-','Color',[0 0.5 0])
hold on
plot((frDe(:,75)),height,'.-','Color',[0.5 0 0])
set(gca,'FontSize', 16)
axis tight
ylabel('Height (m)')
xlabel('Intensity counts (12 bit)')
grid on
set(gca,'FontSize', 16)
a=1000*event_v2.rCoM*tand(max(pixAng(event_v2.rInd))-pixAng(event_v2.rInd));
yyaxis right
plot((frCo(:,75)),a,'.-','Color',[0 0.5 0])
set(gca,'YColor','k')

box on

BS=sum(frCo);
BSd=sum(frDe);

fs=8000/3;
nBins=140;
lowerLim=fs/(2*nBins);
upperLim=fs/2;
window=normpdf(0:nBins,nBins/2,nBins/(4*sqrt(2*log(2))));
L=length(window);
linFreq=linspace(lowerLim,upperLim,L);

PCo=pwelch(event.bsCo,window,nBins-1,linFreq,fs,'power');      
PDe=pwelch(event.bsDe,window,nBins-1,linFreq,fs,'power');
PnCo=pwelch(event.noiseCo,window,nBins-1,linFreq,fs,'power');      
PnDe=pwelch(event.noiseDe,window,nBins-1,linFreq,fs,'power');
figure,
plot([(1:1:length(BS))'/fs*1000],BS,'.-','Color',[0 0.5 0])
hold on
plot([(1:1:length(BS))'/fs*1000],BSd,'.-','Color',[0.5 0 0])
axis tight
xlabel('Time (ms)')
ylabel('Intensity counts (12 bit)')
set(gca,'FontSize', 16)
grid on


figure,
semilogy(linFreq,PCo,'.-','Color',[0 0.5 0])
axis tight
hold on
semilogy(linFreq,PDe,'.-','Color',[0.5 0 0])
xlabel('Frequency (Hz)')
ylabel('Mod. power ')
axis tight
set(gca,'FontSize', 16)
grid on
ts=PCo;%Time series, in this case you put in the copolarized signal
    f0min=40; %minimun frequency to start the search
    f0max=600; %search stop by this max frequency, usually you keep it at fs/2
    fno=200; %number of frequency should be used to do a rough search
    fdetno=1000; %number of frequency used for detailed search
    [f0,compcurve,envres,regres,totres,coeff,paramTS,envelope]=find_f0(ts,fs,f0min,f0max,fno,fdetno);
    
    % Your new data points
    xNewData = linFreq; % Replace with your new x data points
    yNewData = PCo; % Replace with your new y data points

    % Find the x value of interest and its corresponding y value
    xTarget =f0; % Replace with your x value of interest
    [~, idx] = min(abs(xNewData - xTarget)); % Find the index of the x value closest to xTarget
    yTarget = yNewData(idx); % Get the corresponding y value

    % Highlight the point of interest with a circle and an arrow
    plot(xTarget, yTarget, 'ro', 'MarkerSize', 8, 'LineWidth', 2); % Add a red circle with a size of 8 and line width of 2
    ax = gca;
    axpos = get(ax, 'Position');
    xlim_tmp = get(ax, 'xlim');
    ylim_tmp = get(ax, 'ylim');
    x_normalized = (xTarget - xlim_tmp(1)) / (xlim_tmp(2) - xlim_tmp(1));
    y_normalized = (yTarget - ylim_tmp(1)) / (ylim_tmp(2) - ylim_tmp(1));
    % Add text showing the x value in Hz
    txt = sprintf('f_0:%0.2f Hz %0.2f', xTarget);
    text(xTarget * 1.1, yTarget, txt, 'FontSize', 16); % Adjust the 1.1 factor to control the text position

ylim([10 10^6])
yticks([10^1, 10^5])
%% 

load('linkAllHires_stensoffa_v3.mat')
load('pixAng.mat')
for ik=1:length(obs)
event=obs(ik);
a=1000*event.rCoM*tand(max(pixAng(event.rInd))-pixAng(event.rInd));
speed(ik)=max(a)/(1000)/event.dt;
end


figure,
angle_vector=[obs(:).angle];
total_height=[obs(:).rCoM]*sind(30);
signs = sign(angle_vector);
histogram(speed.*signs,50)
solarNoon=(1+6/60)/24;%https://www.timeanddate.com/sun/@2675692?month=6&year=2020
t=[obs.t];
t=datetime(datestr (t)); %convert to datetime %maybe dont need for 2018 version
t=t-solarNoon;
hours = hour(t);
size=[obs(:).appSize]*5*1000;

data1 = speed.*signs;
indices = find(hours >= 22 & hours < 24);
data2 = speed(indices).*signs(indices);
bin_edges = linspace(-4, 4, 51); % 50 bins between -6 and 6

% figure;
% [counts1, ~] = histcounts(data1, bin_edges);
% bar(bin_edges(1:end-1), counts1, 0.8, 'FaceColor', 'blue', 'FaceAlpha', 0.9);
% hold on;
% [counts2, ~] = histcounts(data2, bin_edges);
% bar(bin_edges(1:end-1), counts2, 0.8, 'FaceColor', 'yellow', 'FaceAlpha', 0.7);
% xlabel('Flight speed (m/s)');
% ylabel('Insect (#)');
% xlim([-6 6])
% set(gca,'FontSize', 16)

%% 
% 
% data1 = speed.*signs;
% indices = find(total_height >= 50);
% % indices = find(hours >= 22 & hours < 23);
% 
% data2 = speed(indices).*signs(indices);
% bin_edges = linspace(-4, 4, 51); % 50 bins between -4 and 4
% 
% figure;
% [counts1, binCenters1] = histcounts(data1, bin_edges);
% stairs(bin_edges(1:end-1), counts1, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
% hold on;
% [counts2, binCenters2] = histcounts(data2, bin_edges);
% stairs(bin_edges(1:end-1), counts2, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
% xlabel('Flight speed (m/s)');
% ylabel('Insect (#)');
% xlim([-4 4]);
% set(gca,'FontSize', 16);

%% 
% 
% data1 = speed.*signs;
% indices_high = find(total_height >= 50);
% 
% data2 = speed(indices_high).*signs(indices_high);
% 
% bin_edges = linspace(-4, 4, 51);
% 
% % Get histogram counts
% [counts1, ~] = histcounts(data1, bin_edges);
% [counts2, ~] = histcounts(data2, bin_edges);
% 
% % Duplicate x values to make step-like lines
% x_stairs = reshape([bin_edges(1:end-1); bin_edges(2:end)], 1, []);
% y1_stairs = reshape([counts1; counts1], 1, []);
% y2_stairs = reshape([counts2; counts2], 1, []);
% 
% figure;
% hold on;
% 
% % Use the area function to fill under the step-like curve for "Total"
% a1 = area([x_stairs(1), x_stairs, x_stairs(end)], [0, y1_stairs, 0]);
% 
% % Use the area function to fill under the step-like curve for "Height >= 50"
% a2 = area([x_stairs(1), x_stairs, x_stairs(end)], [0, y2_stairs, 0]);
% 
% % Set transparency
% a1.FaceAlpha = 0.5;
% a2.FaceAlpha = 0.5;
% 
% % Set colors
% a1.FaceColor = [0, 0.4470, 0.7410];
% a2.FaceColor = [0.8500, 0.3250, 0.0980];
% 
% % Set edge colors
% a1.EdgeColor = 'none';
% a2.EdgeColor = 'none';
% 
% xlabel('Flight speed (m/s)');
% ylabel('Insect (#)');
% xlim([-4 4]);
% set(gca,'FontSize', 16);
% 
% % Optional: add legend
% legend('Total', 'Above Tree Height');

%% 
data1 = speed.*signs;

indices_20_to_21 = find(hours >= 20 & hours < 21);
indices_21_to_22 = find(hours >= 21 & hours < 22);
indices_22_to_23 = find(hours >= 22 & hours < 23);
indices_23_to_24 = find(hours >= 23 & hours < 24);

data2 = speed(indices_20_to_21).*signs(indices_20_to_21);
data3 = speed(indices_21_to_22).*signs(indices_21_to_22);
data4 = speed(indices_22_to_23).*signs(indices_22_to_23);
data5 = speed(indices_23_to_24).*signs(indices_23_to_24);

bin_edges = linspace(-3, 3, 51); % 50 bins between -4 and 4

figure;

% Plot for total
[counts1, ~] = histcounts(data1, bin_edges);
stairs(bin_edges(1:end-1), counts1, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
hold on;

% Plot for 20 to 21
[counts2, ~] = histcounts(data2, bin_edges);
stairs(bin_edges(1:end-1), counts2, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);

% Plot for 21 to 22
[counts3, ~] = histcounts(data3, bin_edges);
stairs(bin_edges(1:end-1), counts3, 'LineWidth', 2, 'Color', [0.9290, 0.6940, 0.1250]);

% Plot for 22 to 23
[counts4, ~] = histcounts(data4, bin_edges);
stairs(bin_edges(1:end-1), counts4, 'LineWidth', 2, 'Color', [0.4940, 0.1840, 0.5560]);

% Plot for 23 to 24
[counts5, ~] = histcounts(data5, bin_edges);
stairs(bin_edges(1:end-1), counts5, 'LineWidth', 2, 'Color', [0.4660, 0.6740, 0.1880]);

xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
xlim([-3 3]);
set(gca,'FontSize', 16);

legend('Total', 'The hour of sunset (22:00)','The 1st hour after sunset', 'The 2nd hour after sunset', 'The 3rd hour after sunset');

%% 

%% data1 = speed.*signs; individual speed heading for different time

indices_20_to_21 = find(hours >= 20 & hours < 21);
indices_21_to_22 = find(hours >= 21 & hours < 22);
indices_22_to_23 = find(hours >= 22 & hours < 23);
indices_23_to_24 = find(hours >= 23 & hours < 24);

data2 = speed(indices_20_to_21).*signs(indices_20_to_21);
data3 = speed(indices_21_to_22).*signs(indices_21_to_22);
data4 = speed(indices_22_to_23).*signs(indices_22_to_23);
data5 = speed(indices_23_to_24).*signs(indices_23_to_24);

bin_edges = linspace(-4, 4, 51); % 50 bins between -4 and 4

% Subfigure grid with 5 rows
% [ha, pos] = tight_subplot(5,1,[.01 .03],[.1 .01],[.01 .01])
% Create a figure


f = figure;
f.Position = [100 100 300 200];
[counts1, ~] = histcounts(data1, bin_edges);
stairs(bin_edges(1:end-1), counts1, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('Total');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f = figure;
f.Position = [100 100 300 200];
[counts2, ~] = histcounts(data2, bin_edges);
stairs(bin_edges(1:end-1), counts2, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('20 to 21');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f = figure;
f.Position = [100 100 300 200];
[counts3, ~] = histcounts(data3, bin_edges);
stairs(bin_edges(1:end-1), counts3, 'LineWidth', 2, 'Color', [0.9290, 0.6940, 0.1250]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('21 to 22');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f = figure;
f.Position = [100 100 300 200];
[counts4, ~] = histcounts(data4, bin_edges);
stairs(bin_edges(1:end-1), counts4, 'LineWidth', 2, 'Color', [0.4940, 0.1840, 0.5560]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('22 to 23');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f = figure;
f.Position = [100 100 300 200];
[counts5, ~] = histcounts(data5, bin_edges);
stairs(bin_edges(1:end-1), counts5, 'LineWidth', 2, 'Color', [0.4660, 0.6740, 0.1880]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('23 to 24');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

% Adjust the spacing between subplots
spacing = 0.03;
subplotPos = get(gca, 'Position');
set(gca, 'Position', [subplotPos(1), subplotPos(2) + spacing, subplotPos(3), subplotPos(4) - spacing]);


%% different height

data1_height = speed .* signs;

% Indices for different height intervals
indices_20_to_50 = find(total_height >= 20 & total_height < 50);
indices_50_to_100 = find(total_height >= 50 & total_height < 100);
indices_100_to_700 = find(total_height >= 100 & total_height <= 700);

data2_height = speed(indices_20_to_50) .* signs(indices_20_to_50);
data3_height = speed(indices_50_to_100) .* signs(indices_50_to_100);
data4_height = speed(indices_100_to_700) .* signs(indices_100_to_700);

bin_edges = linspace(-4, 4, 51); % 50 bins between -3 and 3
% Load colormap
figure,
cmap = colormap('inferno');
color_lines = repmat(linspace(0, 1, 256)', 1, 10);
imagesc(color_lines);
colormap(cmap);

% Plot for total
figure;
[counts1, ~] = histcounts(data1_height, bin_edges);
stairs(bin_edges(1:end-1), counts1, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
xlim([-4 4]);
set(gca,'FontSize', 16);
title('Total');
f = gcf;
f.Position = [100 100 300 200];

% Plot for 20 to 50
figure;
[counts2, ~] = histcounts(data2_height, bin_edges);
stairs(bin_edges(1:end-1), counts2, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
xlim([-4 4]);
set(gca,'FontSize', 16);
title('Height: 20-50');
grid on
f = gcf;
f.Position = [100 100 300 200];

% Plot for 50 to 100
figure;
[counts3, ~] = histcounts(data3_height, bin_edges);
stairs(bin_edges(1:end-1), counts3, 'LineWidth', 2, 'Color', [0.9290, 0.6940, 0.1250]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
xlim([-4 4]);
set(gca,'FontSize', 16);
title('Height: 50-100');
grid on
f = gcf;
f.Position = [100 100 300 200];


% Plot for 100 to 700
figure;
[counts4, ~] = histcounts(data4_height, bin_edges);
stairs(bin_edges(1:end-1), counts4, 'LineWidth', 2, 'Color', [0.4940, 0.1840, 0.5560]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
xlim([-4 4]);
set(gca,'FontSize', 16);
title('Height: 100-700');
f = gcf;
grid on
f.Position = [100 100 300 200];
%% different appSize


data1_size = speed.*signs;
indices_less_than_10 = find(size < 10);
indices_10_to_20 = find(size >= 10 & size < 20);
indices_20_to_40 = find(size >= 20 & size < 40);
indices_greater_than_40 = find(size >= 40);

data2_size = speed(indices_less_than_10).*signs(indices_less_than_10);
data3_size = speed(indices_10_to_20).*signs(indices_10_to_20);
data4_size = speed(indices_20_to_40).*signs(indices_20_to_40);
data5_size = speed(indices_greater_than_40).*signs(indices_greater_than_40);

bin_edges_size = linspace(-4, 4, 51); % 50 bins between -4 and 4

% Create a figure and subplots
f_size = figure;
f_size.Position = [100 100 300 200];
[counts1_size, ~] = histcounts(data1_size, bin_edges_size);
stairs(bin_edges_size(1:end-1), counts1_size, 'LineWidth', 2, 'Color', [0, 0.4470, 0.7410]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('Total');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f_size = figure;
f_size.Position = [100 100 300 200];
[counts2_size, ~] = histcounts(data2_size, bin_edges_size);
stairs(bin_edges_size(1:end-1), counts2_size, 'LineWidth', 2, 'Color', [0.8500, 0.3250, 0.0980]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('< 10');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f_size = figure;
f_size.Position = [100 100 300 200];
[counts3_size, ~] = histcounts(data3_size, bin_edges_size);
stairs(bin_edges_size(1:end-1), counts3_size, 'LineWidth', 2, 'Color', [0.9290, 0.6940, 0.1250]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('10 to 20');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f_size = figure;
f_size.Position = [100 100 300 200];
[counts4_size, ~] = histcounts(data4_size, bin_edges_size);
stairs(bin_edges_size(1:end-1), counts4_size, 'LineWidth', 2, 'Color', [0.4940, 0.1840, 0.5560]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('20 to 40');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

f_size = figure;
f_size.Position = [100 100 300 200];
[counts5_size, ~] = histcounts(data5_size, bin_edges_size);
stairs(bin_edges_size(1:end-1), counts5_size, 'LineWidth', 2, 'Color', [0.4660, 0.6740, 0.1880]);
xlabel('Flight speed (m/s)');
ylabel('Insect (#)');
title('40+');
xlim([-4 4]);
grid on
set(gca,'FontSize', 16);

% Adjust the spacing between subplots
spacing = 0.03;
subplotPos = get(gca, 'Position');
set(gca, 'Position', [subplotPos(1), subplotPos(2) + spacing, subplotPos(3), subplotPos(4) - spacing]);


