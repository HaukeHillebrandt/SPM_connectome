clc
clear all

data_directory = 'D:\connectome\tfMRI_social';

[files,subject_dirs] = spm_select('ExtFPList',data_directory,'dummy.xxx');

q = 0;

region.name = []
region.coordinate = []

region.name{end+1} = 'RV1';
region.coordinate{end+1} = [16 -92 -2];

region.name{end+1} = 'RV3';
region.coordinate{end+1} = [32 -90 -2];

region.name{end+1} = 'rpSTS';
region.coordinate{end+1} = [60 -42 26];

% region.name{end+1} = 'RAMY';
% region.coordinate{end+1} = [24 0 -16];

region.name{end+1} = 'R45';
region.coordinate{end+1} = [48 28 -2];


for region_no = 1:length(region.name)
    
     
    for subject = 1:68
        
        for session = 1:2
            
            matlabbatch{1,1}.spm.util.voi.spmmat{1,1} = spm_select('FPListRec',sprintf('%s\\social_results\\smoothed_pmod', subject_dirs(subject,:)),'^SPM.mat$')
            
            matlabbatch{1}.spm.util.voi.adjust = (9+session);
            matlabbatch{1}.spm.util.voi.session = session;
            matlabbatch{1}.spm.util.voi.name = region.name{region_no};
            matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
            
            
            if region_no < 2 
                matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = (session) 
            else
                matlabbatch{1}.spm.util.voi.roi{1}.spm.contrast = [(session) (3+session)]
            end
                        
            matlabbatch{1}.spm.util.voi.roi{1}.spm.conjunction = 1;
            matlabbatch{1}.spm.util.voi.roi{1}.spm.threshdesc = 'none';
            matlabbatch{1}.spm.util.voi.roi{1}.spm.thresh = 0.05;
            matlabbatch{1}.spm.util.voi.roi{1}.spm.extent = 0;
            matlabbatch{1}.spm.util.voi.roi{1}.spm.mask = struct('contrast', {}, 'thresh', {}, 'mtype', {});
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.centre = region.coordinate{region_no};
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.radius = 4;
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.local.spm = 1;
            matlabbatch{1}.spm.util.voi.roi{2}.sphere.move.local.mask = 'i3';
            matlabbatch{1}.spm.util.voi.roi{3}.sphere.centre = region.coordinate{region_no};
            matlabbatch{1}.spm.util.voi.roi{3}.sphere.radius = 20;
            matlabbatch{1}.spm.util.voi.roi{3}.sphere.move.fixed = 1;
            matlabbatch{1}.spm.util.voi.expression = 'i1&i2';
            
            printoutname=sprintf('s%0.2d_%s_session_%0.2d',subject,region.name{region_no},session);
                        
            try
                
                spm('defaults', 'FMRI');
                spm_jobman('initcfg');
                spm_jobman('run',matlabbatch);
                
                saveas(gcf,printoutname, 'png');
                
            catch
                q=q+1;
                failed_vois{q,1}=printoutname;
                mat_failed = 'failed_vois_name.mat'
                failed_vois_name = sprintf('%s\\%s', data_directory, mat_failed)
                save(failed_vois_name, 'failed_vois')
            end
            
        end
        
    end
end
done_mail('everything done!')