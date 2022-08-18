%Calculating mean and SD of contiunuous relative phase (CRP):

clear all; close all;

%% Get files from your directory
data_home = '/Users/jaskaur/Desktop/UC Merced - Grad School Stuff/2nd Year KINARM Project/KINARM Participant Data'; %uigetdir
addpath(genpath(data_home));
cd(data_home);

%% Make lists of files
data_loc = [data_home '/S03_BC_CRP'];
cd(data_loc);
dat = dir('*ContRelPhase.csv'); %change TP number
dirlist_dat = {dat.name};


%% Create a folder to store data 
%Make folder for results
cd(data_home);
datS04 = 'S04_CRP_mean_SD';
mkdir(datS04);
addpath(genpath(datS04));

%Open summary file for output
dat_summ_path = [data_home '/' datS04];
dat_summ = [dat_summ_path '/MeanSD'];
file_name = [dat_summ sprintf('%d') '.txt'];
fopen(file_name,'a+');


%%
%Make row header names
rowdat = strcat('File,SD, mean');
fid = fopen(file_name,'a+');
fprintf(fid,'\n %s',rowdat);

for dat = 1:length(dirlist_dat)
    
    dat_filename = char(dirlist_dat(dat));
    Ind1 = find(dat_filename == '.');
    dat_filename = dat_filename(1:Ind1-1);
    
    %load(['S01_load\' char(dirlist_dat(dat))],'data_COP_norm')
    data = load(['S03_BC_CRP/' char(dirlist_dat(dat))]);
    %data_fieldname = [char(fieldnames(S))];
    %data2 = S.(data_fieldname);
    
    sd_CRP = std(data);
    mean_CRP = mean(data);
    
    fid = fopen(file_name,'a+');
    fprintf(fid,'\n %s %s %f %s %f %s %f',dat_filename,',',sd_CRP,',',mean_CRP);
    dlmwrite([dat_summ_path '/' dat_filename '_meanCRP'],mean_CRP,'delimiter','\t','newline','unix','precision',7);  
    
end

fclose('all');
cd(data_home);
