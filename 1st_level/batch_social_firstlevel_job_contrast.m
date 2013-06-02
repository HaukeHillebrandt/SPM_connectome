%-----------------------------------------------------------------------
% Job configuration created by cfg_util (rev $Rev: 4252 $)
%-----------------------------------------------------------------------
clc
clear all

% specify model name:
model = 'smoothed_non_redundant'
comma = ','

% specify number of scans (find in PDF) Social: 274
number_of_scans = 274;

% for using spm_select to select data_dir
% [data_directory] = spm_select(1, 'dir' )
data_directory = 'D:\connectome\tfMRI_social'

[files,subject_dirs] = spm_select('List',data_directory,'dummy.xxx')

cd(data_directory);
dir_var = dir;

for s = 1
          
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
    
    events3 = sort([events1; events2])
   
    mental = 1;
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(mental).name = 'mental';
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(mental).onset = events1(:,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(mental).duration = events1(1,2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(mental).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(mental).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(mental).orth = 0;
    
    random = 2;
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(random).name = 'random';
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(random).onset = events2(:,1);
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(random).duration = events2(1,2);
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(random).tmod = 0;
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(random).pmod = struct('name', {}, 'param', {}, 'poly', {});
    matlabbatch{1}.spm.stats.fmri_spec.sess(session).cond(random).orth = 0;
    
    
        
    
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
    
    matlabbatch{3}.spm.stats.con.spmmat(1) = cfg_dep;
    matlabbatch{3}.spm.stats.con.spmmat(1).tname = 'Select SPM.mat';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).name = 'filter';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(1).value = 'mat';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).name = 'strtype';
    matlabbatch{3}.spm.stats.con.spmmat(1).tgt_spec{1}(2).value = 'e';
    matlabbatch{3}.spm.stats.con.spmmat(1).sname = 'Model estimation: SPM.mat File';
    matlabbatch{3}.spm.stats.con.spmmat(1).src_exbranch = substruct('.','val', '{}',{2}, '.','val', '{}',{1}, '.','val', '{}',{1});
    matlabbatch{3}.spm.stats.con.spmmat(1).src_output = substruct('.','spmmat');
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.name = 'mental>random';
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.convec = [1 -1 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{1}.tcon.sessrep = 'both';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.name = 'random>mental';
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.convec = [-1 1 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{2}.tcon.sessrep = 'both';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.name = 'T Effects of interest';
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.convec = [1 1 0 0 0 0 0 0 0 0 0 0 0 0];
    matlabbatch{3}.spm.stats.con.consess{3}.tcon.sessrep = 'both'; 
        
    matlabbatch{3}.spm.stats.con.consess{4}.fcon.name = 'F Effects of interest';
    matlabbatch{3}.spm.stats.con.consess{4}.fcon.convec = {
        [1 0
        0 1]
        }';
    matlabbatch{3}.spm.stats.con.consess{4}.fcon.sessrep = 'both';
        
    
    
    matlabbatch{3}.spm.stats.con.delete = 0;
    
    
    
    %   running the job
    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
    
end
%         [tfMRI_files,dirs] = spm_select('ExtFPListRec',analysis_directory,sprintf('^tfMRI_SOCIAL%d....nii$', session),1:number_of_scans)
%
%         for scan = 1:number_of_scans;
%             matlabbatch{1,1}.spm.stats.fmri_spec.sess.scans{scan,1} = tfMRI_files(scan,:)
%         end