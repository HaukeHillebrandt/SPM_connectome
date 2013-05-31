function [ output_args ] = unzip_and_recycle( zip_files )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(zip_files(:,1));
    unzip(zip_files(i,:))
    recycle(zip_files(i,:))
    sprintf('%d unzip done', i)
end

end