% UNPACKS ALL FUNCTIONAL FILES AND RECYCLES THE .ZIP AND .GZ THEM AFTERWARDS 
% needs SPM12b installed

clear all

data_directory = 'D:\CONNECTOME\tfMRI_social\'

% [data_directory] = spm_select(1, 'dir' )
cd(data_directory)

%% unzips all zip files and recycles them
     
[zip_files] = spm_select('FPListRec',data_directory,'.*3T_tfMRI_SOCIAL_preproc\.zip$');

unzip_and_recycle(zip_files)

%% gunzips all gz t-fmri files and recycles the gz file
[fMRI_SOCIAL_RL_gz_files] = spm_select('FPListRec',data_directory,'tfMRI_SOCIAL_RL.nii.gz');

gunzip_and_recycle(tfMRI_SOCIAL_RL_gz_files)

[tfMRI_SOCIAL_LR_gz_files] = spm_select('FPListRec',data_directory,'tfMRI_SOCIAL_LR.nii.gz');

gunzip_and_recycle(tfMRI_SOCIAL_LR_gz_files)