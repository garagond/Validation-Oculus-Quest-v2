subject = 1;
strsubject = 'Subject 1';
serie = 1;
strserie = 'Serie 1';
bodypart = 'wrist'; %wrist/elbow

%Load trajectories VICON
trayectories_vicon = readtable('trajectories_vicon.xlsx', 'VariableNamingRule','preserve');

%Calculate head midpoint to adjust the axis
trayectories_vicon.HJCX = (trayectories_vicon.RFHDX + trayectories_vicon.LFHDX)/2;
trayectories_vicon.HJCY = (trayectories_vicon.RFHDY + trayectories_vicon.LFHDY)/2;
trayectories_vicon.HJCZ = (trayectories_vicon.RFHDZ + trayectories_vicon.LFHDZ)/2;

%WRISTS
trajectories_wrist = table(trayectories_vicon.LWRAX, trayectories_vicon.LWRAY, ...
    trayectories_vicon.LWRAZ, trayectories_vicon.LWRBX, trayectories_vicon.LWRBY, ...
    trayectories_vicon.LWRBZ, trayectories_vicon.RWRAX, trayectories_vicon.RWRAY, ...
    trayectories_vicon.RWRAZ, trayectories_vicon.RWRBX, trayectories_vicon.RWRBY, ...
    trayectories_vicon.RWRBZ, trayectories_vicon.HJCX, trayectories_vicon.HJCY, ...
    trayectories_vicon.HJCZ, trayectories_vicon.Frame, 'VariableNames', {'LWRAX', ...
    'LWRAY','LWRAZ','LWRBX', 'LWRBY','LWRBZ','RWRAX','RWRAY','RWRAZ','RWRBX','RWRBY', ...
    'RWRBZ','HJCX','HJCY','HJCZ', 'Frames'});

%Adjust the positions to the center of the axis
%RIGHT
trajectories_wrist.RWRAX = (trajectories_wrist.RWRAX - trajectories_wrist.HJCX);
trajectories_wrist.RWRAY = (trajectories_wrist.RWRAY - trajectories_wrist.HJCY);
trajectories_wrist.RWRBX = (trajectories_wrist.RWRBX - trajectories_wrist.HJCX);
trajectories_wrist.RWRBY = (trajectories_wrist.RWRBY - trajectories_wrist.HJCY);
%LEFT
trajectories_wrist.LWRAX = (trajectories_wrist.LWRAX - trajectories_wrist.HJCX);
trajectories_wrist.LWRAY = (trajectories_wrist.LWRAY - trajectories_wrist.HJCY);
trajectories_wrist.LWRBX = (trajectories_wrist.LWRBX - trajectories_wrist.HJCX);
trajectories_wrist.LWRBY = (trajectories_wrist.LWRBY - trajectories_wrist.HJCY);

%Calculate the midpoint between WRA and WRB to get the position of the wrists
%RIGHT
trajectories_wrist.RWJCX = (trajectories_wrist.RWRAX + trajectories_wrist.RWRBX)/2;
trajectories_wrist.RWJCY = (trajectories_wrist.RWRAY + trajectories_wrist.RWRBY)/2;
trajectories_wrist.RWJCZ = (trajectories_wrist.RWRAZ + trajectories_wrist.RWRBZ)/2;
%LEFT
trajectories_wrist.LWJCX = (trajectories_wrist.LWRAX + trajectories_wrist.LWRBX)/2;
trajectories_wrist.LWJCY = (trajectories_wrist.LWRAY + trajectories_wrist.LWRBY)/2;
trajectories_wrist.LWJCZ = (trajectories_wrist.LWRAZ + trajectories_wrist.LWRBZ)/2;

%Transform from milimiters to meters
%RIGHT
trajectories_wrist.RWJCX = trajectories_wrist.RWJCX/1000;
trajectories_wrist.RWJCY = trajectories_wrist.RWJCY/1000;
trajectories_wrist.RWJCZ = trajectories_wrist.RWJCZ/1000;
%LEFT
trajectories_wrist.LWJCX = trajectories_wrist.LWJCX/1000;
trajectories_wrist.LWJCY = trajectories_wrist.LWJCY/1000;
trajectories_wrist.LWJCZ = trajectories_wrist.LWJCZ/1000;

%ELBOW
trajectories_elbow = table(trayectories_vicon.LELBX, trayectories_vicon.LELBY, ...
    trayectories_vicon.LELBZ, trayectories_vicon.RELBX, trayectories_vicon.RELBY, ...
    trayectories_vicon.RELBZ, trayectories_vicon.HJCX, trayectories_vicon.HJCY, ...
    trayectories_vicon.HJCZ, trayectories_vicon.Frame, 'VariableNames', {'LELBX', ...
    'LELBY','LELBZ', 'RELBX','RELBY','RELBZ', 'HJCX','HJCY','HJCZ', 'Frames'});
%Adjust the positions to the center of the axis
%RIGHT
trajectories_elbow.RELBX = (trajectories_elbow.RELBX - trajectories_elbow.HJCX);
trajectories_elbow.RELBY = (trajectories_elbow.RELBY - trajectories_elbow.HJCY);
%LEFT
trajectories_elbow.LELBX = (trajectories_elbow.LELBX - trajectories_elbow.HJCX);
trajectories_elbow.LELBY = (trajectories_elbow.LELBY - trajectories_elbow.HJCY);
%Transform from milimiters to meters
%RIGHT
trajectories_elbow.RELBX = trajectories_elbow.RELBX/1000;
trajectories_elbow.RELBY = trajectories_elbow.RELBY/1000;
trajectories_elbow.RELBZ = trajectories_elbow.RELBZ/1000;
%LEFT
trajectories_elbow.LELBX = trajectories_elbow.LELBX/1000;
trajectories_elbow.LELBY = trajectories_elbow.LELBY/1000;
trajectories_elbow.LELBZ = trajectories_elbow.LELBZ/1000;


%Cut vicon data into the four different movements for each serie
%WRIST
findMins(trajectories_wrist.RWJCZ, trajectories_wrist.Frames);
findMins(trajectories_wrist.LWJCZ, trajectories_wrist.Frames);

wrist_extension_RF_vicon =  trajectories_wrist(0:0, :);
wrist_extension_RF_vicon.Frames = wrist_extension_RF_vicon.Frames/100;
wrist_extension_RF_vicon.Frames = wrist_extension_RF_vicon.Frames - wrist_extension_RF_vicon.Frames(1);
wrist_frontal_RF_vicon = trajectories_wrist(0:0, :);
wrist_frontal_RF_vicon.Frames = wrist_frontal_RF_vicon.Frames/100;
wrist_frontal_RF_vicon.Frames = wrist_frontal_RF_vicon.Frames - wrist_frontal_RF_vicon.Frames(1);
wrist_extension_LF_vicon = trajectories_wrist(0:0, :);
wrist_extension_LF_vicon.Frames = wrist_extension_LF_vicon.Frames/100;
wrist_extension_LF_vicon.Frames = wrist_extension_LF_vicon.Frames - wrist_extension_LF_vicon.Frames(1);
wrist_frontal_LF_vicon = trajectories_wrist(0:0, :);
wrist_frontal_LF_vicon.Frames = wrist_frontal_LF_vicon.Frames/100;
wrist_frontal_LF_vicon.Frames = wrist_frontal_LF_vicon.Frames - wrist_frontal_LF_vicon.Frames(1);

wrist_extension_RR_vicon = trajectories_wrist(0:0, :);
wrist_extension_RR_vicon.Frames = wrist_extension_RR_vicon.Frames/100;
wrist_extension_RR_vicon.Frames = wrist_extension_RR_vicon.Frames - wrist_extension_RR_vicon.Frames(1);
wrist_frontal_RR_vicon = trajectories_wrist(0:0, :);
wrist_frontal_RR_vicon.Frames = wrist_frontal_RR_vicon.Frames/100;
wrist_frontal_RR_vicon.Frames = wrist_frontal_RR_vicon.Frames - wrist_frontal_RR_vicon.Frames(1);
wrist_extension_LR_vicon = trajectories_wrist(0:0, :);
wrist_extension_LR_vicon.Frames = wrist_extension_LR_vicon.Frames/100;
wrist_extension_LR_vicon.Frames = wrist_extension_LR_vicon.Frames - wrist_extension_LR_vicon.Frames(1);
wrist_frontal_LR_vicon = trajectories_wrist(0:0, :);
wrist_frontal_LR_vicon.Frames = wrist_frontal_LR_vicon.Frames/100;
wrist_frontal_LR_vicon.Frames = wrist_frontal_LR_vicon.Frames - wrist_frontal_LR_vicon.Frames(1);

wrist_extension_RL_vicon = trajectories_wrist(0:0, :);
wrist_extension_RL_vicon.Frames = wrist_extension_RL_vicon.Frames/100;
wrist_extension_RL_vicon.Frames = wrist_extension_RL_vicon.Frames - wrist_extension_RL_vicon.Frames(1);
wrist_frontal_RL_vicon = trajectories_wrist(0:0, :);
wrist_frontal_RL_vicon.Frames = wrist_frontal_RL_vicon.Frames/100;
wrist_frontal_RL_vicon.Frames = wrist_frontal_RL_vicon.Frames - wrist_frontal_RL_vicon.Frames(1);
wrist_extension_LL_vicon =trajectories_wrist(0:0, :);
wrist_extension_LL_vicon.Frames = wrist_extension_LL_vicon.Frames/100;
wrist_extension_LL_vicon.Frames = wrist_extension_LL_vicon.Frames - wrist_extension_LL_vicon.Frames(1);
wrist_frontal_LL_vicon = trajectories_wrist(0:0, :);
wrist_frontal_LL_vicon.Frames = wrist_frontal_LL_vicon.Frames/100;
wrist_frontal_LL_vicon.Frames = wrist_frontal_LL_vicon.Frames - wrist_frontal_LL_vicon.Frames(1);

%ELBOW
findMins(trajectories_elbow.RELBZ, trajectories_elbow.Frames);
findMins(trajectories_elbow.LELBZ, trajectories_elbow.Frames);

elbow_extension_RF_vicon =  trajectories_elbow(0:0, :);
elbow_extension_RF_vicon.Frames = elbow_extension_RF_vicon.Frames/100;
elbow_extension_RF_vicon.Frames = elbow_extension_RF_vicon.Frames - elbow_extension_RF_vicon.Frames(1);
elbow_frontal_RF_vicon = trajectories_elbow(0:0, :);
elbow_frontal_RF_vicon.Frames = elbow_frontal_RF_vicon.Frames/100;
elbow_frontal_RF_vicon.Frames = elbow_frontal_RF_vicon.Frames - elbow_frontal_RF_vicon.Frames(1);
elbow_extension_LF_vicon = trajectories_elbow(0:0, :);
elbow_extension_LF_vicon.Frames = elbow_extension_LF_vicon.Frames/100;
elbow_extension_LF_vicon.Frames = elbow_extension_LF_vicon.Frames - elbow_extension_LF_vicon.Frames(1);
elbow_frontal_LF_vicon = trajectories_elbow(0:0, :);
elbow_frontal_LF_vicon.Frames = elbow_frontal_LF_vicon.Frames/100;
elbow_frontal_LF_vicon.Frames = elbow_frontal_LF_vicon.Frames - elbow_frontal_LF_vicon.Frames(1);

elbow_extension_RR_vicon = trajectories_elbow(0:0, :);
elbow_extension_RR_vicon.Frames = elbow_extension_RR_vicon.Frames/100;
elbow_extension_RR_vicon.Frames = elbow_extension_RR_vicon.Frames - elbow_extension_RR_vicon.Frames(1);
elbow_frontal_RR_vicon = trajectories_elbow(0:0, :);
elbow_frontal_RR_vicon.Frames = elbow_frontal_RR_vicon.Frames/100;
elbow_frontal_RR_vicon.Frames = elbow_frontal_RR_vicon.Frames - elbow_frontal_RR_vicon.Frames(1);
elbow_extension_LR_vicon = trajectories_elbow(0:0, :);
elbow_extension_LR_vicon.Frames = elbow_extension_LR_vicon.Frames/100;
elbow_extension_LR_vicon.Frames = elbow_extension_LR_vicon.Frames - elbow_extension_LR_vicon.Frames(1);
elbow_frontal_LR_vicon = trajectories_elbow(0:0, :);
elbow_frontal_LR_vicon.Frames = elbow_frontal_LR_vicon.Frames/100;
elbow_frontal_LR_vicon.Frames = elbow_frontal_LR_vicon.Frames - elbow_frontal_LR_vicon.Frames(1);

elbow_extension_RL_vicon = trajectories_elbow(0:0, :);
elbow_extension_RL_vicon.Frames = elbow_extension_RL_vicon.Frames/100;
elbow_extension_RL_vicon.Frames = elbow_extension_RL_vicon.Frames - elbow_extension_RL_vicon.Frames(1);
elbow_frontal_RL_vicon = trajectories_elbow(0:0, :);
elbow_frontal_RL_vicon.Frames = elbow_frontal_RL_vicon.Frames/100;
elbow_frontal_RL_vicon.Frames = elbow_frontal_RL_vicon.Frames - elbow_frontal_RL_vicon.Frames(1);
elbow_extension_LL_vicon = trajectories_elbow(0:0, :);
elbow_extension_LL_vicon.Frames = elbow_extension_LL_vicon.Frames/100;
elbow_extension_LL_vicon.Frames = elbow_extension_LL_vicon.Frames - elbow_extension_LL_vicon.Frames(1);
elbow_frontal_LL_vicon = trajectories_elbow(0:0, :);
elbow_frontal_LL_vicon.Frames = elbow_frontal_LL_vicon.Frames/100;
elbow_frontal_LL_vicon.Frames = elbow_frontal_LL_vicon.Frames - elbow_frontal_LL_vicon.Frames(1);

% %Load data Oculus Quest and cut it to fit only the fragments where the
% controllers are moving
%WRIST
wrist_extension_RF = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_extension_RF.RightControllerGlobalPositionY, wrist_extension_RF.Time);

difference = abs(wrist_extension_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_RF(indexMin, :);
colToSearch1 = find(wrist_extension_RF.Time == RtableColToSearch1.Time);
difference = abs(wrist_extension_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_RF(indexMin, :);
colToSearch2 = find(wrist_extension_RF.Time == RtableColToSearch1.Time);
wrist_extension_RF =  wrist_extension_RF(colToSearch1:colToSearch2, :);
wrist_extension_RF.Time = wrist_extension_RF.Time - wrist_extension_RF.Time(1);

wrist_frontal_RF = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_frontal_RF.RightControllerGlobalPositionY, wrist_frontal_RF.Time);

difference = abs(wrist_frontal_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_RF(indexMin, :);
colToSearch1 = find(wrist_frontal_RF.Time == RtableColToSearch1.Time);
difference = abs(wrist_frontal_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_RF(indexMin, :);
colToSearch2 = find(wrist_frontal_RF.Time == RtableColToSearch1.Time);
wrist_frontal_RF =  wrist_frontal_RF(colToSearch1:colToSearch2, :);
wrist_frontal_RF.Time = wrist_frontal_RF.Time - wrist_frontal_RF.Time(1);

wrist_extension_LF = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_extension_LF.LeftControllerGlobalPositionY, wrist_extension_LF.Time);

difference = abs(wrist_extension_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_LF(indexMin, :);
colToSearch1 = find(wrist_extension_LF.Time == RtableColToSearch1.Time);
difference = abs(wrist_extension_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_LF(indexMin, :);
colToSearch2 = find(wrist_extension_LF.Time == RtableColToSearch1.Time);
wrist_extension_LF =  wrist_extension_LF(colToSearch1:colToSearch2, :);
wrist_extension_LF.Time = wrist_extension_LF.Time - wrist_extension_LF.Time(1);

wrist_frontal_LF = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_frontal_LF.LeftControllerGlobalPositionY, wrist_frontal_LF.Time);

difference = abs(wrist_frontal_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_LF(indexMin, :);
colToSearch1 = find(wrist_frontal_LF.Time == RtableColToSearch1.Time);
difference = abs(wrist_frontal_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_LF(indexMin, :);
colToSearch2 = find(wrist_frontal_LF.Time == RtableColToSearch1.Time);
wrist_frontal_LF =  wrist_frontal_LF(colToSearch1:colToSearch2, :);
wrist_frontal_LF.Time = wrist_frontal_LF.Time - wrist_frontal_LF.Time(1);

wrist_extension_RR = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_extension_RR.RightControllerGlobalPositionY, wrist_extension_RR.Time);

difference = abs(wrist_extension_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_RR(indexMin, :);
colToSearch1 = find(wrist_extension_RR.Time == RtableColToSearch1.Time);
difference = abs(wrist_extension_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_RR(indexMin, :);
colToSearch2 = find(wrist_extension_RR.Time == RtableColToSearch1.Time);
wrist_extension_RR =  wrist_extension_RR(colToSearch1:colToSearch2, :);
wrist_extension_RR.Time = wrist_extension_RR.Time - wrist_extension_RR.Time(1);

wrist_frontal_RR = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_frontal_RR.RightControllerGlobalPositionY, wrist_frontal_RR.Time);

difference = abs(wrist_frontal_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_RR(indexMin, :);
colToSearch1 = find(wrist_frontal_RR.Time == RtableColToSearch1.Time);
difference = abs(wrist_frontal_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_RR(indexMin, :);
colToSearch2 = find(wrist_frontal_RR.Time == RtableColToSearch1.Time);
wrist_frontal_RR =  wrist_frontal_RR(colToSearch1:colToSearch2, :);
wrist_frontal_RR.Time = wrist_frontal_RR.Time - wrist_frontal_RR.Time(1);

wrist_extension_LR = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_extension_LR.LeftControllerGlobalPositionZ, wrist_extension_LR.Time);

difference = abs(wrist_extension_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_LR(indexMin, :);
colToSearch1 = find(wrist_extension_LR.Time == RtableColToSearch1.Time);
difference = abs(wrist_extension_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_LR(indexMin, :);
colToSearch2 = find(wrist_extension_LR.Time == RtableColToSearch1.Time);
wrist_extension_LR =  wrist_extension_LR(colToSearch1:colToSearch2, :);
wrist_extension_LR.Time = wrist_extension_LR.Time - wrist_extension_LR.Time(1);

wrist_frontal_LR = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_frontal_LR.LeftControllerGlobalPositionY, wrist_frontal_LR.Time);

difference = abs(wrist_frontal_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_LR(indexMin, :);
colToSearch1 = find(wrist_frontal_LR.Time == RtableColToSearch1.Time);
difference = abs(wrist_frontal_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_LR(indexMin, :);
colToSearch2 = find(wrist_frontal_LR.Time == RtableColToSearch1.Time);
wrist_frontal_LR =  wrist_frontal_LR(colToSearch1:colToSearch2, :);
wrist_frontal_LR.Time = wrist_frontal_LR.Time - wrist_frontal_LR.Time(1);

wrist_extension_RL = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_extension_RL.RightControllerGlobalPositionY, wrist_extension_RL.Time);

difference = abs(wrist_extension_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_RL(indexMin, :);
colToSearch1 = find(wrist_extension_RL.Time == RtableColToSearch1.Time);
difference = abs(wrist_extension_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_RL(indexMin, :);
colToSearch2 = find(wrist_extension_RL.Time == RtableColToSearch1.Time);
wrist_extension_RL =  wrist_extension_RL(colToSearch1:colToSearch2, :);
wrist_extension_RL.Time = wrist_extension_RL.Time - wrist_extension_RL.Time(1);

wrist_frontal_RL = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_frontal_RL.RightControllerGlobalPositionY, wrist_frontal_RL.Time);

difference = abs(wrist_frontal_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_RL(indexMin, :);
colToSearch1 = find(wrist_frontal_RL.Time == RtableColToSearch1.Time);
difference = abs(wrist_frontal_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_RL(indexMin, :);
colToSearch2 = find(wrist_frontal_RL.Time == RtableColToSearch1.Time);
wrist_frontal_RL =  wrist_frontal_RL(colToSearch1:colToSearch2, :);
wrist_frontal_RL.Time = wrist_frontal_RL.Time - wrist_frontal_RL.Time(1);

wrist_extension_LL = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_extension_LL.LeftControllerGlobalPositionY, wrist_extension_LL.Time);

difference = abs(wrist_extension_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_LL(indexMin, :);
colToSearch1 = find(wrist_extension_LL.Time == RtableColToSearch1.Time);
difference = abs(wrist_extension_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_extension_LL(indexMin, :);
colToSearch2 = find(wrist_extension_LL.Time == RtableColToSearch1.Time);
wrist_extension_LL =  wrist_extension_LL(colToSearch1:colToSearch2, :);
wrist_extension_LL.Time = wrist_extension_LL.Time - wrist_extension_LL.Time(1);

wrist_frontal_LL = readtable('path', 'VariableNamingRule','preserve');
findMins(wrist_frontal_LL.LeftControllerGlobalPositionY, wrist_frontal_LL.Time);

difference = abs(wrist_frontal_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_LL(indexMin, :);
colToSearch1 = find(wrist_frontal_LL.Time == RtableColToSearch1.Time);
difference = abs(wrist_frontal_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = wrist_frontal_LL(indexMin, :);
colToSearch2 = find(wrist_frontal_LL.Time == RtableColToSearch1.Time);
wrist_frontal_LL =  wrist_frontal_LL(colToSearch1:colToSearch2, :);
wrist_frontal_LL.Time = wrist_frontal_LL.Time - wrist_frontal_LL.Time(1);

%ELBOW
elbow_extension_RF = readtable('path', 'VariableNamingRule','preserve');
wrist_extension_RF_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_extension_RF = addvars(elbow_extension_RF, wrist_extension_RF_cols.HeadsetGlobalPositionX, wrist_extension_RF_cols.HeadsetGlobalPositionY, wrist_extension_RF_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_extension_RF.RightElbowGlobalPositionY, elbow_extension_RF.Time);

difference = abs(elbow_extension_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_RF(indexMin, :);
colToSearch1 = find(elbow_extension_RF.Time == RtableColToSearch1.Time);
difference = abs(elbow_extension_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_RF(indexMin, :);
colToSearch2 = find(elbow_extension_RF.Time == RtableColToSearch1.Time);
elbow_extension_RF =  elbow_extension_RF(colToSearch1:colToSearch2, :);
elbow_extension_RF.Time = elbow_extension_RF.Time - elbow_extension_RF.Time(1);

elbow_frontal_RF = readtable('path', 'VariableNamingRule','preserve');
wrist_frontal_RF_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_frontal_RF = addvars(elbow_frontal_RF, wrist_frontal_RF_cols.HeadsetGlobalPositionX, wrist_frontal_RF_cols.HeadsetGlobalPositionY, wrist_frontal_RF_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_frontal_RF.RightElbowGlobalPositionY, elbow_frontal_RF.Time);

difference = abs(elbow_frontal_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_RF(indexMin, :);
colToSearch1 = find(elbow_frontal_RF.Time == RtableColToSearch1.Time);
difference = abs(elbow_frontal_RF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_RF(indexMin, :);
colToSearch2 = find(elbow_frontal_RF.Time == RtableColToSearch1.Time);
elbow_frontal_RF =  elbow_frontal_RF(colToSearch1:colToSearch2, :);
elbow_frontal_RF.Time = elbow_frontal_RF.Time - elbow_frontal_RF.Time(1);

elbow_extension_LF = readtable('path', 'VariableNamingRule','preserve');
wrist_extension_LF_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_extension_LF = addvars(elbow_extension_LF, wrist_extension_LF_cols.HeadsetGlobalPositionX, wrist_extension_LF_cols.HeadsetGlobalPositionY, wrist_extension_LF_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_extension_LF.LeftElbowGlobalPositionY, elbow_extension_LF.Time);

difference = abs(elbow_extension_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_LF(indexMin, :);
colToSearch1 = find(elbow_extension_LF.Time == RtableColToSearch1.Time);
difference = abs(elbow_extension_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_LF(indexMin, :);
colToSearch2 = find(elbow_extension_LF.Time == RtableColToSearch1.Time);
elbow_extension_LF =  elbow_extension_LF(colToSearch1:colToSearch2, :);
elbow_extension_LF.Time = elbow_extension_LF.Time - elbow_extension_LF.Time(1);

elbow_frontal_LF = readtable('path', 'VariableNamingRule','preserve');
wrist_frontal_LF_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_frontal_LF = addvars(elbow_frontal_LF, wrist_frontal_LF_cols.HeadsetGlobalPositionX, wrist_frontal_LF_cols.HeadsetGlobalPositionY, wrist_frontal_LF_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_frontal_LF.LeftElbowGlobalPositionY, elbow_frontal_LF.Time);

difference = abs(elbow_frontal_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_LF(indexMin, :);
colToSearch1 = find(elbow_frontal_LF.Time == RtableColToSearch1.Time);
difference = abs(elbow_frontal_LF.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_LF(indexMin, :);
colToSearch2 = find(elbow_frontal_LF.Time == RtableColToSearch1.Time);
elbow_frontal_LF =  elbow_frontal_LF(colToSearch1:colToSearch2, :);
elbow_frontal_LF.Time = elbow_frontal_LF.Time - elbow_frontal_LF.Time(1);

elbow_extension_RR = readtable('path', 'VariableNamingRule','preserve');
wrist_extension_RR_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_extension_RR = addvars(elbow_extension_RR, wrist_extension_RR_cols.HeadsetGlobalPositionX, wrist_extension_RR_cols.HeadsetGlobalPositionY, wrist_extension_RR_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_extension_RR.RightElbowGlobalPositionY, elbow_extension_RR.Time);

difference = abs(elbow_extension_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_RR(indexMin, :);
colToSearch1 = find(elbow_extension_RR.Time == RtableColToSearch1.Time);
difference = abs(elbow_extension_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_RR(indexMin, :);
colToSearch2 = find(elbow_extension_RR.Time == RtableColToSearch1.Time);
elbow_extension_RR =  elbow_extension_RR(colToSearch1:colToSearch2, :);
elbow_extension_RR.Time = elbow_extension_RR.Time - elbow_extension_RR.Time(1);

elbow_frontal_RR = readtable('path', 'VariableNamingRule','preserve');
wrist_frontal_RR_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_frontal_RR = addvars(elbow_frontal_RR, wrist_frontal_RR_cols.HeadsetGlobalPositionX, wrist_frontal_RR_cols.HeadsetGlobalPositionY, wrist_frontal_RR_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_frontal_RR.RightElbowGlobalPositionY, elbow_frontal_RR.Time);

difference = abs(elbow_frontal_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_RR(indexMin, :);
colToSearch1 = find(elbow_frontal_RR.Time == RtableColToSearch1.Time);
difference = abs(elbow_frontal_RR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_RR(indexMin, :);
colToSearch2 = find(elbow_frontal_RR.Time == RtableColToSearch1.Time);
elbow_frontal_RR =  elbow_frontal_RR(colToSearch1:colToSearch2, :);
elbow_frontal_RR.Time = elbow_frontal_RR.Time - elbow_frontal_RR.Time(1);

elbow_extension_LR = readtable('path', 'VariableNamingRule','preserve');
wrist_extension_LR_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_extension_LR = addvars(elbow_extension_LR, wrist_extension_LR_cols.HeadsetGlobalPositionX, wrist_extension_LR_cols.HeadsetGlobalPositionY, wrist_extension_LR_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_extension_LR.LeftElbowGlobalPositionY, elbow_extension_LR.Time);

difference = abs(elbow_extension_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_LR(indexMin, :);
colToSearch1 = find(elbow_extension_LR.Time == RtableColToSearch1.Time);
difference = abs(elbow_extension_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_LR(indexMin, :);
colToSearch2 = find(elbow_extension_LR.Time == RtableColToSearch1.Time);
elbow_extension_LR =  elbow_extension_LR(colToSearch1:colToSearch2, :);
elbow_extension_LR.Time = elbow_extension_LR.Time - elbow_extension_LR.Time(1);

elbow_frontal_LR = readtable('path', 'VariableNamingRule','preserve');
wrist_frontal_LR_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_frontal_LR = addvars(elbow_frontal_LR, wrist_frontal_LR_cols.HeadsetGlobalPositionX, wrist_frontal_LR_cols.HeadsetGlobalPositionY, wrist_frontal_LR_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_frontal_LR.LeftElbowGlobalPositionY, elbow_frontal_LR.Time);

difference = abs(elbow_frontal_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_LR(indexMin, :);
colToSearch1 = find(elbow_frontal_LR.Time == RtableColToSearch1.Time);
difference = abs(elbow_frontal_LR.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_LR(indexMin, :);
colToSearch2 = find(elbow_frontal_LR.Time == RtableColToSearch1.Time);
elbow_frontal_LR =  elbow_frontal_LR(colToSearch1:colToSearch2, :);
elbow_frontal_LR.Time = elbow_frontal_LR.Time - elbow_frontal_LR.Time(1);

elbow_extension_RL = readtable('path', 'VariableNamingRule','preserve');
wrist_extension_RL_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_extension_RL = addvars(elbow_extension_RL, wrist_extension_RL_cols.HeadsetGlobalPositionX, wrist_extension_RL_cols.HeadsetGlobalPositionY, wrist_extension_RL_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_extension_RL.RightElbowGlobalPositionY, elbow_extension_RL.Time);

difference = abs(elbow_extension_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_RL(indexMin, :);
colToSearch1 = find(elbow_extension_RL.Time == RtableColToSearch1.Time);
difference = abs(elbow_extension_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_RL(indexMin, :);
colToSearch2 = find(elbow_extension_RL.Time == RtableColToSearch1.Time);
elbow_extension_RL =  elbow_extension_RL(colToSearch1:colToSearch2, :);
elbow_extension_RL.Time = elbow_extension_RL.Time - elbow_extension_RL.Time(1);

elbow_frontal_RL = readtable('path', 'VariableNamingRule','preserve');
wrist_frontal_RL_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_frontal_RL = addvars(elbow_frontal_RL, wrist_frontal_RL_cols.HeadsetGlobalPositionX, wrist_frontal_RL_cols.HeadsetGlobalPositionY, wrist_frontal_RL_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_frontal_RL.RightElbowGlobalPositionY, elbow_frontal_RL.Time);

difference = abs(elbow_frontal_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_RL(indexMin, :);
colToSearch1 = find(elbow_frontal_RL.Time == RtableColToSearch1.Time);
difference = abs(elbow_frontal_RL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_RL(indexMin, :);
colToSearch2 = find(elbow_frontal_RL.Time == RtableColToSearch1.Time);
elbow_frontal_RL =  elbow_frontal_RL(colToSearch1:colToSearch2, :);
elbow_frontal_RL.Time = elbow_frontal_RL.Time - elbow_frontal_RL.Time(1);

elbow_extension_LL = readtable('path', 'VariableNamingRule','preserve');
wrist_extension_LL_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_extension_LL = addvars(elbow_extension_LL, wrist_extension_LL_cols.HeadsetGlobalPositionX, wrist_extension_LL_cols.HeadsetGlobalPositionY, wrist_extension_LL_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_extension_LL.LeftElbowGlobalPositionY, elbow_extension_LL.Time);

difference = abs(elbow_extension_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_LL(indexMin, :);
colToSearch1 = find(elbow_extension_LL.Time == RtableColToSearch1.Time);
difference = abs(elbow_extension_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_extension_LL(indexMin, :);
colToSearch2 = find(elbow_extension_LL.Time == RtableColToSearch1.Time);
elbow_extension_LL =  elbow_extension_LL(colToSearch1:colToSearch2, :);
elbow_extension_LL.Time = elbow_extension_LL.Time - elbow_extension_LL.Time(1);

elbow_frontal_LL = readtable('path', 'VariableNamingRule','preserve');
wrist_frontal_LL_cols = readtable('path', 'VariableNamingRule','preserve');
elbow_frontal_LL = addvars(elbow_frontal_LL, wrist_frontal_LL_cols.HeadsetGlobalPositionX, wrist_frontal_LL_cols.HeadsetGlobalPositionY, wrist_frontal_LL_cols.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
findMins(elbow_frontal_LL.LeftElbowGlobalPositionY, elbow_frontal_LL.Time);

difference = abs(elbow_frontal_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_LL(indexMin, :);
colToSearch1 = find(elbow_frontal_LL.Time == RtableColToSearch1.Time);
difference = abs(elbow_frontal_LL.Time - 0);
indexMin = difference == min(difference);
RtableColToSearch1 = elbow_frontal_LL(indexMin, :);
colToSearch2 = find(elbow_frontal_LL.Time == RtableColToSearch1.Time);
elbow_frontal_LL =  elbow_frontal_LL(colToSearch1:colToSearch2, :);
elbow_frontal_LL.Time = elbow_frontal_LL.Time - elbow_frontal_LL.Time(1);

%Choose VR movement
%WRIST
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_RF, wrist_extension_RF_vicon, 1, 1);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_LF, wrist_extension_LF_vicon, 0, 1);

% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_RF, wrist_frontal_RF_vicon, 1, 1);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_LF, wrist_frontal_LF_vicon, 0, 1);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_RR, wrist_extension_RR_vicon, 1, 1);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_LR, wrist_extension_LR_vicon, 0, 1);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_RR, wrist_frontal_RR_vicon, 1, 1);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_LR, wrist_frontal_LR_vicon, 0, 1);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_RL, wrist_extension_RL_vicon, 1, 1);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_LL, wrist_extension_LL_vicon, 0, 1);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_RL, wrist_frontal_RL_vicon, 1, 1);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_LL, wrist_frontal_LL_vicon, 0, 1);

%ELBOW
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_RF, elbow_extension_RF_vicon, 1, 2);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_LF, elbow_extension_LF_vicon, 0, 2);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_RF, elbow_frontal_RF_vicon, 1, 2);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_LF, elbow_frontal_LF_vicon, 0, 2);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_RR, elbow_extension_RR_vicon, 1, 2);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_LR, elbow_extension_LR_vicon, 0, 2);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_RR, elbow_frontal_RR_vicon, 1, 2);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_LR, elbow_frontal_LR_vicon, 0, 2);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_RL, elbow_extension_RL_vicon, 1, 2);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_LL, elbow_extension_LL_vicon, 0, 2);
% 
% [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_RL, elbow_frontal_RL_vicon, 1, 2);
% [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_LL, elbow_frontal_LL_vicon, 0, 2);

%Select known points from the graphs plotted
findPeaks(R_VR_trajectory_sagittal, R_VICON_trajectory_sagittal, R_VR_trajectory_transverse, R_VICON_trajectory_transverse, ...
    R_VR_trajectory_frontal, R_VICON_trajectory_frontal, R_x_interp)
findPeaks(L_VR_trajectory_sagittal, L_VICON_trajectory_sagittal, L_VR_trajectory_transverse, L_VICON_trajectory_transverse, ...
    L_VR_trajectory_frontal, L_VICON_trajectory_frontal, L_x_interp)

valToSearch_VR = 0; %initial value right side for Quest data
valToSearch_VR2 = 0; %max value right side for Quest data
valToSearch_VR3 = 0; %min value right side for Quest data
valToSearch_VR4 = 0; %initial value left side for Quest data
valToSearch_VR5 = 0; %max value left side for Quest data
valToSearch_VR6 = 0; %min value left side for Quest data
valToSearch = 0; %initial value right side for VICON data
valToSearch2 = 0; %max value right side for VICON data
valToSearch3 = 0; %min value right side for VICON data
valToSearch4 = 0; %initial value left side for VICON data
valToSearch5 = 0; %max value right left for VICON data
valToSearch6 = 0; %min value right left for VICON data

[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, valToSearch_VR5, valToSearch_VR6, ...
    valToSearch, valToSearch2, valToSearch3, valToSearch4, valToSearch5, valToSearch6, R_x_interp, ...
    L_x_interp, R_VR_trajectory_sagittal, R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, ...
    L_VR_trajectory_transverse, L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);

plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data);

tableCorr = readtable('tableCorr_raw.xlsx', 'VariableNamingRule','preserve');

view = 'F';
movement = 'Elbow extension';

[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%Export tables
writetable(tableCorr, 'tableCorr_raw.xlsx', 'Sheet', 'Sheet1');



function VICON_movement = adjustTableVICON(movement, initialFrame, finalFrame)
    VICON_movement = rmmissing(movement);
    VICON_movement = VICON_movement(initialFrame: finalFrame,:);
   %VICON_movement.Frames = VICON_movement.Frames - initialFrame;
end

function VR_movement = adjustTableVR(movement, initialFrame, finalFrame)
    VR_movement = movement(initialFrame: finalFrame,:);
    %VR_movement.Time = VR_movement.Time - initialFrame;
end

function [x_interp, VICON_trajectory_sagittal, VR_trajectory_sagittal, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = firstPlotViconVSVR(VR_movement, VICON_movement, side, bodypart)
    
    if bodypart == 1
        if side == 1
            VR_movement.RightControllerGlobalPositionX = VR_movement.RightControllerGlobalPositionX - VR_movement.HeadsetGlobalPositionX;
            VR_movement.RightControllerGlobalPositionZ = VR_movement.RightControllerGlobalPositionZ - VR_movement.HeadsetGlobalPositionZ;
            VR_movement.RightControllerGlobalPositionX = -(VR_movement.RightControllerGlobalPositionX);
            %Movement selection
            VICON_movement_frontal = table(VICON_movement.Frames, VICON_movement.RWJCX, 'VariableNames', {'Frames', 'RWJCX'});
            VICON_movement_sagittal = table(VICON_movement.Frames, VICON_movement.RWJCY, 'VariableNames', {'Frames', 'RWJCY'});
            VICON_movement_transverse = table(VICON_movement.Frames, VICON_movement.RWJCZ, 'VariableNames', {'Frames', 'RWJCZ'});
            VR_movement_sagittal = VR_movement(:, [11, 31]);
            VR_movement_transverse = VR_movement(:, [12, 31]);
            VR_movement_frontal = VR_movement(:, [13, 31]);
    
            Time = VR_movement_sagittal.Time;
            VR_sagittal = VR_movement_sagittal.RightControllerGlobalPositionX; 
            VR_transverse = VR_movement_transverse.RightControllerGlobalPositionY;
            VR_frontal = VR_movement_frontal.RightControllerGlobalPositionZ;
            Frame = VICON_movement_sagittal.Frames;
            VICON__sagittal = VICON_movement_sagittal.RWJCY;
            VICON_transverse = VICON_movement_transverse.RWJCZ;
            VICON_frontal = VICON_movement_frontal.RWJCX;
    
            %INTERPOLATE
            [x_interp, VICON_trajectory_sagittal, VR_trajectory_sagittal, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = interpolation(Time, Frame, VICON__sagittal, VR_sagittal, VICON_transverse, VR_transverse, VICON_frontal, VR_frontal);
            distance = VR_trajectory_sagittal(1) - VICON_trajectory_sagittal(1);
            VR_trajectory_sagittal = VR_trajectory_sagittal - distance;
            distance = VR_trajectory_transverse(1) - VICON_trajectory_transverse(1);
            VR_trajectory_transverse = VR_trajectory_transverse - distance;
            distance = VR_trajectory_frontal(1) - VICON_trajectory_frontal(1);
            VR_trajectory_frontal = VR_trajectory_frontal - distance;

            %PLOT
            plotGraphSagittal (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Right side');
            plotGraphTransverse (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Right side');
            plotGraphFrontal (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Right side');
    
            if any(isnan(VICON_trajectory_sagittal), 'all')
                rowsNan = isnan(VICON_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
        
            if any(isnan(VR_trajectory_sagittal), 'all')
                rowsNan = isnan(VR_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
    
        else
            VR_movement.LeftControllerGlobalPositionX = VR_movement.LeftControllerGlobalPositionX - VR_movement.HeadsetGlobalPositionX;
            VR_movement.LeftControllerGlobalPositionZ = VR_movement.LeftControllerGlobalPositionZ - VR_movement.HeadsetGlobalPositionZ;
            VR_movement.LeftControllerGlobalPositionX = -(VR_movement.LeftControllerGlobalPositionX);
    
            %Movement selection
            VICON_movement_frontal = table(VICON_movement.Frames, VICON_movement.LWJCX, 'VariableNames', {'Frames', 'LWJCX'});
            VICON_movement_sagittal = table(VICON_movement.Frames, VICON_movement.LWJCY, 'VariableNames', {'Frames', 'LWJCY'});
            VICON_movement_transverse = table(VICON_movement.Frames, VICON_movement.LWJCZ, 'VariableNames', {'Frames', 'LWJCZ'});
            VR_movement_sagittal = VR_movement(:, [1, 31]);
            VR_movement_transverse = VR_movement(:, [2, 31]);
            VR_movement_frontal = VR_movement(:, [3, 31]);
    
            Time = VR_movement_sagittal.Time;
            VR_sagittal = VR_movement_sagittal.LeftControllerGlobalPositionX; 
            VR_transverse = VR_movement_transverse.LeftControllerGlobalPositionY;
            VR_frontal = VR_movement_frontal.LeftControllerGlobalPositionZ;
            Frame = VICON_movement_sagittal.Frames;
            VICON__sagittal = VICON_movement_sagittal.LWJCY;
            VICON_transverse = VICON_movement_transverse.LWJCZ;
            VICON_frontal = VICON_movement_frontal.LWJCX;
    
            %INTERPOLATE
            [x_interp, VICON_trajectory_sagittal, VR_trajectory_sagittal, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = interpolation(Time, Frame, VICON__sagittal, VR_sagittal, VICON_transverse, VR_transverse, VICON_frontal, VR_frontal);
            distance = VR_trajectory_sagittal(1) - VICON_trajectory_sagittal(1);
            VR_trajectory_sagittal = VR_trajectory_sagittal - distance;
            distance = VR_trajectory_transverse(1) - VICON_trajectory_transverse(1);
            VR_trajectory_transverse = VR_trajectory_transverse - distance;
            distance = VR_trajectory_frontal(1) - VICON_trajectory_frontal(1);
            VR_trajectory_frontal = VR_trajectory_frontal - distance;
            %PLOT
            plotGraphSagittal (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Left side');
            plotGraphTransverse (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Left side');
            plotGraphFrontal (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Left side');
    
            if any(isnan(VICON_trajectory_sagittal), 'all')
                rowsNan = isnan(VICON_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
        
            if any(isnan(VR_trajectory_sagittal), 'all')
                rowsNan = isnan(VR_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
        end

    else

        if side == 1
            VR_movement.RightElbowGlobalPositionX = VR_movement.RightElbowGlobalPositionX - VR_movement.HeadsetGlobalPositionX;
            VR_movement.RightElbowGlobalPositionZ = VR_movement.RightElbowGlobalPositionZ - VR_movement.HeadsetGlobalPositionZ;
            VR_movement.RightElbowGlobalPositionX = -(VR_movement.RightElbowGlobalPositionX);
            %Movement selection
            VICON_movement_frontal = table(VICON_movement.Frames, VICON_movement.RELBX, 'VariableNames', {'Frames', 'RELBX'});
            VICON_movement_sagittal = table(VICON_movement.Frames, VICON_movement.RELBY, 'VariableNames', {'Frames', 'RELBY'});
            VICON_movement_transverse = table(VICON_movement.Frames, VICON_movement.RELBZ, 'VariableNames', {'Frames', 'RELBZ'});
            VR_movement_sagittal = VR_movement(:, [21, 41]);
            VR_movement_transverse = VR_movement(:, [22, 41]);
            VR_movement_frontal = VR_movement(:, [23, 41]);
    
            Time = VR_movement_sagittal.Time;
            VR_sagittal = VR_movement_sagittal.RightElbowGlobalPositionX; 
            VR_transverse = VR_movement_transverse.RightElbowGlobalPositionY;
            VR_frontal = VR_movement_frontal.RightElbowGlobalPositionZ;
            Frame = VICON_movement_sagittal.Frames;
            VICON__sagittal = VICON_movement_sagittal.RELBY;
            VICON_transverse = VICON_movement_transverse.RELBZ;
            VICON_frontal = VICON_movement_frontal.RELBX;
    
            %INTERPOLATE
            [x_interp, VICON_trajectory_sagittal, VR_trajectory_sagittal, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = interpolation(Time, Frame, VICON__sagittal, VR_sagittal, VICON_transverse, VR_transverse, VICON_frontal, VR_frontal);
            distance = VR_trajectory_sagittal(1) - VICON_trajectory_sagittal(1);
            VR_trajectory_sagittal = VR_trajectory_sagittal - distance;
            distance = VR_trajectory_transverse(1) - VICON_trajectory_transverse(1);
            VR_trajectory_transverse = VR_trajectory_transverse - distance;
            distance = VR_trajectory_frontal(1) - VICON_trajectory_frontal(1);
            VR_trajectory_frontal = VR_trajectory_frontal - distance;
            %PLOT
            plotGraphSagittal (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Right side');
            plotGraphTransverse (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Right side');
            plotGraphFrontal (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Right side');
    
            if any(isnan(VICON_trajectory_sagittal), 'all')
                rowsNan = isnan(VICON_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
        
            if any(isnan(VR_trajectory_sagittal), 'all')
                rowsNan = isnan(VR_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
    
        else
            VR_movement.LeftElbowGlobalPositionX = VR_movement.LeftElbowGlobalPositionX - VR_movement.HeadsetGlobalPositionX;
            VR_movement.LeftElbowGlobalPositionZ = VR_movement.LeftElbowGlobalPositionX - VR_movement.HeadsetGlobalPositionZ;
            VR_movement.LeftElbowGlobalPositionX = -(VR_movement.LeftElbowGlobalPositionX);
    
            %Movement selection
            VICON_movement_frontal = table(VICON_movement.Frames, VICON_movement.LELBX, 'VariableNames', {'Frames', 'LELBX'});
            VICON_movement_sagittal = table(VICON_movement.Frames, VICON_movement.LELBY, 'VariableNames', {'Frames', 'LELBY'});
            VICON_movement_transverse = table(VICON_movement.Frames, VICON_movement.LELBZ, 'VariableNames', {'Frames', 'LELBZ'});
            VR_movement_sagittal = VR_movement(:, [1, 41]);
            VR_movement_transverse = VR_movement(:, [2, 41]);
            VR_movement_frontal = VR_movement(:, [3, 41]);
    
            Time = VR_movement_sagittal.Time;
            VR_sagittal = VR_movement_sagittal.LeftElbowGlobalPositionX; 
            VR_transverse = VR_movement_transverse.LeftElbowGlobalPositionY;
            VR_frontal = VR_movement_frontal.LeftElbowGlobalPositionZ;
            Frame = VICON_movement_sagittal.Frames;
            VICON__sagittal = VICON_movement_sagittal.LELBY;
            VICON_transverse = VICON_movement_transverse.LELBZ;
            VICON_frontal = VICON_movement_frontal.LELBX;
    
            %INTERPOLATE
            [x_interp, VICON_trajectory_sagittal, VR_trajectory_sagittal, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = interpolation(Time, Frame, VICON__sagittal, VR_sagittal, VICON_transverse, VR_transverse, VICON_frontal, VR_frontal);
            distance = VR_trajectory_sagittal(1) - VICON_trajectory_sagittal(1);
            VR_trajectory_sagittal = VR_trajectory_sagittal - distance;
            distance = VR_trajectory_transverse(1) - VICON_trajectory_transverse(1);
            VR_trajectory_transverse = VR_trajectory_transverse - distance;
            distance = VR_trajectory_frontal(1) - VICON_trajectory_frontal(1);
            VR_trajectory_frontal = VR_trajectory_frontal - distance;
            %PLOT
            plotGraphSagittal (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Left side');
            plotGraphTransverse (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Left side');
            plotGraphFrontal (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Left side');
    
            if any(isnan(VICON_trajectory_sagittal), 'all')
                rowsNan = isnan(VICON_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
        
            if any(isnan(VR_trajectory_sagittal), 'all')
                rowsNan = isnan(VR_trajectory_sagittal);
                VICON_trajectory_sagittal = VICON_trajectory_sagittal(~rowsNan);
                VR_trajectory_sagittal = VR_trajectory_sagittal(~rowsNan);
                VICON_trajectory_transverse = VICON_trajectory_transverse(~rowsNan);
                VR_trajectory_transverse = VR_trajectory_transverse(~rowsNan);
                VICON_trajectory_frontal = VICON_trajectory_frontal(~rowsNan);
                VR_trajectory_frontal = VR_trajectory_frontal(~rowsNan);
                x_interp = x_interp(~rowsNan);
            end
        end
    end
end

function movement = adjustMovement(serie, val1, val2)
    colExists = ismember('Time', serie.Properties.VariableNames);
    if colExists == 0
        difference_1 = abs(serie.Frames - val1);
        indexMin_1 = find(difference_1 == min(difference_1));
        tableColToSearch_1 = serie(indexMin_1, :);
        colToSearch_1 = find(serie.Frames == tableColToSearch_1.Frames);
        difference_2 = abs(serie.Frames - val2);
        indexMin_2 = find(difference_2 == min(difference_2));
        tableColToSearch_2 = serie(indexMin_2, :);
        colToSearch_2 = find(serie.Frames == tableColToSearch_2.Frames);
        movement = adjustTableVR(serie, colToSearch_1, colToSearch_2);
    else
        difference_1 = abs(serie.Time - val1);
        indexMin_1 = find(difference_1 == min(difference_1));
        tableColToSearch_1 = serie(indexMin_1, :);
        colToSearch_1 = find(serie.Time == tableColToSearch_1.Time);
        difference_2 = abs(serie.Time - val2);
        indexMin_2 = find(difference_2 == min(difference_2));
        tableColToSearch_2 = serie(indexMin_2, :);
        colToSearch_2 = find(serie.Time == tableColToSearch_2.Time);
        movement = adjustTableVR(serie, colToSearch_1, colToSearch_2);
    end
end

function [tableCorr,x] = tableCorrelationXCorrelation (movement_VICON, movement_VR, subject, serie, body_part, view, movement, plane, tableCorr)
    %Correlation
    coefC = corrcoef(movement_VICON, movement_VR);
    r = coefC(1,2);
    newRow = {subject, serie, body_part, view, movement, plane, r};
    tableCorr = [tableCorr; newRow];
    %Cross-correlation
    x = xcorr(movement_VICON, movement_VR, 'normalized');
end

function [Time, VR_sagittal, VR_transverse, VR_frontal, Frame, VICON__sagittal, VICON_transverse, VICON_frontal] = assignVars(t, VR_s, VR_t, VR_f, f, VICON_s, VICON_t, VICON_f)
    Time = t;
    VR_sagittal = VR_s; 
    VR_transverse = VR_t;
    VR_frontal = VR_f;
    Frame = f;
    VICON__sagittal = VICON_s;
    VICON_transverse = VICON_t;
    VICON_frontal = VICON_f;
end

function VR_movement = createTableVR(movement)
    VR_movement = table(movement.LeftControllerGlobalPositionX, movement.LeftControllerGlobalPositionY, ...
        movement.LeftControllerGlobalPositionZ, movement.RightControllerGlobalPositionX, ...
        movement.RightControllerGlobalPositionY, movement.RightControllerGlobalPositionZ, ...
        movement.HeadsetGlobalPositionX , movement.HeadsetGlobalPositionY , ...
        movement.HeadsetGlobalPositionZ ,movement.Time, 'VariableNames', {'LeftControllerGlobalPositionX', ...
        'LeftControllerGlobalPositionY', 'LeftControllerGlobalPositionZ','RightControllerGlobalPositionX', ...
        'RightControllerGlobalPositionY', 'RightControllerGlobalPositionZ', 'HeadsetGlobalPositionX', ...
        'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ', 'Time'});

    namesVariables = VR_movement.Properties.VariableNames;

    for i = 1:numel(namesVariables)
        variable = VR_movement.(namesVariables{i});
        if iscell(variable)
            VR_movement.(namesVariables{i}) = str2double(variable);
        elseif ischar(variable)
            VR_movement.(namesVariables{i}) = str2double(variable);
        end
    end

    for i = 1:length(VR_movement.RightControllerGlobalPositionY)
        if VR_movement.RightControllerGlobalPositionY(i) > 1
            VR_movement.RightControllerGlobalPositionY(i) = VR_movement.RightControllerGlobalPositionY(i)/1000;
        end
    end
    for i = 1:length(VR_movement.LeftControllerGlobalPositionY)
        if VR_movement.LeftControllerGlobalPositionY(i) > 1
            VR_movement.LeftControllerGlobalPositionY(i) = VR_movement.LeftControllerGlobalPositionY(i)/1000;
        end
    end

    VR_movement.HeadsetGlobalPositionY = VR_movement.HeadsetGlobalPositionY/1000;
    VR_movement.LeftControllerGlobalPositionX = VR_movement.LeftControllerGlobalPositionX - VR_movement.HeadsetGlobalPositionX;
    VR_movement.LeftControllerGlobalPositionZ = VR_movement.LeftControllerGlobalPositionZ - VR_movement.HeadsetGlobalPositionZ;
    VR_movement.RightControllerGlobalPositionX = VR_movement.RightControllerGlobalPositionX - VR_movement.HeadsetGlobalPositionX;
    VR_movement.RightControllerGlobalPositionZ = VR_movement.RightControllerGlobalPositionZ - VR_movement.HeadsetGlobalPositionZ;

end

function [x_interp, VICON_trajectory_sagittal, VR_trajectory_saggital, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = interpolation(Time, Frame, VICON__sagittal, VR_sagittal, VICON_transverse, VR_transverse, VICON_frontal, VR_frontal)
    
    minimum = min(min(Time), min(Frame));
    maximum = max(max(Time), max(Frame));
    lengthX = max([length(Time), length(Frame)]);
    
    x_interp = linspace(minimum, maximum, lengthX);
    VICON_trajectory_sagittal = interp1(Frame, VICON__sagittal, x_interp, 'nearest');
    VR_trajectory_saggital = interp1(Time, VR_sagittal, x_interp, 'nearest');
    VICON_trajectory_transverse = interp1(Frame, VICON_transverse, x_interp, 'nearest');
    VR_trajectory_transverse = interp1(Time, VR_transverse, x_interp, 'nearest');
    VICON_trajectory_frontal = interp1(Frame, VICON_frontal, x_interp, 'nearest');
    VR_trajectory_frontal = interp1(Time, VR_frontal, x_interp, 'nearest');

end

function plotGraphSagittal (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, side)
    
    figure
    plot(x_interp, VICON_trajectory_sagittal, 'r-');
    hold on
    plot(x_interp, VR_trajectory_sagittal, 'b-');
    strTitle = ['Subject 4, Serie 1, ' side ', Sagittal Plane'];
    title(strTitle);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON', 'Virtual Reality');
    hold off

end

function plotGraphFrontal (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, side)
    
    figure
    plot(x_interp, VICON_trajectory_frontal, 'r-');
    hold on
    plot(x_interp, VR_trajectory_frontal, 'b-');
    strTitle = ['Subject 4, Serie 1, ' side ', Frontal Plane'];
    title(strTitle);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON', 'Virtual Reality');
    hold off

end

function plotGraphTransverse (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, side)
    
    figure
    plot(x_interp, VICON_trajectory_frontal, 'r-');
    hold on
    plot(x_interp, VR_trajectory_frontal, 'b-');
    strTitle = ['Subject 4, Serie 1, ' side ', Transverse Plane'];
    title(strTitle);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON', 'Virtual Reality');
    hold off

end

function findPeaks(VR_trajectory_saggital, VICON_trajectory_sagittal, VR_trajectory_transverse, VICON_trajectory_transverse, ...
    VR_trajectory_frontal, VICON_trajectory_frontal, x_interp)

    %Calculate the derivative
    dy_dx_VR_sagittal = diff(VR_trajectory_saggital);
    dy_dx_VICON_sagittal = diff(VICON_trajectory_sagittal);
    dy_dx_VR_transverse = diff(VR_trajectory_transverse);
    dy_dx_VICON_transverse = diff(VICON_trajectory_transverse);
    dy_dx_VR_frontal = diff(VR_trajectory_frontal);
    dy_dx_VICON_frontal = diff(VICON_trajectory_frontal);
    
    %Find relative maximum
    max_indices_VR_sagittal = find(dy_dx_VR_sagittal(1:end-1) > 0 & dy_dx_VR_sagittal(2:end) < 0) + 1;
    max_values_VR_sagittal = VR_trajectory_saggital(max_indices_VR_sagittal);
    max_indices_VICON_sagittal = find(dy_dx_VICON_sagittal(1:end-1) > 0 & dy_dx_VICON_sagittal(2:end) < 0) + 1;
    max_values_VICON_sagittal = VICON_trajectory_sagittal(max_indices_VICON_sagittal);
    
    max_indices_VR_transverse = find(dy_dx_VR_transverse(1:end-1) > 0 & dy_dx_VR_transverse(2:end) < 0) + 1;
    max_values_VR_transverse = VR_trajectory_transverse(max_indices_VR_transverse);
    max_indices_VICON_transverse = find(dy_dx_VICON_transverse(1:end-1) > 0 & dy_dx_VICON_transverse(2:end) < 0) + 1;
    max_values_VICON_transverse = VICON_trajectory_transverse(max_indices_VICON_transverse);
    
    max_indices_VR_frontal = find(dy_dx_VR_frontal(1:end-1) > 0 & dy_dx_VR_frontal(2:end) < 0) + 1;
    max_values_VR_frontal = VR_trajectory_frontal(max_indices_VR_frontal);
    max_indices_VICON_frontal = find(dy_dx_VICON_frontal(1:end-1) > 0 & dy_dx_VICON_frontal(2:end) < 0) + 1;
    max_values_VICON_frontal = VICON_trajectory_frontal(max_indices_VICON_frontal);
    
    % Find relative minimum
    min_indices_VR_sagittal = find(dy_dx_VR_sagittal(1:end-1) < 0 & dy_dx_VR_sagittal(2:end) > 0) + 1;
    min_values_VR_sagittal = VR_trajectory_saggital(min_indices_VR_sagittal);
    min_indices_VICON_sagittal = find(dy_dx_VICON_sagittal(1:end-1) < 0 & dy_dx_VICON_sagittal(2:end) > 0) + 1;
    min_values_VICON_sagittal = VICON_trajectory_sagittal(min_indices_VICON_sagittal);
    
    min_indices_VR_transverse = find(dy_dx_VR_transverse(1:end-1) < 0 & dy_dx_VR_transverse(2:end) > 0) + 1;
    min_values_VR_transverse = VR_trajectory_transverse(min_indices_VR_transverse);
    min_indices_VICON_transverse = find(dy_dx_VICON_transverse(1:end-1) < 0 & dy_dx_VICON_transverse(2:end) > 0) + 1;
    min_values_VICON_transverse = VICON_trajectory_transverse(min_indices_VICON_transverse);
    
    min_indices_VR_frontal = find(dy_dx_VR_frontal(1:end-1) < 0 & dy_dx_VR_frontal(2:end) > 0) + 1;
    min_values_VR_frontal = VR_trajectory_frontal(min_indices_VR_frontal);
    min_indices_VICON_frontal = find(dy_dx_VICON_frontal(1:end-1) < 0 & dy_dx_VICON_frontal(2:end) > 0) + 1;
    min_values_VICON_frontal = VICON_trajectory_frontal(min_indices_VICON_frontal);

    % Plot signal and relative maxs
    figure
    plot(x_interp, VICON_trajectory_sagittal, 'r-');
    hold on
    plot(x_interp, VR_trajectory_saggital, 'b-');
    plot(x_interp(max_indices_VR_sagittal), max_values_VR_sagittal, 'ro');
    plot(x_interp(max_indices_VICON_sagittal), max_values_VICON_sagittal, 'bo');
    plot(x_interp(min_indices_VR_sagittal), min_values_VR_sagittal, 'ro');
    plot(x_interp(min_indices_VICON_sagittal), min_values_VICON_sagittal, 'bo');
    plot(x_interp, VICON_trajectory_transverse, 'r--');
    plot(x_interp, VR_trajectory_transverse, 'b--');
    plot(x_interp(max_indices_VR_transverse), max_values_VR_transverse, 'ro');
    plot(x_interp(max_indices_VICON_transverse), max_values_VICON_transverse, 'bo');
    plot(x_interp(min_indices_VR_transverse), min_values_VR_transverse, 'ro');
    plot(x_interp(min_indices_VICON_transverse), min_values_VICON_transverse, 'bo');
    plot(x_interp, VICON_trajectory_frontal, 'r-.');
    plot(x_interp, VR_trajectory_frontal, 'b-.');
    plot(x_interp(max_indices_VR_frontal), max_values_VR_frontal, 'ro');
    plot(x_interp(max_indices_VICON_frontal), max_values_VICON_frontal, 'bo');
    lot(x_interp(min_indices_VR_frontal), min_values_VR_frontal, 'ro');
    plot(x_interp(min_indices_VICON_frontal), min_values_VICON_frontal, 'bo');
    title('Comparison of Planes')
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON  Sagttal', 'Virtual Reality Sagittal', 'VICON Transverse', 'Virtual Reality Transverse', 'VICON Frontal', 'Virtual Reality Frontal');
    hold off

end

function findMins(mov, time)
    %Calculate the derivative
    dy_dx = diff(mov);
    % Find relative minimum
    min_indices = find(dy_dx(1:end-1) < 0 & dy_dx(2:end) > 0) + 1;
    min_values = mov(min_indices);
    % Plot signal and relative maxs
    figure
    plot(time, mov, 'r-');
    hold on
    plot(time(min_indices), min_values, 'bo');
    title('Comparison of Planes')
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    hold off
end

function [R,t] = rigid_transform_3D(A, B)

    narginchk(2,2);
    assert(all(size(A) == size(B)));

    [num_rows, num_cols] = size(A);
    if num_rows ~= 3
        error("matrix A is not 3xN, it is %dx%d", num_rows, num_cols)
    end

    [num_rows, num_cols] = size(B);
    if num_rows ~= 3
        error("matrix B is not 3xN, it is %dx%d", num_rows, num_cols)
    end

    % find mean column wise
    centroid_A = mean(A, 2);
    centroid_B = mean(B, 2);
    disp(centroid_A);
    disp(centroid_B);

    % subtract mean
    Am = A - centroid_A;
    Bm = B - centroid_B;
    disp(Am);
    disp(Bm);

    % calculate covariance matrix (H = (A - centroid_A)(B - centroid_B)^T)
    H = Am * Bm';
    disp(H);

    % find rotation
    [U,~,V] = svd(H);
    R = V*U';
    disp(R);

    %special reflection case
    if det(R) < 0
        fprintf("det(R) < R, reflection detected!, correcting for it ...\n");
        V(:,3) = V(:,3) * (-1);
        R = V*U';
    end

    %Finding the translation
    t = -R*centroid_A + centroid_B;
    disp(t);
end

function [R_new_dataset_VR, L_new_dataset_VR, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, valToSearch_VR5, valToSearch_VR6, ...
    valToSearch, valToSearch2, valToSearch3, valToSearch4, valToSearch5, valToSearch6, R_x_interp, ...
    L_x_interp, R_VR_trajectory_sagittal, R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, ...
    L_VR_trajectory_transverse, L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal)

    %Finding opptimal rotation and translation between corresponding 3D points
    %Define A and B, which are the 3 correpoinding 3D point data for VR and VICON in the same instant.
    %Selection of the 3D point in the VR data
    
    difference = abs(R_x_interp - valToSearch_VR);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch_VR);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VR_S = R_VR_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VR_T = R_VR_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VR_F = R_VR_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VR_S = L_VR_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VR_T = L_VR_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VR_F = L_VR_trajectory_frontal(:, L_colToSearch_VR);
    
    difference = abs(R_x_interp - valToSearch_VR2);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch_VR2);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VR_S2 = R_VR_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VR_T2 = R_VR_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VR_F2 = R_VR_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VR_S2 = L_VR_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VR_T2 = L_VR_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VR_F2 = L_VR_trajectory_frontal(:, L_colToSearch_VR);
    
    difference = abs(R_x_interp - valToSearch_VR3);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch_VR3);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VR_S3 = R_VR_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VR_T3 = R_VR_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VR_F3 = R_VR_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VR_S3 = L_VR_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VR_T3 = L_VR_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VR_F3 = L_VR_trajectory_frontal(:, L_colToSearch_VR);
    
    difference = abs(R_x_interp - valToSearch_VR4);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch_VR4);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VR_S4 = R_VR_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VR_T4 = R_VR_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VR_F4 = R_VR_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VR_S4 = L_VR_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VR_T4 = L_VR_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VR_F4 = L_VR_trajectory_frontal(:, L_colToSearch_VR);

    difference = abs(R_x_interp - valToSearch_VR5);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch_VR5);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VR_S5 = R_VR_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VR_T5 = R_VR_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VR_F5 = R_VR_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VR_S5 = L_VR_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VR_T5 = L_VR_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VR_F5 = L_VR_trajectory_frontal(:, L_colToSearch_VR);

    difference = abs(R_x_interp - valToSearch_VR6);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch_VR6);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VR_S6 = R_VR_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VR_T6 = R_VR_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VR_F6 = R_VR_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VR_S6 = L_VR_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VR_T6 = L_VR_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VR_F6 = L_VR_trajectory_frontal(:, L_colToSearch_VR);
    
    %Selection of the 3D point in the VICON data
    difference = abs(R_x_interp - valToSearch);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VICON_S = R_VICON_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VICON_T = R_VICON_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VICON_F = R_VICON_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VICON_S = L_VICON_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VICON_T = L_VICON_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VICON_F = L_VICON_trajectory_frontal(:, L_colToSearch_VR);
    
    difference = abs(R_x_interp - valToSearch2);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch2);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VICON_S2 = R_VICON_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VICON_T2 = R_VICON_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VICON_F2 = R_VICON_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VICON_S2 = L_VICON_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VICON_T2 = L_VICON_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VICON_F2 = L_VICON_trajectory_frontal(:, L_colToSearch_VR);
    
    difference = abs(R_x_interp - valToSearch3);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch3);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VICON_S3 = R_VICON_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VICON_T3 = R_VICON_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VICON_F3 = R_VICON_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VICON_S3 = L_VICON_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VICON_T3 = L_VICON_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VICON_F3 = L_VICON_trajectory_frontal(:, L_colToSearch_VR);
    
    difference = abs(R_x_interp - valToSearch4);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch4);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VICON_S4 = R_VICON_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VICON_T4 = R_VICON_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VICON_F4 = R_VICON_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VICON_S4 = L_VICON_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VICON_T4 = L_VICON_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VICON_F4 = L_VICON_trajectory_frontal(:, L_colToSearch_VR);

    difference = abs(R_x_interp - valToSearch5);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch5);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VICON_S5 = R_VICON_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VICON_T5 = R_VICON_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VICON_F5 = R_VICON_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VICON_S5 = L_VICON_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VICON_T5 = L_VICON_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VICON_F5 = L_VICON_trajectory_frontal(:, L_colToSearch_VR);

    difference = abs(R_x_interp - valToSearch6);
    indexMin = difference == min(difference);
    tableColToSearch = R_x_interp(indexMin);
    R_colToSearch_VR = find(R_x_interp == tableColToSearch);
    difference = abs(L_x_interp - valToSearch6);
    indexMin = difference == min(difference);
    tableColToSearch = L_x_interp(indexMin);
    L_colToSearch_VR = find(L_x_interp == tableColToSearch);
    R_3DP_VICON_S6 = R_VICON_trajectory_sagittal(:, R_colToSearch_VR);
    R_3DP_VICON_T6 = R_VICON_trajectory_transverse(:, R_colToSearch_VR);
    R_3DP_VICON_F6 = R_VICON_trajectory_frontal(:, R_colToSearch_VR);
    L_3DP_VICON_S6 = L_VICON_trajectory_sagittal(:, L_colToSearch_VR);
    L_3DP_VICON_T6 = L_VICON_trajectory_transverse(:, L_colToSearch_VR);
    L_3DP_VICON_F6 = L_VICON_trajectory_frontal(:, L_colToSearch_VR);
    
    
    %USING ONLY WRISTPOINTS
    A_VR = [R_3DP_VR_S, L_3DP_VR_S, R_3DP_VR_S2, L_3DP_VR_S2, R_3DP_VR_S3, L_3DP_VR_S3, R_3DP_VR_S4, L_3DP_VR_S4, R_3DP_VR_S5, L_3DP_VR_S5, R_3DP_VR_S6, L_3DP_VR_S6;
        R_3DP_VR_T, L_3DP_VR_T, R_3DP_VR_T2, L_3DP_VR_T2, R_3DP_VR_T3, L_3DP_VR_T3, R_3DP_VR_T4, L_3DP_VR_T4, R_3DP_VR_T5, L_3DP_VR_T5, R_3DP_VR_T6, L_3DP_VR_T6;
        R_3DP_VR_F, L_3DP_VR_F, R_3DP_VR_F2, L_3DP_VR_F2, R_3DP_VR_F3, L_3DP_VR_F3, R_3DP_VR_F4, L_3DP_VR_F4, R_3DP_VR_F5, L_3DP_VR_F5, R_3DP_VR_F6, L_3DP_VR_F6];
    B_VICON = [R_3DP_VICON_S, L_3DP_VICON_S, R_3DP_VICON_S2, L_3DP_VICON_S2, R_3DP_VICON_S3, L_3DP_VICON_S3, R_3DP_VICON_S4, L_3DP_VICON_S4, R_3DP_VICON_S5, L_3DP_VICON_S5, R_3DP_VICON_S6, L_3DP_VICON_S6;
        R_3DP_VICON_T, L_3DP_VICON_T, R_3DP_VICON_T2, L_3DP_VICON_T2, R_3DP_VICON_T3, L_3DP_VICON_T3, R_3DP_VICON_T4, L_3DP_VICON_T4, R_3DP_VICON_T5, L_3DP_VICON_T5, R_3DP_VICON_T6, L_3DP_VICON_T6;
        R_3DP_VICON_F, L_3DP_VICON_F, R_3DP_VICON_F2, L_3DP_VICON_F2, R_3DP_VICON_F3, L_3DP_VICON_F3, R_3DP_VICON_F4, L_3DP_VICON_F4, R_3DP_VICON_F5, L_3DP_VICON_F5, R_3DP_VICON_F6, L_3DP_VICON_F6];

    %FINDING THE OPPTIMAL ROTATION AND TRANSLATION
    [R, t] = rigid_transform_3D(A_VR, B_VICON);
    
    %Apply rotation and translation to the VR data
    R_VR_data = table(R_VR_trajectory_sagittal', R_VR_trajectory_transverse', ...
        R_VR_trajectory_frontal', 'VariableNames', {'RightControllerGlobalPositionX', ...
        'RightControllerGlobalPositionY', 'RightControllerGlobalPositionZ'});
    R_VR_data = table2array(R_VR_data);
    L_VR_data = table(L_VR_trajectory_sagittal', L_VR_trajectory_transverse', ...
        L_VR_trajectory_frontal', 'VariableNames', {'LeftControllerGlobalPositionX', ...
        'LeftControllerGlobalPositionY', 'LeftControllerGlobalPositionZ'});
    L_VR_data = table2array(L_VR_data);
    
    R_new_dataset_VR = R*R_VR_data' + repmat(t, 1, size(R_VR_data, 1));
    L_new_dataset_VR = R*L_VR_data' + repmat(t, 1, size(L_VR_data, 1));

    R_new_dataset_VR = array2table(R_new_dataset_VR', 'VariableNames', {'RightControllerGlobalPositionX', ...
        'RightControllerGlobalPositionY', 'RightControllerGlobalPositionZ'});
    colName_VR = 'Time';
    R_new_dataset_VR = addvars(R_new_dataset_VR, R_x_interp', 'NewVariableNames', colName_VR);
    L_new_dataset_VR = array2table(L_new_dataset_VR', 'VariableNames', {'LeftControllerGlobalPositionX', ...
        'LeftControllerGlobalPositionY', 'LeftControllerGlobalPositionZ'});
    L_new_dataset_VR = addvars(L_new_dataset_VR, L_x_interp', 'NewVariableNames', colName_VR);
    
    %VICON data
    R_VICON_data = table(R_VICON_trajectory_frontal', R_VICON_trajectory_sagittal', ...
         R_VICON_trajectory_transverse', R_x_interp', 'VariableNames', {'RWJCX', 'RWJCY', 'RWJCZ', 'Frames'});
    L_VICON_data = table(L_VICON_trajectory_frontal', L_VICON_trajectory_sagittal', ...
         L_VICON_trajectory_transverse', L_x_interp', 'VariableNames', {'LWJCX', 'LWJCY', 'LWJCZ', 'Frames'});
end

function plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data)

    %Plot rotated and translated data
    %RIGHT
    R_Time = R_VR_data.Time;
    R_VR_sagittal = R_VR_data.RightControllerGlobalPositionX; 
    R_VR_transverse = R_VR_data.RightControllerGlobalPositionY;
    R_VR_frontal = R_VR_data.RightControllerGlobalPositionZ;
    R_Frame = R_VICON_data.Frames;
    R_VICON__sagittal = R_VICON_data.RWJCY;
    R_VICON_transverse = R_VICON_data.RWJCZ;
    R_VICON_frontal = R_VICON_data.RWJCX;
    
    %LEFT
    L_Time = L_VR_data.Time;
    L_VR_sagittal = L_VR_data.LeftControllerGlobalPositionX; 
    L_VR_transverse = L_VR_data.LeftControllerGlobalPositionY;
    L_VR_frontal = L_VR_data.LeftControllerGlobalPositionZ;
    L_Frame = L_VICON_data.Frames;
    L_VICON__sagittal = L_VICON_data.LWJCY;
    L_VICON_transverse = L_VICON_data.LWJCZ;
    L_VICON_frontal = L_VICON_data.LWJCX;
    
    %INTERPOLATE
    %RIGHT
    [R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = interpolation(R_Time, R_Frame, R_VICON__sagittal, R_VR_sagittal, R_VICON_transverse, R_VR_transverse, R_VICON_frontal, R_VR_frontal);
    %LEFT
    [L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = interpolation(L_Time, L_Frame, L_VICON__sagittal, L_VR_sagittal, L_VICON_transverse, L_VR_transverse, L_VICON_frontal, L_VR_frontal);
    
    %PLOT ADJUSTED DATA
    %RIGHT
    plotGraphSagittal (R_VR_trajectory_sagittal, R_VICON_trajectory_sagittal, R_x_interp, 'Right side');
    plotGraphTransverse (R_VR_trajectory_transverse, R_VICON_trajectory_transverse, R_x_interp, 'Right side');
    plotGraphFrontal (R_VR_trajectory_frontal, R_VICON_trajectory_frontal, R_x_interp, 'Right side');
    
    %LEFT
    plotGraphSagittal (L_VR_trajectory_sagittal, L_VICON_trajectory_sagittal, L_x_interp, 'Left side');
    plotGraphTransverse (L_VR_trajectory_transverse, L_VICON_trajectory_transverse, L_x_interp, 'Left side');
    plotGraphFrontal (L_VR_trajectory_frontal, L_VICON_trajectory_frontal, L_x_interp, 'Left side');

end

function checkError(A, B)
    n = size(A,1);

    % Recover R and t
    [ret_R, ret_t] = rigid_transform_3D(A, B);

    % Compare the recovered R and t with the original
    B2 = (ret_R*A) + repmat(ret_t, 1, n);
    
    % Find the root mean squared error
    err = B2 - B;
    err = err .* err;
    err = sum(err(:));
    rmse = sqrt(err/n);
    
    fprintf("RMSE: %f\n", rmse);
    
    if rmse < 1e-5
        fprintf("Everything looks good!\n");
    else
        fprintf("Hmm something doesn't look right ...\n");
    end
end

function [tableCorr, tableXCorr] = analysisMovement(serie_VICON, serie_VR, movement, view, mov, subject, strsubject, serie, strserie, bodypart, tableCorr)
    
    if strcmp(view, 'RF') || strcmp(view, 'RR') || strcmp(view, 'RL')
        [Time, VR_sagittal, VR_transverse, VR_frontal, Frame, VICON__sagittal, VICON_transverse, VICON_frontal] = assignVars(serie_VR.Time, serie_VR.RightControllerGlobalPositionX, serie_VR.RightControllerGlobalPositionY, serie_VR.RightControllerGlobalPositionZ, serie_VICON.Frames, serie_VICON.RWJCY, serie_VICON.RWJCZ, serie_VICON.RWJCX);
    else
        [Time, VR_sagittal, VR_transverse, VR_frontal, Frame, VICON__sagittal, VICON_transverse, VICON_frontal] = assignVars(serie_VR.Time, serie_VR.LeftControllerGlobalPositionX, serie_VR.LeftControllerGlobalPositionY, serie_VR.LeftControllerGlobalPositionZ, serie_VICON.Frames, serie_VICON.LWJCY, serie_VICON.LWJCZ, serie_VICON.LWJCX);
    end

    %[x_interp, VICON_trajectory_sagittal, VR_trajectory_sagittal, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = interpolation(Time, Frame, VICON__sagittal, VR_sagittal, VICON_transverse, VR_transverse, VICON_frontal, VR_frontal);
    
    %RESAMPLE + PLOT
    newTam = max(length(Time), length(Frame));
    if length(Time) > length(Frame)
        xTam = Time;
    else
        xTam = Frame;
    end
    VR_sagittal = resample(VR_sagittal, newTam, numel(VR_sagittal));
    VICON__sagittal = resample(VICON__sagittal, newTam, numel(VICON__sagittal));
    side = ['', view, ' ', movement ''];
    plotGraphSagittal (VR_sagittal, VICON__sagittal, xTam, side);
    name_graph = ['s', num2str(subject), '_s', num2str(serie), '_', view, '_', bodypart, '_', mov, '_sagittal.fig'];
    savefig(name_graph);

    newTam = max(length(VR_transverse), length(VICON_transverse));
    VR_transverse = resample(VR_transverse, newTam, numel(VR_transverse));
    VICON_transverse = resample(VICON_transverse, newTam, numel(VICON_transverse));
    side = ['', view, ' ', movement ''];
    plotGraphSagittal (VR_transverse, VICON_transverse, xTam, side);
    name_graph = ['s', num2str(subject), '_s', num2str(serie), '_', view, '_', bodypart, '_', mov, '_transverse.fig'];
    savefig(name_graph);

    newTam = max(length(VR_frontal), length(VICON_transverse));
    VR_frontal = resample(VR_frontal, newTam, numel(VR_frontal));
    VICON_frontal = resample(VICON_frontal, newTam, numel(VICON_frontal));
    side = ['', view, ' ', movement ''];
    plotGraphFrontal (VR_frontal, VICON_frontal, xTam, side);
    name_graph = ['s', num2str(subject), '_s', num2str(serie), '_', view, '_', bodypart, '_', mov, '_frontal.fig'];
    savefig(name_graph);
    
    %CORRELATION AND CROSS-CORRELATION
    %RIGHT
    % VICON_trajectory_sagittal = VICON__sagittal(:, 2:end-1);
    % VR_trajectory_sagittal = VR_sagittal(:, 2:end-1);
    [tableCorr, x] = tableCorrelationXCorrelation (VICON__sagittal, VR_sagittal, strsubject, strserie, bodypart, view, movement, 'Sagittal', tableCorr);
    tableXCorr= table(x', 'VariableNames', {'Sagittal'});
    
    % VICON_trajectory_transverse = VICON_transverse(:, 2:end-1);
    % VR_trajectory_transverse = VR_transverse(:, 2:end-1);
    [tableCorr, x] = tableCorrelationXCorrelation (VICON_transverse, VR_transverse, strsubject, strserie, bodypart, view, movement, 'Transverse', tableCorr);
    tableXCorr = addvars(tableXCorr, x', 'NewVariableNames', {'Transverse'});
    
    % VICON_trajectory_frontal = VICON_frontal(:, 2:end-1);
    % VR_trajectory_frontal = VR_frontal(:, 2:end-1);
    [tableCorr, x] = tableCorrelationXCorrelation (VICON_frontal, VR_frontal, strsubject, strserie, bodypart, view, movement, 'Frontal', tableCorr);
    tableXCorr = addvars(tableXCorr, x', 'NewVariableNames', {'Frontal'});
    
    %Plot cross-correlation
    figure
    plot(tableXCorr.Sagittal, 'r-');
    hold on
    plot(tableXCorr.Transverse, 'b-');
    plot(tableXCorr.Frontal, 'g-');
    name_title = ['Cross-Correlation ', movement];
    title(name_title);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('Sagittal Plane', 'Transverse Plane', 'Frontal Plane');
    hold off
    name_graph = ['', view, '_xcorelation_', bodypart, '_', mov, '.fig'];
    savefig(name_graph);
    
    %EXPORT TABLES
    if strcmp(view, 'RF') || strcmp(view, 'RR') || strcmp(view, 'RL')
        %x = x(:, 2:end-1);
        R_data = table(VICON__sagittal, VR_sagittal, VICON_transverse, ...
            VR_transverse, VICON_frontal, VR_frontal, xTam, 'VariableNames', ...
            {'RWJCX', 'RightControllerPositionZ', 'RWJCZ', 'RightControllerPositionY','RWJCY', 'RightControllerPositionX', 'Frames'});
        name_file = ['s', num2str(subject), '_s', num2str(serie), '_', view, '_', bodypart, '_', mov, '.xlsx'];
        writetable(R_data, name_file, 'Sheet', 'Sheet1');
    else
        %x = x(:, 2:end-1);
        L_data = table(VICON__sagittal, VR_sagittal, VICON_transverse, ...
            VR_transverse, VICON_frontal, VR_frontal, xTam, 'VariableNames', ...
            {'LWJCX', 'LeftControllerPositionZ', 'LWJCZ', 'LeftControllerPositionY','LWJCY', 'LeftControllerPositionX', 'Frames'});
        name_file = ['s', num2str(subject), '_s', num2str(serie), '_', view, '_', bodypart, '_', mov, '.xlsx'];
        writetable(L_data, name_file, 'Sheet', 'Sheet1');
    end
    
end

function [tableCorr] = dataAnalysis_IO(serie_R_VICON, serie_R_VR, serie_L_VICON, serie_L_VR, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr)
    
    if strcmp(movement, 'Elbow extension')
        mov = 'EE';
        if strcmp(view, 'F')
            viewR = 'RF';
            viewL = 'LF';
            [tableCorr, RF_tableXCorr_EE] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LF_tableXCorr_EE] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RF_', bodypart, '_EE_correlation_table.xlsx'];
            writetable(RF_tableXCorr_EE, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LF_', bodypart, '_EE_correlation_table.xlsx'];
            writetable(LF_tableXCorr_EE, name_file, 'Sheet', 'Sheet1');
            
        elseif strcmp(view, 'R')
            viewR = 'RR';
            viewL = 'LR';
            [tableCorr, RR_tableXCorr_EE] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LR_tableXCorr_EE] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RR_', bodypart, '_EE_correlation_table.xlsx'];
            writetable(RR_tableXCorr_EE, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LR_', bodypart, '_EE_correlation_table.xlsx'];
            writetable(LR_tableXCorr_EE, name_file, 'Sheet', 'Sheet1');

        elseif strcmp(view, 'L')
            viewR = 'RL';
            viewL = 'LL';
            [tableCorr, RL_tableXCorr_EE] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LL_tableXCorr_EE] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RL_', bodypart, '_EE_correlation_table.xlsx'];
            writetable(RL_tableXCorr_EE, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LL_', bodypart, '_EE_correlation_table.xlsx'];
            writetable(LL_tableXCorr_EE, name_file, 'Sheet', 'Sheet1');

        else
            error('The view must be frontal (F), right (R), or left (L)');
        end

    elseif strcmp(movement, 'Frontal extension')
        mov = 'F';
        if strcmp(view, 'F')
            viewR = 'RF';
            viewL = 'LF';
            [tableCorr, RF_tableXCorr_F] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LF_tableXCorr_F] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);

            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RF_', bodypart, '_F_correlation_table.xlsx'];
            writetable(RF_tableXCorr_F, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LF_', bodypart, '_F_correlation_table.xlsx'];
            writetable(LF_tableXCorr_F, name_file, 'Sheet', 'Sheet1');

        elseif strcmp(view, 'R')
            viewR = 'RR';
            viewL = 'LR';
            [tableCorr, RR_tableXCorr_F] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LR_tableXCorr_F] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RR_', bodypart, '_F_correlation_table.xlsx'];
            writetable(RR_tableXCorr_F, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LR_', bodypart, '_F_correlation_table.xlsx'];
            writetable(LR_tableXCorr_F, name_file, 'Sheet', 'Sheet1');

        elseif strcmp(view, 'L')
            viewR = 'RL';
            viewL = 'LL';
            [tableCorr, RL_tableXCorr_F] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LL_tableXCorr_F] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RL_', bodypart, '_F_correlation_table.xlsx'];
            writetable(RL_tableXCorr_F, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LL_', bodypart, '_F_correlation_table.xlsx'];
            writetable(LL_tableXCorr_F, name_file, 'Sheet', 'Sheet1');

        else
            error('The view must be frontal (F), right (R), or left (L)');
        end
    elseif strcmp(movement, '90 degree movement')
        mov = '90D';
        if strcmp(view, 'F')
            viewR = 'RF';
            viewL = 'LF';
            [tableCorr, RF_tableXCorr_90D] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LF_tableXCorr_90D] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RF_', bodypart, '_90D_correlation_table.xlsx'];
            writetable(RF_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LF_', bodypart, '_90D_correlation_table.xlsx'];
            writetable(LF_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');

        elseif strcmp(view, 'R')
            viewR = 'RR';
            viewL = 'LR';
            [tableCorr, RR_tableXCorr_90D] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LR_tableXCorr_90D] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RR_', bodypart, '_90D_correlation_table.xlsx'];
            writetable(RR_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LR_', bodypart, '_90D_correlation_table.xlsx'];
            writetable(LR_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');

        elseif strcmp(view, 'L')
            viewR = 'RL';
            viewL = 'LL';
            [tableCorr, RL_tableXCorr_90D] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LL_tableXCorr_90D] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RL_', bodypart, '_90D_correlation_table.xlsx'];
            writetable(RL_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LL_', bodypart, '_90D_correlation_table.xlsx'];
            writetable(LL_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');

        else
            error('The view must be frontal (F), right (R), or left (L)');
        end

     elseif strcmp(movement, 'Lateral extension')
        mov = 'L';
        if strcmp(view, 'F')
            viewR = 'RF';
            viewL = 'LF';
            [tableCorr, RF_tableXCorr_L] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LF_tableXCorr_L] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);

            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RF_', bodypart, '_L_correlation_table.xlsx'];
            writetable(RF_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LF_', bodypart, '_L_correlation_table.xlsx'];
            writetable(LF_tableXCorr_L, name_file, 'Sheet', 'Sheet1');

        elseif strcmp(view, 'R')
            viewR = 'RR';
            viewL = 'LR';
            [tableCorr, RR_tableXCorr_L] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LR_tableXCorr_L] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RR_', bodypart, '_L_correlation_table.xlsx'];
            writetable(RR_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LR_', bodypart, '_L_correlation_table.xlsx'];
            writetable(LR_tableXCorr_L, name_file, 'Sheet', 'Sheet1');

        elseif strcmp(view, 'L')
            viewR = 'RL';
            viewL = 'LL';
            [tableCorr, RL_tableXCorr_L] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LL_tableXCorr_L] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_RL_', bodypart, '_L_correlation_table.xlsx'];
            writetable(RL_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
            name_file = ['s', num2str(subject), '_s', num2str(serie), '_LL_', bodypart, '_L_correlation_table.xlsx'];
            writetable(LL_tableXCorr_L, name_file, 'Sheet', 'Sheet1');

        else
            error('The view must be frontal (F), right (R), or left (L)');
        end
    else
        error('The movement must be Elbow extension/90 degree movement/Frontal extension/Lateral extension');
    end
end