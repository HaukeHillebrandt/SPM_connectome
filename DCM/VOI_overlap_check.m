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



for region_no = 2:length(region.name)
    
    if region_no > 1
        start_contrast = 0;
    else start_contrast = 6;
    end
    
    for subject = 1:68
        
        for session = 1:2
            try
            
            
            VOI1_filename = sprintf('%s\\social_results\\smoothed_pmod\\VOI_%s_%d.mat', subject_dirs(subject,:), region.name{(region_no-1)}, session);
            load(VOI1_filename);
            VOI1=xY;
            
            VOI2_filename = sprintf('%s\\social_results\\smoothed_pmod\\VOI_%s_%d.mat', subject_dirs(subject,:), region.name{region_no}, session);          
            load(VOI2_filename);
            VOI2=xY;
            
            for voxel = 1:length(VOI1.XYZmm)
                
                check = strmatch([VOI1.XYZmm(:,voxel)], VOI2.XYZmm');
                
                if isempty(check)
                else
                    subject
                    session
                    voxel
                    check
                    region_no
                    region.name(region_no)
                end
            end
            end
            
            
            
        end
        
    end
    
end

                    save('overlaping')
