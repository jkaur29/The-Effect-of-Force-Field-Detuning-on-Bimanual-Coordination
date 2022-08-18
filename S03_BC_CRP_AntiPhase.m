%Phase_Angle() and CRP() from https://github.com/PhilD001/crp_irregular_surfaces

clear all; close all;


%% Get files from your directory
data_home = '/Users/jaskaur/Desktop/UC Merced - Grad School Stuff/2nd Year KINARM Project/KINARM Participant Data'; %uigetdir
%myFiles = dir(fullfile(data_home, '*FS200.csv')) 
addpath(genpath(data_home));
cd(data_home);

%% Make lists of files
data_loc = [data_home '/S01_BC_Data/AntiPhase'];
cd(data_loc);
dat = dir('*.csv'); %Can change for TP 1 through 16
dirlist_dat = {dat.name};


%% Create a folder to store data 
%Make folder for results
cd(data_home);
datS03 = 'S03_BC_CRP';
mkdir(datS03);
addpath(genpath(datS03));

%Open summary file for output
dat_summ_path = [data_home '/' datS03];
dat_summ = [dat_summ_path '/CRP'];

%%
for dat = 1:length(dirlist_dat);

    dat_filename = char(dirlist_dat(dat));
    Ind1 = find(dat_filename == '.');
    dat_filename = dat_filename(1:Ind1-1);
    
    
    data = csvread(char(dirlist_dat(dat)),(1+12000),3,[(1+12000),3,42000,4]);    %EXAMPLE: csvread(yourfile, 1, 0 [1,0,2,2])
                                                                                 %EXAMPLE: the line above reads the matrix bounded by row offsets 1 and 2 and column offsets 0 and 2
                                                                                 %so in our data, we are reading the matrix bounded by row offsets (1+12500) and 42500, and columns 3 and 4    
    %save Right and Left to .mat file (column 1RH and column 2LH)
    save([datS03 '/' dat_filename '.mat'],'data');  
   
    
    %write Right and Left to two separate files (Maybe delete?)
    %dlmwrite([datS03,'/', dat_filename,' y_RH.csv'],data(:,1),'delimiter','\t','newline','unix','precision',7);
    %dlmwrite([datS03,'/', dat_filename,' y_LH.csv'],data(:,2),'delimiter','\t','newline','unix','precision',7);

    
    %Calculate Phase Angle
    %This code centers around origin (0,0); performs Hilbert transform; and
    %calculates phase angle (converting from radians to degrees in the
    %process)
    y_RH_phase_angle = Phase_Angle(data(:,1));
    y_LH_phase_angle = Phase_Angle(data(:,2));
    
    
    %save phase angles to .mat files
    save([datS03 '/' dat_filename '.mat'],'y_RH_phase_angle');  
    save([datS03 '/' dat_filename '.mat'],'y_LH_phase_angle');  

    
    %write Left and Right Phase Angle to two separate files (Maybe delete?)
    %dlmwrite([datS03,'/', dat_filename,' y_RH_phase_angle.csv'],y_RH_phase_angle(:,:),'delimiter','\t','newline','unix','precision',7);
    %dlmwrite([datS03,'/', dat_filename,' y_LH_phase_angle.csv'],y_LH_phase_angle(:,:),'delimiter','\t','newline','unix','precision',7);

    
    %Calculate continuous relative phase!
    ContRelPhase = CRP(y_RH_phase_angle,y_LH_phase_angle);
    
    %save CRP data to .mat file
    save([datS03 '/' dat_filename '.mat'],'ContRelPhase');  

    
    %write CRP data to .csv file
    dlmwrite([datS03,'/', dat_filename,'_ContRelPhase.csv'],ContRelPhase(:,:),'delimiter','\t','newline','unix','precision',7);

    %The code below is added to make all plots with thicker lines. If that
    %is not needed for each plot use this code: plot(x,y1,x,y2,'LineWidth',2.0)
    set(groot,'defaultLineLineWidth',2.0)
    
    %plot
    tiledlayout(2,1)
    
    %Top plot
    nexttile
    plot((data(:,1)), 'b')
    hold on
    plot((data(:,2)), 'm')
    axis([0 30000 0.2 0.5])
    title('Right and Left Hand Y Position')
    xlabel('Time (ms)')
    ylabel('Y Position (m)')
    legend('Right Hand', 'Left Hand', 'location', 'northeast')
    
%     %Middle plot (Phase Angle Plot):
%     nexttile
%     plot(y_RH_phase_angle, 'b')
%     hold on
%     plot(y_LH_phase_angle, 'm')
%     title('Right and Left Hand Phase Angle (PA)')
%     xlabel('Time')
%     ylabel('PA (degrees)')
%     legend('Right Hand', 'Left Hand', 'location', 'northeast')
% %     
    %bottom plot
    nexttile
    plot(ContRelPhase)
    axis([0 30000 0 200])
    yticks([20 40 60 80 100 120 140 160 180 200])
    title('Continuous Relative Phase (Φ)')
    xlabel('Time (ms)')
    ylabel('Continuous Relative Phase (°)')
    saveas(gcf, [datS03,'/', dat_filename,'_ContRelPhase.png'])
end