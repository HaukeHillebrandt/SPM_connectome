clc
clear all

% specify model name:
model = 'smoothed_pmod'
comma = ','

% specify number of scans (find in PDF) Social: 274
number_of_scans = 274;

% for using spm_select to select data_dir
% [data_directory] = spm_select(1, 'dir' )
data_directory = 'D:\connectome\tfMRI_social'

[files,subject_dirs] = spm_select('List',data_directory,'dummy.xxx')

cd(data_directory);
dir_var = dir;

for s = 1:length(subject_dirs)
    
    % Create subject specific directories
    
    subject_directory = sprintf('%s\\%s', data_directory, subject_dirs((s),:))
    social_directory = sprintf('%s\\social_results\\%s', subject_directory,model)
    mkdir(social_directory)
    
    %     D:\connectome\tfMRI_social\100307\MNINonLinear\Results\tfMRI_SOCIAL_LR\EVs\mental.txt
    
    
    matlabbatch{1}.spm.stats.fmri_spec.dir = {social_directory}
    matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
    matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 0.72;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 16;
    matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 1;
    
    %   load 4D nifti files
    
    for session = 1:2
        
        if session == 1
            scan_direction = 'RL';
            event_directory = sprintf('%s\\MNINonLinear\\Results\\tfMRI_SOCIAL_%s\\', subject_directory, scan_direction)
        elseif session == 2
            scan_direction = 'LR';
            event_directory = sprintf('%s\\MNINonLinear\\Results\\tfMRI_SOCIAL_%s\\', subject_directory, scan_direction)
        end
        
        
        
        
        for scan = 1:number_of_scans
            
            session_scans = sprintf('%s\\MNINonLinear\\Results\\tfMRI_SOCIAL_%s\\stfMRI_SOCIAL_%s.nii%s%d', subject_directory, scan_direction,scan_direction,comma,scan)
            matlabbatch{1,1}.spm.stats.fmri_spec.sess(1,session).scans{scan,1} = session_scans;
            
        end
        
        
        
        [event_file] = spm_select('FPListRec',event_directory,'mental.txt')
        events1 = load(event_file);
        [event_file] = spm_select('FPListRec',event_directory,'rnd.txt');
        events2 = load(event_file);
        events2(:,3)= events2(:,3)*-1
        
        events3 = [events1; events2]
        
        pmod = 1;
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).name = 'All motion';
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).onset = events3(:,1);
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).duration = events3(1,2);
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).tmod = 0;
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).pmod(1).name = 'Mental>Rnd';
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).pmod(1).param = events3(:,3);
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).pmod(1).poly = 1;
        
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(pmod).orth = 1;
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).multi = {''};
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).regress = struct('name', {}, 'val', {});
        
        [movement_file] = spm_select('FPListRec',event_directory,'Movement_Regressors.txt')
        
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).multi_reg = {movement_file};
        matlabbatch{1}.spm.stats.fmri_spec.sess(session).hpf = 128;
        
    end
    
    
    
    matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
    matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
    matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
    matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
    matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
    matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
    
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1) = cfg_dep;
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).sname = 'fMRI model specification: SPM.mat File';
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_exbranch = substruct('.','val', '{}',{1}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{2}.spm.stats.fmri_est.spmmat(1).src_output = substruct('.','spmmat');
    matlabbatch{2}.spm.stats.fmri_est.method.Classical = 1;
    
    
    
    %   running the job
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
end