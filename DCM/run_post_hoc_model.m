clc
clear all

data_directory = 'D:\connectome\tfMRI_social';


[files,subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_6_sess1.mat$');
% [files2,subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_1_sess2.mat$');

fun = @(A,B,C) any(spm_vec(C(1,1))) + 1;
% dbstop in spm_dcm_post_hoc
spm_dcm_post_hoc(files([1:53 55:(end)],:), [fun])

%  spm_dcm_post_hoc(files([3:4],:), [fun])

system('rename DCM_BPA.mat DCM_BPA_6_sess1_fun.mat');

% Model 2 sess 1 - Model evidence 1
% Model 2 sess 2 - Model evidence 1
% Model 3 sess 1 - Model evidence 1
% Model 3 sess 2 - Model evidence 1

% Family comparison results:
% fun = @(A,B,C) any(spm_vec(B(1,2,2))) + 1 
% always 0 - NaN

% fun = @(A,B,C) any(spm_vec(B(2,1,2))) + 1;
% always 1

% fun = @(A,B,C) any(spm_vec(B(1,1,2))) + 1;
% always 1

% fun = @(A,B,C) any(spm_vec(B(2,2,2))) + 1;