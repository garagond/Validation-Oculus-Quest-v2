%We define the number of subject, the number of serie and the bodypart
%corresponding to the movement we are analyzing
subject = 'Subject 1';
strsubject = '1';
serie = 'Serie 1';
strserie = '1';

%Load table with the data from Vicon
filename = 'dynamic_run_trajectories path';
opts = detectImportOptions(filename, 'NumHeaderLines', 0);
trayectories_vicon = readtable(filename, opts);

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
%Adjust time: vicon data register --> 0.01s corresponds to a frame approx.
trajectories_wrist.Frames = trajectories_wrist.Frames/100;

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
%Adjust time
trajectories_elbow.Frames = trajectories_elbow.Frames/100;

%Plot the trayectory of the right and left wrists and elbows y the Z axis
%(from the center of the subject towards its head) in order to make a first
%overview of the movements.
figure
plot(trajectories_wrist.Frames, trajectories_wrist.RWJCZ);
figure
plot(trajectories_wrist.Frames, trajectories_wrist.LWJCZ);

figure
plot(trajectories_elbow.Frames, trajectories_elbow.RELBZ);
figure
plot(trajectories_elbow.Frames, trajectories_elbow.LELBZ);

%Cut vicon data into the four different movements for each serie
%WRIST
%Plot serie for the right arm highlighting the local minima
figure
TF = islocalmin(trajectories_wrist.RWJCZ);
plot(trajectories_wrist.Frames, trajectories_wrist.RWJCZ, trajectories_wrist.Frames(TF), trajectories_wrist.RWJCZ(TF), 'r*');
%Generate six new tables that correspond to elbow and shoulder extension of
%the right arm with the hradset facing front, right, and left.
wEERF_I = 844; %body part (w=wrist) - MOVEMENT(EE=elbow extension) - ARM (R=right)- VIEW (F=frontal)_ initial/end
wEERF_E = 1705;
wrist_extension_RF_vicon =  trajectories_wrist(wEERF_I:wEERF_E, :);
wrist_extension_RF_vicon.Frames = wrist_extension_RF_vicon.Frames - wrist_extension_RF_vicon.Frames(1);
wFRF_I = 4082;
wFRF_E = 4988;
wrist_frontal_RF_vicon = trajectories_wrist(wFRF_I:wFRF_E, :);
wrist_frontal_RF_vicon.Frames = wrist_frontal_RF_vicon.Frames - wrist_frontal_RF_vicon.Frames(1);
wEERR_I = 11998;
wEERR_E = 12797;
wrist_extension_RR_vicon = trajectories_wrist(wEERR_I:wEERR_E, :);
wrist_extension_RR_vicon.Frames = wrist_extension_RR_vicon.Frames - wrist_extension_RR_vicon.Frames(1);
wFRR_I = 14712;
wFRR_E = 15687;
wrist_frontal_RR_vicon = trajectories_wrist(wFRR_I:wFRR_E, :);
wrist_frontal_RR_vicon.Frames = wrist_frontal_RR_vicon.Frames - wrist_frontal_RR_vicon.Frames(1);
wEERL_I = 22430;
wEERL_E = 23121;
wrist_extension_RL_vicon = trajectories_wrist(wEERL_I:wEERL_E, :);
wrist_extension_RL_vicon.Frames = wrist_extension_RL_vicon.Frames - wrist_extension_RL_vicon.Frames(1);
wFRR_I = 25137;
wFRR_E = 26020;
wrist_frontal_RL_vicon = trajectories_wrist(wFRR_I:wFRR_E, :);
wrist_frontal_RL_vicon.Frames = wrist_frontal_RL_vicon.Frames - wrist_frontal_RL_vicon.Frames(1);

%Plot serie for the left arm highlighting the local minima
figure
TF = islocalmin(trajectories_wrist.LWJCZ);
plot(trajectories_wrist.Frames, trajectories_wrist.LWJCZ, trajectories_wrist.Frames(TF), trajectories_wrist.LWJCZ(TF), 'r*');
%Generate six new tables that correspond to elbow and shoulder extension of
%the right arm with the hradset facing front, right, and left.
wEELF_I = 6689;
wEELF_E = 7442;
wrist_extension_LF_vicon = trajectories_wrist(wEELF_I:wEELF_E, :);
wrist_extension_LF_vicon.Frames = wrist_extension_LF_vicon.Frames - wrist_extension_LF_vicon.Frames(1);
wFLF_I = 9116;
wFLF_E = 10083;
wrist_frontal_LF_vicon = trajectories_wrist(wFLF_I:wFLF_E, :);
wrist_frontal_LF_vicon.Frames = wrist_frontal_LF_vicon.Frames - wrist_frontal_LF_vicon.Frames(1);
wEELR_I = 17277;
wEELR_E = 18076;
wrist_extension_LR_vicon = trajectories_wrist(wEELR_I:wEELR_E, :);
wrist_extension_LR_vicon.Frames = wrist_extension_LR_vicon.Frames - wrist_extension_LR_vicon.Frames(1);
wFLR_I = 19647;
wFLR_E = 20632;
wrist_frontal_LR_vicon = trajectories_wrist(wFLR_I:wFLR_E, :);
wrist_frontal_LR_vicon.Frames = wrist_frontal_LR_vicon.Frames - wrist_frontal_LR_vicon.Frames(1);
wEELL_I = 27453;
wEELL_E = 28173;
wrist_extension_LL_vicon =trajectories_wrist(wEELL_I:wEELL_E, :);
wrist_extension_LL_vicon.Frames = wrist_extension_LL_vicon.Frames - wrist_extension_LL_vicon.Frames(1);
wFLL_I = 29601;
wFLL_E = 30454;
wrist_frontal_LL_vicon = trajectories_wrist(wFLL_I:wFLL_E, :);
wrist_frontal_LL_vicon.Frames = wrist_frontal_LL_vicon.Frames - wrist_frontal_LL_vicon.Frames(1);

%ELBOW
%Plot serie for the right arm highlighting the local minima
figure
TF = islocalmin(trajectories_elbow.RELBZ);
plot(trajectories_elbow.Frames, trajectories_elbow.RELBZ, trajectories_elbow.Frames(TF), trajectories_elbow.RELBZ(TF), 'r*');
%Generate six new tables that correspond to elbow and shoulder extension of
%the right arm with the hradset facing front, right, and left.
eEERF_I = 879;
eEERF_E = 1665;
elbow_extension_RF_vicon =  trajectories_elbow(eEERF_I:eEERF_E, :);
elbow_extension_RF_vicon.Frames = elbow_extension_RF_vicon.Frames - elbow_extension_RF_vicon.Frames(1);
eFRF_I = 4085;
eFRF_E = 4974;
elbow_frontal_RF_vicon = trajectories_elbow(eFRF_I:eFRF_E, :);
elbow_frontal_RF_vicon.Frames = elbow_frontal_RF_vicon.Frames - elbow_frontal_RF_vicon.Frames(1);
eEERR_I = 12035;
eEERR_E = 12777;
elbow_extension_RR_vicon = trajectories_elbow(eEERR_I:eEERR_E, :);
elbow_extension_RR_vicon.Frames = elbow_extension_RR_vicon.Frames - elbow_extension_RR_vicon.Frames(1);
eFRR_I = 14714;
eFRR_E = 15677;
elbow_frontal_RR_vicon = trajectories_elbow(eFRR_I:eFRR_E, :);
elbow_frontal_RR_vicon.Frames = elbow_frontal_RR_vicon.Frames - elbow_frontal_RR_vicon.Frames(1);
eEERL_I = 22465;
eEERL_E = 23104;
elbow_extension_RL_vicon = trajectories_elbow(eEERL_I:eEERL_E, :);
elbow_extension_RL_vicon.Frames = elbow_extension_RL_vicon.Frames - elbow_extension_RL_vicon.Frames(1);
eFRL_I = 25143;
eFRL_E = 26013;
elbow_frontal_RL_vicon = trajectories_elbow(eFRL_I:eFRL_E, :);
elbow_frontal_RL_vicon.Frames = elbow_frontal_RL_vicon.Frames - elbow_frontal_RL_vicon.Frames(1);

%Plot serie for the left arm highlighting the local minima
figure
TF = islocalmin(trajectories_elbow.LELBZ);
plot(trajectories_elbow.Frames, trajectories_elbow.LELBZ, trajectories_elbow.Frames(TF), trajectories_elbow.LELBZ(TF), 'r*');
%Generate six new tables that correspond to elbow and shoulder extension of
%the right arm with the hradset facing front, right, and left.
eEELF_I = 6716;
eEELF_E = 7420;
elbow_extension_LF_vicon = trajectories_elbow(eEELF_I:eEELF_E, :);
elbow_extension_LF_vicon.Frames = elbow_extension_LF_vicon.Frames - elbow_extension_LF_vicon.Frames(1);
eFLF_I = 9130;
eFLF_E = 10078;
elbow_frontal_LF_vicon = trajectories_elbow(eFLF_I:eFLF_E, :);
elbow_frontal_LF_vicon.Frames = elbow_frontal_LF_vicon.Frames - elbow_frontal_LF_vicon.Frames(1);
eEELR_I = 17329;
eEELR_E = 18037;
elbow_extension_LR_vicon = trajectories_elbow(eEELR_I:eEELR_E, :);
elbow_extension_LR_vicon.Frames = elbow_extension_LR_vicon.Frames - elbow_extension_LR_vicon.Frames(1);
eFLR_I = 19648;
eFLR_E = 20311;
elbow_frontal_LR_vicon = trajectories_elbow(eFLR_I:eFLR_E, :);
elbow_frontal_LR_vicon.Frames = elbow_frontal_LR_vicon.Frames - elbow_frontal_LR_vicon.Frames(1);
eEELL_I = 27489;
eEELL_E = 28132;
elbow_extension_LL_vicon = trajectories_elbow(eEELL_I:eEELL_E, :);
elbow_extension_LL_vicon.Frames = elbow_extension_LL_vicon.Frames - elbow_extension_LL_vicon.Frames(1);
eFLL_I = 29614;
eFLL_E = 30538;
elbow_frontal_LL_vicon = trajectories_elbow(eFLL_I:eFLL_E, :);
elbow_frontal_LL_vicon.Frames = elbow_frontal_LL_vicon.Frames - elbow_frontal_LL_vicon.Frames(1);

% %Load data Oculus Quest and cut it to fit only the fragments where the
% controllers are moving
% %Elbow extension, Right arm, Frontal view
filename1 = 'Originales path'; %ORIGINALES
wrist_extension_RF = wR_cutTable(filename1);
filename2 = 'Derivados path'; %DERIVADOS
elbow_extension_RF = eR_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 0.52874;
end_point_w = 9.11998;
wrist_extension_RF = w_adjustTableVR(wrist_extension_RF, initial_point_w, end_point_w);
initial_point_e = 0.62657;
end_point_e = 10.0527;
elbow_extension_RF = e_adjustTableVR(elbow_extension_RF, initial_point_e, end_point_e);

%Shoulder extension, Right arm, Frontal view
filename1 = 'Originales path';
wrist_frontal_RF = wR_cutTable(filename1);
filename2 = 'Derivados path';
elbow_frontal_RF = eR_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 14.0905;
end_point_w = 23.531;
wrist_frontal_RF = w_adjustTableVR(wrist_frontal_RF, initial_point_w, end_point_w);
initial_point_e = 14.8287;
end_point_e = 24.3105;
elbow_frontal_RF = e_adjustTableVR(elbow_frontal_RF, initial_point_e, end_point_e);

%Elbow extension, Left arm, Frontal view
filename1 = 'Originales path';
wrist_extension_LF = wL_cutTable(filename1);
filename2 = 'Derivados path';
elbow_extension_LF = eL_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 25.8;
end_point_w = 33.1663;
wrist_extension_LF = w_adjustTableVR(wrist_extension_LF, initial_point_w, end_point_w);
initial_point_e = 25.8005;
end_point_e = 33.1801;
elbow_extension_LF = e_adjustTableVR(elbow_extension_LF, initial_point_e, end_point_e);

%Shoulder extension, Left arm, Frontal view
filename1 = 'Originales path';
wrist_frontal_LF = wL_cutTable(filename1);
filename2 = 'Derivados path';
elbow_frontal_LF = eL_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_frontal_LF = w_adjustTableVR(wrist_frontal_LF, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_frontal_LF = e_adjustTableVR(elbow_frontal_LF, initial_point_e, end_point_e);

%Elbow extension, Right arm, Right view
filename1 = 'Originales path';
wrist_extension_RR = wR_cutTable(filename1);
filename2 = 'Derivados path';
elbow_extension_RR = eR_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_extension_RR = w_adjustTableVR(wrist_extension_RR, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_extension_RR = e_adjustTableVR(elbow_extension_RR, initial_point_e, end_point_e);

%Shoulder extension, Right arm, Right view
filename1 = 'Originales path';
wrist_frontal_RR = wR_cutTable(filename1);
filename2 = 'Derivados path';
elbow_frontal_RR = eR_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_frontal_RR = w_adjustTableVR(wrist_frontal_RR, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_frontal_RR = e_adjustTableVR(elbow_frontal_RR, initial_point_e, end_point_e);

%Elbow extension, Left arm, Right view
filename1 = 'Originales path';
wrist_extension_LR = wL_cutTable(filename1);
filename2 = 'Derivados path';
elbow_extension_LR = eL_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_extension_LR = w_adjustTableVR(wrist_extension_LR, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_extension_LR = e_adjustTableVR(elbow_extension_LR, initial_point_e, end_point_e);

%Shoulder extension, Left arm, Right view
filename1 = 'Originales path';
wrist_frontal_LR = wL_cutTable(filename1);
filename2 = 'CDerivados path';
elbow_frontal_LR = eL_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_frontal_LR = w_adjustTableVR(wrist_frontal_LR, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_frontal_LR = e_adjustTableVR(elbow_frontal_LR, initial_point_e, end_point_e);

%Elbow extension, Right arm, Left view
filename1 = 'Originales path';
wrist_extension_RL = wR_cutTable(filename1);
filename2 = 'Derivados path';
elbow_extension_RL = eR_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_extension_RL = w_adjustTableVR(wrist_extension_RL, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_extension_RL = e_adjustTableVR(elbow_extension_RL, initial_point_e, end_point_e);

%Shoulder extension, Right arm, Left view
filename1 = 'Originales path';
wrist_frontal_RL = wR_cutTable(filename1);
filename2 = 'Derivados path';
elbow_frontal_RL = eR_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_frontal_RL = w_adjustTableVR(wrist_frontal_RL, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_frontal_RL = e_adjustTableVR(elbow_frontal_RL, initial_point_e, end_point_e);

%Elbow extension, Left arm, Left view
filename1 = 'Originales path';
wrist_extension_LL = wL_cutTable(filename1);
filename2 = 'Derivados path';
elbow_extension_LL = eL_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_extension_LL = w_adjustTableVR(wrist_extension_LL, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_extension_LL = e_adjustTableVR(elbow_extension_LL, initial_point_e, end_point_e);

%Shoulder extension, Left arm, Left view
filename1 = 'Originales path';
wrist_frontal_LL = wL_cutTable(filename1);
filename2 = 'Derivados path';
elbow_frontal_LL = eL_cutTable(filename1, filename2);
%Cut the signal
initial_point_w = 1;
end_point_w = 2;
wrist_frontal_LL = w_adjustTableVR(wrist_frontal_LL, initial_point_w, end_point_w);
initial_point_e = 1;
end_point_e = 2;
elbow_frontal_LL = e_adjustTableVR(elbow_frontal_LL, initial_point_e, end_point_e);


%WRIST
bodypart = 'wrist';
%Impor the table were we register the correlations between Vicon and VR
%signals.
tableCorr = readtable('path tableCorr.csv', 'VariableNamingRule','preserve');
%ELBOW EXTENSION, FRONTAL VIEW
%This variables are used to name the Excel where the final data will be stored
view = 'F';
movement = 'Elbow extension';
%Plot a first visualization of both signals overlapped.
%The numbers indicate the side(1=right, 0=left) and body part (1=wrist, 2=elbow), respectively
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_RF, wrist_extension_RF_vicon, 1, 1);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_LF, wrist_extension_LF_vicon, 0, 1);
%Select known points from the graphs plotted - they are needed to apply the
%rotation-traslation algorithm
valToSearch_VR = 0; %max value right side for Quest data
valToSearch_VR2 = 1; %min value right side for Quest data
valToSearch_VR3 = 0; %max value left side for Quest data
valToSearch_VR4 = 1; %min value left side for Quest data
valToSearch_VICON = 0; %max value right side for VICON data
valToSearch_VICON2 = 1; %min value right side for VICON data
valToSearch_VICON3 = 0; %max value left side for VICON data
valToSearch_VICON4 = 1; %min value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals overlapped to check that there has been an
%improvement and the signals are more similar. If you want to plot the
%signals before saving them, uncomment the following line of code.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation between signals, plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%SHOULDER EXTENSION, FRONTAL VIEW
view = 'F';
movement = 'Frontal extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_RF, wrist_frontal_RF_vicon, 1, 1);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_LF, wrist_frontal_LF_vicon, 0, 1);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%ELBOW EXTENSION, RIGHT VIEW
view = 'R';
movement = 'Elbow extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_RR, wrist_extension_RR_vicon, 1, 1);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_LR, wrist_extension_LR_vicon, 0, 1);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%SHOULDER EXTENSION, RIGHT VIEW
view = 'R';
movement = 'Frontal extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_RR, wrist_frontal_RR_vicon, 1, 1);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_LR, wrist_frontal_LR_vicon, 0, 1);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%ELBOW EXTENSION, LEFT VIEW
view = 'L';
movement = 'Elbow extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_RL, wrist_extension_RL_vicon, 1, 1);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_extension_LL, wrist_extension_LL_vicon, 0, 1);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%SHOULDER EXTENSION, LEFT VIEW
view = 'L';
movement = 'Frontal extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_RL, wrist_frontal_RL_vicon, 1, 1);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(wrist_frontal_LL, wrist_frontal_LL_vicon, 0, 1);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%ELBOW
bodypart = 'elbow';
%ELBOW EXTENSION, FRONTAL VIEW
view = 'F';
movement = 'Elbow extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_RF, elbow_extension_RF_vicon, 1, 2);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_LF, elbow_extension_LF_vicon, 0, 2);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%SHOULDER EXTENSION, FRONTAL VIEW
view = 'F';
movement = 'Frontal extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_RF, elbow_frontal_RF_vicon, 1, 2);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_LF, elbow_frontal_LF_vicon, 0, 2);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%ELBOW EXTENSION, RIGHT VIEW
view = 'R';
movement = 'Elbow extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_RR, elbow_extension_RR_vicon, 1, 2);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_LR, elbow_extension_LR_vicon, 0, 2);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%SHOULDER EXTENSION, RIGHT VIEW
view = 'R';
movement = 'Frontal extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_RR, elbow_frontal_RR_vicon, 1, 2);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_LR, elbow_frontal_LR_vicon, 0, 2);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%ELBOW EXTENSION, LEFT VIEW
view = 'L';
movement = 'Elbow extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_RL, elbow_extension_RL_vicon, 1, 2);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_extension_LL, elbow_extension_LL_vicon, 0, 2);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%SHOULDER EXTENSION, LEFT VIEW
view = 'L';
movement = 'Frontal extension';
%Plot a first visualization.
[R_x_interp, R_VICON_trajectory_sagittal, R_VR_trajectory_sagittal, R_VICON_trajectory_transverse, R_VR_trajectory_transverse, R_VICON_trajectory_frontal, R_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_RL, elbow_frontal_RL_vicon, 1, 2);
[L_x_interp, L_VICON_trajectory_sagittal, L_VR_trajectory_sagittal, L_VICON_trajectory_transverse, L_VR_trajectory_transverse, L_VICON_trajectory_frontal, L_VR_trajectory_frontal] = firstPlotViconVSVR(elbow_frontal_LL, elbow_frontal_LL_vicon, 0, 2);
%Apply rotation-traslation algorithm
valToSearch_VR = 1; %min value right side for Quest data
valToSearch_VR2 = 2; %max value right side for Quest data
valToSearch_VR3 = 1; %min value left side for Quest data
valToSearch_VR4 = 2; %max value left side for Quest data
valToSearch_VICON = 1; %min value right side for VICON data
valToSearch_VICON2 = 2; %max value right side for VICON data
valToSearch_VICON3 = 1; %min value left side for VICON data
valToSearch_VICON4 = 2; %max value left side for VICON data
%Apply rotation-traslation algorithm
[R_VR_data, L_VR_data, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch_VICON, valToSearch_VICON2, valToSearch_VICON3, valToSearch_VICON4, R_x_interp, L_x_interp, R_VR_trajectory_sagittal, ...
    R_VR_trajectory_transverse, R_VR_trajectory_frontal, L_VR_trajectory_sagittal, L_VR_trajectory_transverse, ...
    L_VR_trajectory_frontal, R_VICON_trajectory_sagittal, R_VICON_trajectory_transverse, R_VICON_trajectory_frontal, ...
    L_VICON_trajectory_sagittal, L_VICON_trajectory_transverse, L_VICON_trajectory_frontal);
%Plot the transformed signals.
%plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie);
%Calculate correlation plot and save graphs and save tables
[tableCorr] = dataAnalysis_IO(R_VICON_data, R_VR_data, L_VICON_data, L_VR_data, subject, movement, view, strsubject, serie, strserie, bodypart, tableCorr);

%Export tables
writetable(tableCorr, 'tableCorr_raw.csv');



function movement = w_adjustTableVR(movement, initial_point, end_point)
    movement.RightControllerGlobalPositionX = movement.RightControllerGlobalPositionX - movement.HeadsetGlobalPositionX;
    movement.RightControllerGlobalPositionZ = movement.RightControllerGlobalPositionZ - movement.HeadsetGlobalPositionZ;
    movement.RightControllerGlobalPositionX = -(movement.RightControllerGlobalPositionX);
    movement.LeftControllerGlobalPositionX = movement.LeftControllerGlobalPositionX - movement.HeadsetGlobalPositionX;
    movement.LeftControllerGlobalPositionZ = movement.LeftControllerGlobalPositionZ - movement.HeadsetGlobalPositionZ;
    movement.LeftControllerGlobalPositionX = -(movement.LeftControllerGlobalPositionX);
    
    difference = abs(movement.Time - initial_point);
    indexMin = difference == min(difference);
    RtableColToSearch1 = movement(indexMin, :);
    colToSearch1 = find(movement.Time == RtableColToSearch1.Time);
    difference = abs(movement.Time - end_point);
    indexMin = difference == min(difference);
    RtableColToSearch1 = movement(indexMin, :);
    colToSearch2 = find(movement.Time == RtableColToSearch1.Time);
    movement =  movement(colToSearch1:colToSearch2, :);
    movement.Time = movement.Time - movement.Time(1);
end

function movement = e_adjustTableVR(movement, initial_point, end_point)
    movement.RightElbowGlobalPositionX = movement.RightElbowGlobalPositionX - movement.HeadsetGlobalPositionX;
    movement.RightElbowGlobalPositionZ = movement.RightElbowGlobalPositionZ - movement.HeadsetGlobalPositionZ;
    movement.RightElbowGlobalPositionX = -(movement.RightElbowGlobalPositionX);
    movement.LeftElbowGlobalPositionX = movement.LeftElbowGlobalPositionX - movement.HeadsetGlobalPositionX;
    movement.LeftElbowGlobalPositionZ = movement.LeftElbowGlobalPositionZ - movement.HeadsetGlobalPositionZ;
    movement.LeftElbowGlobalPositionX = -(movement.LeftElbowGlobalPositionX);
    
    difference = abs(movement.Time - initial_point);
    indexMin = difference == min(difference);
    RtableColToSearch1 = movement(indexMin, :);
    colToSearch1 = find(movement.Time == RtableColToSearch1.Time);
    difference = abs(movement.Time - end_point);
    indexMin = difference == min(difference);
    RtableColToSearch1 = movement(indexMin, :);
    colToSearch2 = find(movement.Time == RtableColToSearch1.Time);
    movement =  movement(colToSearch1:colToSearch2, :);
    movement.Time = movement.Time - movement.Time(1);
end

function movement = wR_cutTable(filename)
    opts = detectImportOptions(filename, 'NumHeaderLines', 0);
    movement = readtable(filename, opts);
    figure
    TFw = islocalmin(movement.RightControllerGlobalPositionY);
    plot(movement.Time, movement.RightControllerGlobalPositionY, movement.Time(TFw), movement.RightControllerGlobalPositionY(TFw), 'r*');
    title('Wrist');
end

function movement = wL_cutTable(filename)
    opts = detectImportOptions(filename, 'NumHeaderLines', 0);
    movement = readtable(filename, opts);
    figure
    TFw = islocalmin(movement.LeftControllerGlobalPositionY);
    plot(movement.Time, movement.LeftControllerGlobalPositionY, movement.Time(TFw), movement.LeftControllerGlobalPositionY(TFw), 'r*');
    title('Wrist');
end

function movement = eR_cutTable(filename1, filename2)
    opts = detectImportOptions(filename1, 'NumHeaderLines', 0);
    wrist_mov = readtable(filename1, opts);
    opts = detectImportOptions(filename2, 'NumHeaderLines', 0);
    movement = readtable(filename2, opts);
    movement = addvars(movement, wrist_mov.HeadsetGlobalPositionX, wrist_mov.HeadsetGlobalPositionY, wrist_mov.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
    figure
    TFw = islocalmin(movement.RightElbowGlobalPositionY);
    plot(movement.Time, movement.RightElbowGlobalPositionY, movement.Time(TFw), movement.RightElbowGlobalPositionY(TFw), 'r*');
    title('Elbow');
end

function movement = eL_cutTable(filename1, filename2)
    opts = detectImportOptions(filename1, 'NumHeaderLines', 0);
    wrist_mov = readtable(filename1, opts);
    opts = detectImportOptions(filename2, 'NumHeaderLines', 0);
    movement = readtable(filename2, opts);
    movement = addvars(movement, wrist_mov.HeadsetGlobalPositionX, wrist_mov.HeadsetGlobalPositionY, wrist_mov.HeadsetGlobalPositionZ, 'NewVariableNames', {'HeadsetGlobalPositionX', 'HeadsetGlobalPositionY', 'HeadsetGlobalPositionZ'});
    figure
    TFw = islocalmin(movement.LeftElbowGlobalPositionY);
    plot(movement.Time, movement.LeftElbowGlobalPositionY, movement.Time(TFw), movement.LeftElbowGlobalPositionY(TFw), 'r*');
    title('Elbow');
end

function [x_interp, VICON_trajectory_sagittal, VR_trajectory_sagittal, VICON_trajectory_transverse, VR_trajectory_transverse, VICON_trajectory_frontal, VR_trajectory_frontal] = firstPlotViconVSVR(VR_movement, VICON_movement, side, bodypart)
    
    if bodypart == 1
        if side == 1
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
            plotGraph_MaxMin (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Right', 'Sagittal');
            plotGraph_MaxMin (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Right', 'Transverse');
            plotGraph_MaxMin (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Right', 'Frontal');
    
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
            plotGraph_MaxMin (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Left', 'Sagittal');
            plotGraph_MaxMin (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Left', 'Transverse');
            plotGraph_MaxMin (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Left', 'Frontal');
    
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
            plotGraph_MaxMin (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Right', 'Sagittal');
            plotGraph_MaxMin (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Right', 'Transverse');
            plotGraph_MaxMin (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Right', 'Frontal');
    
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
            plotGraph_MaxMin (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, 'Left', 'Sagittal');
            plotGraph_MaxMin (VR_trajectory_transverse, VICON_trajectory_transverse, x_interp, 'Left', 'Transverse');
            plotGraph_MaxMin (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, 'Left', 'Frontal');
    
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

function [tableCorr,x] = tableCorrelationXCorrelation (movement_VICON, movement_VR, subject, serie, body_part, view, movement, plane, tableCorr)
    %Correlation coeficient
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

function plotGraph_MaxMin (VR_trajectoy, VICON_trajectory, x_interp, side, plane)
    
    TF_vicon_max = islocalmax(VICON_trajectory);
    TF_vicon_min = islocalmin(VICON_trajectory);
    TF_vr_max = islocalmax(VR_trajectoy);
    TF_vr_min = islocalmin(VR_trajectoy);
    figure
    plot(x_interp,VICON_trajectory,'r-');
    hold on
    plot(x_interp,VR_trajectoy,'b-');
    plot(x_interp(TF_vicon_max),VICON_trajectory(TF_vicon_max),'b*');
    plot(x_interp(TF_vicon_min),VICON_trajectory(TF_vicon_min),'b*');
    plot(x_interp(TF_vr_max),VR_trajectoy(TF_vr_max),'r*');
    plot(x_interp(TF_vr_min),VR_trajectoy(TF_vr_min),'r*');
    strTitle = [side ' side,' plane ' plane'];
    title(strTitle);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON', 'Virtual Reality');
    hold off

end

function plotGraphSagittal (VR_trajectory_sagittal, VICON_trajectory_sagittal, x_interp, side, strsubject, strserie)
    
    figure
    plot(x_interp, VICON_trajectory_sagittal, 'r-');
    hold on
    plot(x_interp, VR_trajectory_sagittal, 'b-');
    strTitle = ['Subject ' strsubject ', Serie ' strserie ',' side ' side, Sagittal Plane'];
    title(strTitle);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON', 'Virtual Reality');
    hold off

end

function plotGraphFrontal (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, side, strsubject, strserie)
    
    figure
    plot(x_interp, VICON_trajectory_frontal, 'r-');
    hold on
    plot(x_interp, VR_trajectory_frontal, 'b-');
    strTitle = ['Subject ' strsubject ', Serie ' strserie ',' side ' side, Frontal Plane'];
    title(strTitle);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON', 'Virtual Reality');
    hold off

end

function plotGraphTransverse (VR_trajectory_frontal, VICON_trajectory_frontal, x_interp, side, strsubject, strserie)
    
    figure
    plot(x_interp, VICON_trajectory_frontal, 'r-');
    hold on
    plot(x_interp, VR_trajectory_frontal, 'b-');
    strTitle = ['Subject ' strsubject ', Serie ' strserie ',' side ' side, Transverse Plane'];
    title(strTitle);
    xlabel('Time [s]')
    ylabel('Amplitude [m]')
    legend('VICON', 'Virtual Reality');
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

function [R_new_dataset_VR, L_new_dataset_VR, R_VICON_data, L_VICON_data] = applyRotTrans(valToSearch_VR, valToSearch_VR2, valToSearch_VR3, valToSearch_VR4, ...
    valToSearch, valToSearch2, valToSearch3, valToSearch4, R_x_interp, ...
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
    
    
    %USING ONLY WRISTPOINTS
    A_VR = [R_3DP_VR_S, L_3DP_VR_S, R_3DP_VR_S2, L_3DP_VR_S2, R_3DP_VR_S3, L_3DP_VR_S3, R_3DP_VR_S4, L_3DP_VR_S4;
        R_3DP_VR_T, L_3DP_VR_T, R_3DP_VR_T2, L_3DP_VR_T2, R_3DP_VR_T3, L_3DP_VR_T3, R_3DP_VR_T4, L_3DP_VR_T4;
        R_3DP_VR_F, L_3DP_VR_F, R_3DP_VR_F2, L_3DP_VR_F2, R_3DP_VR_F3, L_3DP_VR_F3, R_3DP_VR_F4, L_3DP_VR_F4];
    B_VICON = [R_3DP_VICON_S, L_3DP_VICON_S, R_3DP_VICON_S2, L_3DP_VICON_S2, R_3DP_VICON_S3, L_3DP_VICON_S3, R_3DP_VICON_S4, L_3DP_VICON_S4;
        R_3DP_VICON_T, L_3DP_VICON_T, R_3DP_VICON_T2, L_3DP_VICON_T2, R_3DP_VICON_T3, L_3DP_VICON_T3, R_3DP_VICON_T4, L_3DP_VICON_T4;
        R_3DP_VICON_F, L_3DP_VICON_F, R_3DP_VICON_F2, L_3DP_VICON_F2, R_3DP_VICON_F3, L_3DP_VICON_F3, R_3DP_VICON_F4, L_3DP_VICON_F4];

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

function plotRotTrans(R_VR_data, R_VICON_data, L_VR_data, L_VICON_data, strsubject, strserie)

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
    plotGraphSagittal (R_VR_trajectory_sagittal, R_VICON_trajectory_sagittal, R_x_interp, 'Right', strsubject, strserie);
    plotGraphTransverse (R_VR_trajectory_transverse, R_VICON_trajectory_transverse, R_x_interp, 'Right side', strsubject, strserie);
    plotGraphFrontal (R_VR_trajectory_frontal, R_VICON_trajectory_frontal, R_x_interp, 'Right side', strsubject, strserie);
    
    %LEFT
    plotGraphSagittal (L_VR_trajectory_sagittal, L_VICON_trajectory_sagittal, L_x_interp, 'Left side', strsubject, strserie);
    plotGraphTransverse (L_VR_trajectory_transverse, L_VICON_trajectory_transverse, L_x_interp, 'Left side', strsubject, strserie);
    plotGraphFrontal (L_VR_trajectory_frontal, L_VICON_trajectory_frontal, L_x_interp, 'Left side', strsubject, strserie);

end

function [tableCorr, tableXCorr] = analysisMovement(serie_VICON, serie_VR, movement, view, mov, subject, strsubject, serie, strserie, bodypart, tableCorr)
    
    if strcmp(view, 'RF') || strcmp(view, 'RR') || strcmp(view, 'RL')
        arm = 'Right';
        [Time, VR_sagittal, VR_transverse, VR_frontal, Frame, VICON__sagittal, VICON_transverse, VICON_frontal] = assignVars(serie_VR.Time, serie_VR.RightControllerGlobalPositionX, serie_VR.RightControllerGlobalPositionY, serie_VR.RightControllerGlobalPositionZ, serie_VICON.Frames, serie_VICON.RWJCY, serie_VICON.RWJCZ, serie_VICON.RWJCX);
    else
        arm = 'Left';
        [Time, VR_sagittal, VR_transverse, VR_frontal, Frame, VICON__sagittal, VICON_transverse, VICON_frontal] = assignVars(serie_VR.Time, serie_VR.LeftControllerGlobalPositionX, serie_VR.LeftControllerGlobalPositionY, serie_VR.LeftControllerGlobalPositionZ, serie_VICON.Frames, serie_VICON.LWJCY, serie_VICON.LWJCZ, serie_VICON.LWJCX);
    end

    if strcmp(view, 'RF') || strcmp(view, 'LF')
        head = 'Frontal';
    elseif strcmp(view, 'RR') || strcmp(view, 'LR')
        head = 'Right';
    else
        head = 'Left';
    end

    %RESAMPLE + PLOT
    newTam = max(length(Time), length(Frame));
    if length(Time) > length(Frame)
        xTam = Time;
    else
        xTam = Frame;
    end
    VR_sagittal = resample(VR_sagittal, newTam, numel(VR_sagittal));
    VICON__sagittal = resample(VICON__sagittal, newTam, numel(VICON__sagittal));
    side = [' ', movement, ', ', head ', ', arm];
    plotGraphSagittal (VR_sagittal, VICON__sagittal, xTam, side, strsubject, strserie);
    name_graph = ['s', strsubject, '_s', strserie, '_', view, '_', bodypart, '_', mov, '_sagittal.fig'];
    savefig(name_graph);

    newTam = max(length(VR_transverse), length(VICON_transverse));
    VR_transverse = resample(VR_transverse, newTam, numel(VR_transverse));
    VICON_transverse = resample(VICON_transverse, newTam, numel(VICON_transverse));
    side = [' ', movement, ', ', head ', ', arm];
    plotGraphTransverse (VR_transverse, VICON_transverse, xTam, side, strsubject, strserie);
    name_graph = ['s', strsubject, '_s', strserie, '_', view, '_', bodypart, '_', mov, '_transverse.fig'];
    savefig(name_graph);

    newTam = max(length(VR_frontal), length(VICON_transverse));
    VR_frontal = resample(VR_frontal, newTam, numel(VR_frontal));
    VICON_frontal = resample(VICON_frontal, newTam, numel(VICON_frontal));
    side = [' ', movement, ', ', head ', ', arm];
    plotGraphFrontal (VR_frontal, VICON_frontal, xTam, side, strsubject, strserie);
    name_graph = ['s', strsubject, '_s', strserie, '_', view, '_', bodypart, '_', mov, '_frontal.fig'];
    savefig(name_graph);
    
    %CORRELATION AND CROSS-CORRELATION
    %RIGHT
    [tableCorr, x] = tableCorrelationXCorrelation (VICON__sagittal, VR_sagittal, subject, serie, bodypart, view, movement, 'Sagittal', tableCorr);
    tableXCorr= table(x, 'VariableNames', {'Sagittal'});
    
    [tableCorr, x] = tableCorrelationXCorrelation (VICON_transverse, VR_transverse, subject, serie, bodypart, view, movement, 'Transverse', tableCorr);
    tableXCorr = addvars(tableXCorr, x, 'NewVariableNames', {'Transverse'});
    
    [tableCorr, x] = tableCorrelationXCorrelation (VICON_frontal, VR_frontal, subject, serie, bodypart, view, movement, 'Frontal', tableCorr);
    tableXCorr = addvars(tableXCorr, x, 'NewVariableNames', {'Frontal'});
    
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
        R_data = table(VICON__sagittal, VR_sagittal, VICON_transverse, ...
            VR_transverse, VICON_frontal, VR_frontal, xTam, 'VariableNames', ...
            {'RWJCX', 'RightControllerPositionZ', 'RWJCZ', 'RightControllerPositionY','RWJCY', 'RightControllerPositionX', 'Frames'});
        name_file = ['s', strsubject, '_s', strserie, '_', view, '_', bodypart, '_', mov, '.csv'];
        writetable(R_data,name_file);
    else
        L_data = table(VICON__sagittal, VR_sagittal, VICON_transverse, ...
            VR_transverse, VICON_frontal, VR_frontal, xTam, 'VariableNames', ...
            {'LWJCX', 'LeftControllerPositionZ', 'LWJCZ', 'LeftControllerPositionY','LWJCY', 'LeftControllerPositionX', 'Frames'});
        name_file = ['s', strsubject, '_s', strserie, '_', view, '_', bodypart, '_', mov, '.csv'];
        writetable(L_data,name_file);
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
        
            name_file = ['s', strsubject, '_s', strserie, '_RF_', bodypart, '_EE_correlation_table.csv'];
            writetable(RF_tableXCorr_EE,name_file);
            name_file = ['s', strsubject, '_s', strserie, '_LF_', bodypart, '_EE_correlation_table.csv'];
            writetable(LF_tableXCorr_EE,name_file);
            
        elseif strcmp(view, 'R')
            viewR = 'RR';
            viewL = 'LR';
            [tableCorr, RR_tableXCorr_EE] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LR_tableXCorr_EE] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', strsubject, '_s', strserie, '_RR_', bodypart, '_EE_correlation_table.csv'];
            writetable(RR_tableXCorr_EE,name_file);
            name_file = ['s', strsubject, '_s', strserie, '_LR_', bodypart, '_EE_correlation_table.csv'];
            writetable(LR_tableXCorr_EE,name_file);

        elseif strcmp(view, 'L')
            viewR = 'RL';
            viewL = 'LL';
            [tableCorr, RL_tableXCorr_EE] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LL_tableXCorr_EE] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', strsubject, '_s', strserie, '_RL_', bodypart, '_EE_correlation_table.csv'];
            writetable(RL_tableXCorr_EE,name_file);
            name_file = ['s', strsubject, '_s', strserie, '_LL_', bodypart, '_EE_correlation_table.csv'];
            writetable(LL_tableXCorr_EE,name_file);

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

            name_file = ['s', strsubject, '_s', strserie, '_RF_', bodypart, '_F_correlation_table.csv'];
            writetable(RF_tableXCorr_F,name_file);
            name_file = ['s', strsubject, '_s', strserie, '_LF_', bodypart, '_F_correlation_table.csv'];
            writetable(LF_tableXCorr_F,name_file);

        elseif strcmp(view, 'R')
            viewR = 'RR';
            viewL = 'LR';
            [tableCorr, RR_tableXCorr_F] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LR_tableXCorr_F] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', strsubject, '_s', strserie, '_RR_', bodypart, '_F_correlation_table.csv'];
            writetable(RR_tableXCorr_F,name_file);
            name_file = ['s', strsubject, '_s', strserie, '_LR_', bodypart, '_F_correlation_table.csv'];
            writetable(LR_tableXCorr_F,name_file);

        elseif strcmp(view, 'L')
            viewR = 'RL';
            viewL = 'LL';
            [tableCorr, RL_tableXCorr_F] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
            [tableCorr, LL_tableXCorr_F] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
        
            name_file = ['s', strsubject, '_s', nstrserie, '_RL_', bodypart, '_F_correlation_table.csv'];
            writetable(RL_tableXCorr_F,name_file);
            name_file = ['s', strsubject, '_s', strserie, '_LL_', bodypart, '_F_correlation_table.csv'];
            writetable(LL_tableXCorr_F,name_file);

        else
            error('The view must be frontal (F), right (R), or left (L)');
        end
    % elseif strcmp(movement, '90 degree movement')
    %     mov = '90D';
    %     if strcmp(view, 'F')
    %         viewR = 'RF';
    %         viewL = 'LF';
    %         [tableCorr, RF_tableXCorr_90D] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
    %         [tableCorr, LF_tableXCorr_90D] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
    % 
    %         name_file = ['s', strsubject, '_s', strserie, '_RF_', bodypart, '_90D_correlation_table.csv'];
    %         writetable(RF_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
    %         name_file = ['s', strsubject, '_s', strserie, '_LF_', bodypart, '_90D_correlation_table.csv'];
    %         writetable(LF_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
    % 
    %     elseif strcmp(view, 'R')
    %         viewR = 'RR';
    %         viewL = 'LR';
    %         [tableCorr, RR_tableXCorr_90D] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
    %         [tableCorr, LR_tableXCorr_90D] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
    % 
    %         name_file = ['s', strsubject, '_s', strserie, '_RR_', bodypart, '_90D_correlation_table.csv'];
    %         writetable(RR_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
    %         name_file = ['s', strsubject, '_s', strserie, '_LR_', bodypart, '_90D_correlation_table.csv'];
    %         writetable(LR_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
    % 
    %     elseif strcmp(view, 'L')
    %         viewR = 'RL';
    %         viewL = 'LL';
    %         [tableCorr, RL_tableXCorr_90D] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
    %         [tableCorr, LL_tableXCorr_90D] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
    % 
    %         name_file = ['s', strsubject, '_s', strserie, '_RL_', bodypart, '_90D_correlation_table.csv'];
    %         writetable(RL_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
    %         name_file = ['s', strsubject, '_s', strserie, '_LL_', bodypart, '_90D_correlation_table.csv'];
    %         writetable(LL_tableXCorr_90D, name_file, 'Sheet', 'Sheet1');
    % 
    %     else
    %         error('The view must be frontal (F), right (R), or left (L)');
    %     end

     % elseif strcmp(movement, 'Lateral extension')
     %    mov = 'L';
     %    if strcmp(view, 'F')
     %        viewR = 'RF';
     %        viewL = 'LF';
     %        [tableCorr, RF_tableXCorr_L] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
     %        [tableCorr, LF_tableXCorr_L] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
     % 
     %        name_file = ['s', strsubject, '_s', strserie, '_RF_', bodypart, '_L_correlation_table.csv'];
     %        writetable(RF_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
     %        name_file = ['s', strsubject, '_s', strserie, '_LF_', bodypart, '_L_correlation_table.csv'];
     %        writetable(LF_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
     % 
     %    elseif strcmp(view, 'R')
     %        viewR = 'RR';
     %        viewL = 'LR';
     %        [tableCorr, RR_tableXCorr_L] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
     %        [tableCorr, LR_tableXCorr_L] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
     % 
     %        name_file = ['s', strsubject, '_s', strserie, '_RR_', bodypart, '_L_correlation_table.csv'];
     %        writetable(RR_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
     %        name_file = ['s', strsubject, '_s', strserie, '_LR_', bodypart, '_L_correlation_table.csv'];
     %        writetable(LR_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
     % 
     %    elseif strcmp(view, 'L')
     %        viewR = 'RL';
     %        viewL = 'LL';
     %        [tableCorr, RL_tableXCorr_L] = analysisMovement(serie_R_VICON, serie_R_VR, movement, viewR, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
     %        [tableCorr, LL_tableXCorr_L] = analysisMovement(serie_L_VICON, serie_L_VR, movement, viewL, mov, subject, strsubject, serie, strserie, bodypart, tableCorr);
     % 
     %        name_file = ['s', strsubject, '_s', strserie, '_RL_', bodypart, '_L_correlation_table.csv'];
     %        writetable(RL_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
     %        name_file = ['s', strsubject, '_s', strserie, '_LL_', bodypart, '_L_correlation_table.csv'];
     %        writetable(LL_tableXCorr_L, name_file, 'Sheet', 'Sheet1');
     % 
     %    else
     %        error('The view must be frontal (F), right (R), or left (L)');
     %    end
    else
        error('The movement must be Elbow extension/90 degree movement/Frontal extension/Lateral extension');
    end
end