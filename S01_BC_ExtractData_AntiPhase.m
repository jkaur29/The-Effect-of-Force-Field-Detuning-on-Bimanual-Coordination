clear all; close all;


% Get files from your directory
data_home = '/Users/jaskaur/Desktop/UC Merced - Grad School Stuff/2nd Year KINARM Project/KINARM Participant Data'; %uigetdir
% %myFiles = dir(fullfile(data_home, '*FS200.csv')) 
addpath(genpath(data_home));
cd(data_home);

%% Load data with Kinarm script (NEVER USE THIS UNLESS YOU'RE USING THE LAB KINARM COMPUTER. IT WON'T WORK UNLESS IT'S ON THAT COMPUTER!)
%Comment out if you already have the trials .mat file
% data = zip_load('BC002_2021-12-22_12-23-19');                                       %Loads the named file into a new structure called 'data'.
% data = KINARM_add_hand_kinematics(data);                        % Add hand vel, acceleration and commanded forces to the data structure
% data_filt = filter_double_pass(data, 'enhanced', 'fc', 10);		% Double-pass filter the data at 3db cutoff frequency of 10 Hz.  Use an enhanced method for reducing transients at ends.
% data_filt = sort_trials(data, 'tp');                            % % sort all of the trials into Trial Protocol order. i.e. all TP 1, then TP 2...    
% trials = data.c3d;

load('BC_037_AP.mat'); %CHANGE HERE (with mat file you're interested in)
trials = BC_037_AP; %CHANGE HERE (with mat file you're interested in)
%% Create a folder to store data 
%Make folder for results
cd(data_home);
datS01 = 'S01_BC_Data/AntiPhase'; %CHANGE HERE (AntiPhase or InPhase)
mkdir(datS01);
addpath(genpath(datS01));

%Open summary file for output
dat_summ_path = [data_home '/' datS01];
dat_summ = [dat_summ_path '/BC_data/AntiPhase]'];  %CHANGE HERE (AntiPhase or InPhase)

%% Iterating through data to save columns we need into a csv

trial_protocol = []; %There are 16 Trial Protocols (TPs)
                     %that specify combinations of oscillations(ms) 
                     %and loads (1-none; 2-viscous; 3-elastic)




x_RH = []; 
y_RH = [];
vel_x_RH = []; %velocity
vel_y_RH = [];
acc_x_RH = [];
acc_y_RH = [];

x_LH = [];
y_LH = [];
vel_x_LH = [];
vel_y_LH = [];
acc_x_LH = [];
acc_y_LH = [];



for k = 1:length(trials) %There are 80 trials total
    TP = trials(k).TRIAL.TP ; %pointing to Trial Protocol
                              %There are a total of 16 different protocols
                              %for subjects 1 thru 9 
                              %There are a total of 18 different protocols
                              %for subjects 10 thru the end
    trial_protocol = repmat(TP, length(trials(k).Right_HandX), 1); %repeats TP for the number of frames in the trial
    %events = trials(k).EVENTS.LABELS; 
    %times = trials(k).EVENTS.TIMES;
    
    
    x_RH = trials(k).Right_HandX; 
    x_LH = trials(k).Left_HandX;
      
    y_RH = trials(k).Right_HandY; 
    y_LH = trials(k).Left_HandY; 
    
    vel_x_RH = trials(k).Right_HandXVel;
    vel_x_LH =trials(k).Left_HandXVel; 
    
    vel_y_RH = trials(k).Right_HandYVel; 
    vel_y_LH =trials(k).Left_HandYVel;

    acc_x_RH = trials(k).Right_HandXAcc;
    acc_x_LH = trials(k).Right_HandXAcc;
    
    acc_y_RH = trials(k).Right_HandYAcc;
    acc_y_LH = trials(k).Right_HandXAcc;

    time_step = [1:length(x_RH)]';
    time_step = time_step./1000;
    
    phase_diff = y_RH - y_LH; %If this num is positive, right hand is leading
                              %If this num is negative, left hand is
                              %leading
                              %Tale the mean of these values to determine
                              %which hand is leading overall
  
    
    
    %CHANGE HERE (AP or IP, and subj number (e.g. 002) inside the file name below)
    filename = strcat('S01_BC_Data/AntiPhase/Data_AP_037_Trial_',  int2str(k), '_TP_', num2str(TP, '%.f'), '.csv'); %saving the table as a csv with the filename you specify
    T = table(trial_protocol, x_RH, x_LH, y_RH, y_LH, vel_x_RH, vel_x_LH, vel_y_RH, vel_y_LH, acc_x_RH,acc_x_LH, acc_y_RH, acc_y_LH,  phase_diff, time_step);     %creating a table with all the variables we have indexed
    T.Properties.VariableNames = {'trial_protocol','x_RH', 'x_LH', 'y_RH', 'y_LH', 'vel_x_RH', 'vel_x_LH', 'vel_y_RH', 'vel_y_LH', 'acc_x_RH','acc_x_LH', 'acc_y_RH', 'acc_y_LH','phase_diff', 'time_step'}; %adding variable names to the columns
    writetable(T,filename);%, 'Delimiter', ','); % creating the table
    
    events = trials(k).EVENTS.LABELS;
    event_times = (trials(k).EVENTS.TIMES);
   % for x = 1:length(events)
    %    t = event_times(x);
     %   idx = T.time_step==t;
    %end
   
end

%%

