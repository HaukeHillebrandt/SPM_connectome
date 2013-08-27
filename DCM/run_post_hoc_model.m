clc
clear all

data_directory = 'D:\connectome\tfMRI_social';


[files,subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_6_sess1.mat$');
% [files2,subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_1_sess2.mat$');

spm_dcm_post_hoc(files([1:53 55:(end)],:))

system('rename DCM_BPA.mat DCM_BPA_6_sess1_fun.mat');