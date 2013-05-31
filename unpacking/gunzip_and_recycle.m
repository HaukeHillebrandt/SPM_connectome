function [ output_args ] = gunzip_and_recycle( gz_files )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

for i = 1:length(gz_files(:,1));
    gunzip(gz_files(i,:))
    recycle(gz_files(i,:))
    sprintf('%d gunzip done', i)
end

end