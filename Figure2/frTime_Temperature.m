clc
close all 
% clearvars -except obs Weather
clearvars -except obs 

if ~exist('obs', 'var')
    load('Merged_Moth_Temp_Hum_wind_wintoutrain.mat', 'obs');
end
if ~exist('Weather', 'var')
Weather = readtable('2022meadow.xlsx');
end

ddn='C:\Users\Meng\OneDrive - Lund University\transfer\To Hui\Stensoffa Data';
dff='C:\Users\Meng\OneDrive - Lund University\transfer\To Hui\Stensoffa Data\';
dfn=dir([ddn '\*Pwr.mat']);
frTime=[];
for d=1:length(dfn)
    tmp=load([dff dfn(d).name],'frTime');
    frTime=[frTime tmp.frTime];
end

data.date = datetime(Weather.Var1,'InputFormat','dd/MM/yyyy');
data.time = duration(Weather.Var2*24, 0, 0);
data.datetime = data.date + data.time;
data.datenum = datenum(data.datetime);

data.Temp_Hi = Weather.Temp;
data.Out_Hum = Weather.Out;
data.Wind_Speed = Weather.Wind;
data.Rain = Weather.Rain;

% Load the smhi data
smhi = readtable('smhi.csv');
smhi.date = datetime(smhi.Datum,'InputFormat','yyyy-MM-dd');
smhi.time = duration(smhi.Tid_UTC_);
smhi.datetime = smhi.date + smhi.time;
smhi.datenum = datenum(smhi.datetime);

for i = 1:length(data.datenum)
    if isnan(data.Temp_Hi(i))
        idx = find(smhi.datenum == data.datenum(i), 1);
        if ~isempty(idx)
            data.Temp_Hi(i) = smhi.Lufttemperatur(idx);
        end
    end
end

% Interpolation
data.Temp_Hi = fillmissing(data.Temp_Hi,'linear');
data.Out_Hum = fillmissing(data.Out_Hum,'linear');
data.Wind_Speed = fillmissing(data.Wind_Speed,'linear');
data.Rain = fillmissing(data.Rain,'linear');

% Detect missing data
missing_Temp_Hi = isnan(Weather.Temp);
missing_Out_Hum = isnan(Weather.Out);
missing_Wind_Speed = isnan(Weather.Wind);
missing_Rain = isnan(Weather.Rain);

% Print out the summary
fprintf('Missing data in Temp_Hi: %d\n', sum(missing_Temp_Hi));
fprintf('Missing data in Out_Hum: %d\n', sum(missing_Out_Hum));
fprintf('Missing data in Wind_Speed: %d\n', sum(missing_Wind_Speed));
fprintf('Missing data in Rain: %d\n', sum(missing_Rain));

% Find the dates with missing data
missing_dates_Temp_Hi = data.date(missing_Temp_Hi);
missing_dates_Out_Hum = data.date(missing_Out_Hum);
missing_dates_Wind_Speed = data.date(missing_Wind_Speed);
missing_dates_Rain = data.date(missing_Rain);


Weather_temp = struct2table(data);
frTimeTemp=frTime';
frTimeTemp_temperature = NaN(size(frTimeTemp));
frTimeTemp_humidity = NaN(size(frTimeTemp));
frTimeTemp_Wind = NaN(size(frTimeTemp));
frTimeTemp_Rain = NaN(size(frTimeTemp));

tolerance = hours(2)/24;

for i = 1:numel(frTimeTemp)
    current_timestamp = frTimeTemp(i);
    diff_time = abs(Weather_temp.datenum - current_timestamp);
    
    while isnan(frTimeTemp_temperature(i)) && ~isempty(diff_time)
        [~, idx] = min(diff_time);

        if diff_time(idx) <= tolerance
            frTimeTemp_temperature(i) = Weather_temp.Temp_Hi(idx);
            frTimeTemp_humidity(i) = Weather_temp.Out_Hum(idx);
            frTimeTemp_Wind(i) = Weather_temp.Wind_Speed(idx);
            frTimeTemp_Rain(i) = Weather_temp.Rain(idx);
            
            % Clear diff_time to break the loop
            diff_time = [];
        else
            current_timestamp = current_timestamp - days(1)/24;
            diff_time = abs(Weather_temp.datenum - current_timestamp);
            
            % If all timestamps have been checked and none are within tolerance,
            % break the loop
            if current_timestamp < min(Weather_temp.datenum)
                break
            end
        end
    end
    % Progress display
    fprintf('Progress: %d/%d\n', i, numel(frTimeTemp));
end






