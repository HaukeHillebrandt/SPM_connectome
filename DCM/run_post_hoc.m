clc
clear all

data_directory = 'D:\connectome\tfMRI_social';

[files,subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_1_sess1.mat$');
[files2,subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_1_sess2.mat$');

%% subject 11 missing

combined_sessions = [files([1:36 38:(end)],:); files2([1:36 38:(end)],:)]

spm_dcm_post_hoc(combined_sessions)

% done_mail('everything done!')

