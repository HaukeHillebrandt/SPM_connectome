clc
clear all


 contrast = 1

    if contrast < 7
        t_or_f = 'con'
    else
        t_or_f = 'ess'
    end
    
    load('D:\connectome\tfMRI_social\100307\social_results\smoothed_pmod\SPM.mat')
    contrast_name = SPM.xCon(1,contrast).name
    
    contrast_folder = sprintf('D:\\connectome\\anova_pmod\\%d\\', contrast);
    
    mkdir(contrast_folder)
 
matlabbatch{1}.spm.stats.factorial_design.dir = {contrast_folder};

data_directory = 'D:\connectome\tfMRI_social'

[files,subject_dirs] = spm_select('ExtFPList',data_directory,'dummy.xxx')



matlabbatch{1}.spm.stats.factorial_design.dir = {contrast_folder};
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.name = 'Condition';
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.levels = 2;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.dept = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.variance = 1;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.fact.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(1).levels = 1;


for subject = 1:length(subject_dirs)
      
matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(1,1).scans{subject,1} = spm_select('FPListRec',sprintf('%s\\social_results\\smoothed_pmod', subject_dirs(subject,:)),sprintf('^%s_0003\\.img$', t_or_f));

end

matlabbatch{1, 1}.spm.stats.factorial_design.des.fd.icell.scans{2, 1}


matlabbatch{1}.spm.stats.factorial_design.des.fd.icell(2).levels = 2;

for subject = 1:length(subject_dirs)
      
matlabbatch{1,1}.spm.stats.factorial_design.des.fd.icell(1,2).scans{subject,1} = spm_select('FPListRec',sprintf('%s\\social_results\\smoothed_pmod', subject_dirs(subject,:)),sprintf('^%s_0006\\.img$', t_or_f));

end

matlabbatch{1}.spm.stats.factorial_design.des.fd.contrasts = 1;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;




spm('defaults', 'FMRI'); 
spm_jobman('initcfg');
spm_jobman('run',matlabbatch);


done_mail('everything done!')