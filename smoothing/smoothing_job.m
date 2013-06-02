%-----------------------------------------------------------------------
% Job saved on 10-Mar-2013 22:36:37 by cfg_util (rev $Rev: 4972 $)
% spm SPM - SPM12b (beta)
% cfg_basicio BasicIO - Unknown
% SMOOTHING ALL FILES
%-----------------------------------------------------------------------
clear all

data_directory = 'D:\connectome\tfMRI_social'

[files,subject_dirs] = spm_select('ExtFPList',data_directory,'dummy.xxx')


for subject = 1:length(subject_dirs)

 for scan = 1:2
     
     switch scan
     
         case 1
            scan_direction = 'LR'
            
         case 2
            scan_direction = 'RL'
     end
     
     [scan_frames,dirs] = spm_select('ExtFPListRec',subject_dirs(subject,:),sprintf('^tfMRI_SOCIAL_%s.nii$',scan_direction),inf)
     
for i = 1:length(scan_frames)
        
    matlabbatch{1}.spm.spatial.smooth.data{i,:} = strtrim(scan_frames(i,:));
    
end
    
    matlabbatch{1}.spm.spatial.smooth.fwhm = [4 4 4];
    matlabbatch{1}.spm.spatial.smooth.dtype = 0;
    matlabbatch{1}.spm.spatial.smooth.im = 0;
    matlabbatch{1}.spm.spatial.smooth.prefix = 's';

    spm('defaults', 'FMRI');
    spm_jobman('initcfg');
    spm_jobman('run',matlabbatch);
 end
end