% UNPACKS ALL IMPORTANT .GZ. AND .TAR FILES (RECURSIVELY) IN DIRECTORY AND SUBDIRECTORIES AND RECYCLES THEM AFTERWARDS 
% gunzip all .tz files found in directory and subdirectory (run in directory)

clear all

[data_directory] = spm_select(1, 'dir' )
    
[gz_files] = spm_select('FPListRec',data_directory,'.*\.gz$');

try 
gunzip_and_recycle(gz_files)

% untar all .tar files found in directory and subdirectories


end

[tar_files, tar_direc] = spm_select('FPListRec',data_directory,'.*\.tar$');

for i = 1:length(tar_files(:,1));
    
    try cd(data_directory)
    end
    
    untar(tar_files(i,:));
    
    recycle(tar_files(i,:))
    
    cd(data_directory)
end

[T1w_gz_files] = spm_select('FPListRec',data_directory,'T1w.nii.gz');

gunzip_and_recycle(T1w_gz_files)

[BOLD_SOCIAL1_RL_gz_files] = spm_select('FPListRec',data_directory,'BOLD_SOCIAL1_RL.nii.gz');

gunzip_and_recycle(BOLD_SOCIAL1_RL_gz_files)

[BOLD_SOCIAL2_LR_gz_files] = spm_select('FPListRec',data_directory,'BOLD_SOCIAL2_LR.nii.gz');

gunzip_and_recycle(BOLD_SOCIAL2_LR_gz_files)

% % REMOVE ALL EMPTY FOLDERS IN MAIN DIRECTORY

cd(data_directory)
current_dir = dir
try
    for i = 1:length(current_dir)

        try
rmdir(current_dir((i+2),1).name)
        end
    end
    
end