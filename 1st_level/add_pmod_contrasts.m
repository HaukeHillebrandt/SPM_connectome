clc
clear all

data_directory = 'D:\connectome\tfMRI_social';

[files,subject_dirs] = spm_select('ExtFPList',data_directory,'dummy.xxx');


%% to make everything subject specific

for subject = 1:68
    
    
    
    SPM_filename = spm_select('FPListRec',sprintf('%s\\social_results\\smoothed_pmod', subject_dirs(subject,:)),'^SPM.mat$');
    
    matlabbatch{1}.spm.stats.con.spmmat(1) = {SPM_filename};
    
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'All motion';
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1];
    matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'both';
    
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.name = 'Mental>Rnd';
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.weights = [0 1];
    matlabbatch{1}.spm.stats.con.consess{2}.tcon.sessrep = 'both';
    
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.name = 'Rnd>Mental';
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.weights = [0 -1];
    matlabbatch{1}.spm.stats.con.consess{3}.tcon.sessrep = 'both';
    
    matlabbatch{1}.spm.stats.con.delete = 1;
    
   
    
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
    
end

done_mail('everything done!')