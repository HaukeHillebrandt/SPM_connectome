% UNPACKS ALL IMPORTANT .GZ. AND .TAR FILES (RECURSIVELY) IN DIRECTORY AND SUBDIRECTORIES AND RECYCLES THEM AFTERWARDS 
% gunzip all .tz files found in directory and subdirectory (run in directory)
% FOR SPM 12 

clear all

data_directory = 'C:\connectome\'

tfmri_directory = 'D:\connectome\tfMRI_social\'

% [data_directory] = spm_select(1, 'dir' )
     
[zip_files] = spm_select('FPListRec',data_directory,'.*\.zip$');

cd(tfmri_directory)

try 
unzip_and_recycle(zip_files)
% untar all .tar files found in directory and subdirectories
end

% clear i
% 
% [tar_files, tar_direc] = spm_select('FPListRec',data_directory,'.*\.zip$');
% 
% tar_direc = sortrows(tar_direc);
% 
% for i = 1:length(tar_files(:,1));
%     
%     cd(tar_direc(i,:))
%     
%     untar(tar_files(i,:));
%     
%     recycle(tar_files(i,:))
%     
%     cd(data_directory)
%     
%     sprintf('%d untar done', i)
% end


% [T1w_gz_files] = spm_select('FPListRec',data_directory,'T1w.nii.gz');
% 
% gunzip_and_recycle(T1w_gz_files)

[tfMRI_SOCIAL_RL_gz_files] = spm_select('FPListRec',tfmri_directory,'tfMRI_SOCIAL_RL.nii.gz');

gunzip_and_recycle(tfMRI_SOCIAL_RL_gz_files)

[tfMRI_SOCIAL_LR_gz_files] = spm_select('FPListRec',tfmri_directory,'tfMRI_SOCIAL_LR.nii.gz');

gunzip_and_recycle(tfMRI_SOCIAL_LR_gz_files)

% % REMOVE ALL EMPTY FOLDERS IN MAIN DIRECTORY

% cd(data_directory)
% current_dir = dir
% try
%     for i = 1:length(current_dir)
% 
%         try
% rmdir(current_dir((i+2),1).name)
%         end
%     end
%     
% end