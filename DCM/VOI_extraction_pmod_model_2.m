clc
clear all

data_directory = 'D:\connectome\tfMRI_social';

[files,subject_dirs] = spm_select('ExtFPList',data_directory,'dummy.xxx');

q = 0;

region.name = []
region.coordinate = []

% region.name{end+1} = 'RV1';
% region.coordinate{end+1} = [14 -92 -2];
% Maximum 08	 T = 30.57	 X / Y / Z =  	  14	 -96	   3 		MNI: 	  14	 -92	  -2		Right Calcarine Gyrus	 -> Assigned to 	 right	 Area 17
% 	Probability for  	 Area 17        	 90	 %           [	 70	 100	 %]
% 	Probability for  	 Area 18        	 40	 %           [	 10	 40	 %]
% 	Probability for  	 hOC3v (V3v)    	 10	 %           [	  0	 10	 %]

% region.name{end+1} = 'RV3';
% region.coordinate{end+1} = [32 -90 -4];

% Maximum 01	 T = 9.44	 X / Y / Z =  	  32	 -94	   1 		MNI: 	  32	 -90	  -4		Right Inferior Occipital Gyrus	 -> Assigned to 	 right	 hOC3v (V3v)
% 	Probability for  	 hOC3v (V3v)    	 50	 %           [	 20	 60	 %]
% 	Probability for  	 Area 18        	 10	 %           [	  0	 30	 %]
% 	Probability for  	 hOC4v (V4)     	 10	 %           [	  0	 30	 %]


region.name{end+1} = 'RV5';
region.coordinate{end+1} = [44 -64 4];

% Maximum 04	 T = 31.78	 X / Y / Z =  	  44	 -68	   9 		MNI: 	  44	 -64	   4		Right Middle Temporal Gyrus	 -> Assigned to 	 right	 hOC5 (V5) 	 
% 	Probability for  	 hOC5 (V5)      	 40	 %           [	 30	 50	 %] 

region.name{end+1} = 'LV5';
region.coordinate{end+1} = [-44 -74 4];
% 
% Maximum 05	 T = 31.34	 X / Y / Z =  	 -44	 -78	   9 		MNI: 	 -44	 -74	   4		Left Middle Occipital Gyrus	 -> Assigned to 	 left	 hOC5 (V5) 	 
% 	Probability for  	 hOC5 (V5)      	 50	 %           [	 40	 50	 %] 
% 
% Maximum 06	 T = 30.62	 X / Y / Z =  	 -46	 -76	   7 		MNI: 	 -46	 -72	   2		Left Middle Occipital Gyrus	 -> Assigned to 	 left	 hOC5 (V5) 	 
% 	Probability for  	 hOC5 (V5)      	 40	 %           [	 20	 50	 %] 


% region.name{end+1} = 'rpSTS';
% region.coordinate{end+1} = [54 -50 16];

% Maximum 07	 T = 8.72	 X / Y / Z =  	  54	 -54	  21 		MNI: 	  54	 -50	  16		Right Middle Temporal Gyrus
% 	Probability for  	 IPC (PGa)      	 30	 %           [	  0	 40	 %]
% 	Probability for  	 IPC (PFm)      	 20	 %           [	  0	 30	 %]

region.name{end+1} = 'lpSTS';
region.coordinate{end+1} = [-56 -52 10];

% T value: 8.32


% region.name{end+1} = 'RAMY';
% region.coordinate{end+1} = [24 0 -16];
%
% % Maximum 01	 T = 8.93	 X / Y / Z =  	  24	  -4	 -11 		MNI: 	  24	   0	 -16		Right Amygdala	 -> Assigned to 	 right	 Amyg (SF)
% % 	Probability for  	 Amyg (SF)      	 60	 %           [	 40	 80	 %]
% % 	Probability for  	 Amyg (LB)      	 30	 %           [	  0	 40	 %]

% region.name{end+1} = 'R45';
% region.coordinate{end+1} = [48 28 -2];
% Maximum 01	 T = 9.92	 X / Y / Z =  	  48	  24	   3 		MNI: 	  48	  28	  -2		Right Inferior Frontal Gyrus (p. Triangularis)
% 	Probability for  	 Area 45        	 30	 %           [	 20	 50	 %]






for subject = 1:length(subject_dirs)
    for  region_no = 1:length(region.name)
        for session = 1:2
            
            matlabbatch{1,1}.spm.util.voi.spmmat{1,1} = spm_select('FPListRec',sprintf('%s\\social_results\\smoothed_pmod', subject_dirs(subject,:)),'^SPM.mat$')
            
            matlabbatch{1}.spm.util.voi.adjust = (9+session);
            matlabbatch{1}.spm.util.voi.session = session;
            matlabbatch{1}.spm.util.voi.name = region.name{region_no};
            matlabbatch{1}.spm.util.voi.roi{1}.spm.spmmat = {''};
            
            
            if region_no < 3
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