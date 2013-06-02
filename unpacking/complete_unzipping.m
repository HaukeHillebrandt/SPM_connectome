% UNPACKS ALL .GZ. AND .TAR FILES (RECURSIVELY) IN DIRECTORY AND SUBDIRECTORIES AND RECYCLES THEM AFTERWARDS 

% gunzip all .tz files found in directory and subdirectory (run in directory)

clear all

[data_directory] = spm_select(1, 'dir' )

gz_files = 1;
tar_files = 1; 

while length(gz_files(:)) > 0 | length(tar_files(:)) > 0;
    
[gz_files] = spm_select('FPListRec',data_directory,'.*\.gz$');
try
for i = 1:length(gz_files(:,1));
    gunzip(gz_files(i,:))
    recycle(gz_files(i,:))
end

% untar all .tar files found in directory and subdirectories
catch
[tar_files, tar_direc] = spm_select('FPListRec',data_directory,'.*\.tar$');

for i = 1:length(tar_files(:,1));
    
    try cd(tar_direc(i,:))
    end
    
    untar(tar_files(i,:));
    
    recycle(tar_files(i,:))
    
    cd(data_directory)
end
end

[gz_files] = spm_select('FPListRec',data_directory,'.*\.gz$');
[tar_files, tar_direc] = spm_select('FPListRec',data_directory,'.*\.tar$');

end