clc
clear all

data_directory = 'D:\connectome\tfMRI_social';

[files{1},subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_opt_7_sess1.mat$');
[files{2},subject_dirs] = spm_select('FPListRec',data_directory,'^DCM_opt_7_sess2.mat$');

model = 7

[files{3},subject_dirs] = spm_select('FPListRec',data_directory,'^Stats.txt$');

files{3} = sortrows(files{3},-69)

files{4} = files{3}((length(files{3})/2+1):end,:)
files{3} = files{3}(1:(length(files{3})/2),:)

files{3} = files{3}([1:length(files{3})], :)
files{4} = files{4}([1:length(files{4})], :)

region.name = []

load(files{1}(1,:))

region.name{end+1} = DCM.xY(1,1).name;

region.name{end+1} = DCM.xY(1,2).name;

contrast = 'Ment_v_Rnd'
areas = {sprintf('%s_mod_%sto%s', contrast,region.name{2}, region.name{1}),...
    sprintf('%s_mod_%sto%s', contrast, region.name{1}, region.name{2}),...
    sprintf('%s_mod_%sto%s', contrast, region.name{1}, region.name{1}),...
    sprintf('%s_mod_%sto%s', contrast, region.name{2}, region.name{2}),...
    sprintf('%s_C', region.name{1}),...
    sprintf('%s_C', region.name{2}),...
    'Mean RT Mental',...
    'Mean RT Random',...
    'ACC Mental',...
    'ACC Random',...
    'Percent Mental',...
    'Percent Random',...
    'Percent Unsure',...
    'Percent No Response',...
    'log(RT) div Acc Mental',...
    'log(RT) div Acc Random',...
    'log(RT) Mental',...
    'log(RT) Random',...
    'Con1FwdBwd',...
    'Con2FwdBwd'...
    }

for session = 1:2
        
    for i = 1:length(files{session}(:,1))
        
        load(files{session}(i,:))
        [Acc, RTs] = importfile_RT(files{session+2}(i,:))
        Acc([1:2 8]) = []
        Acc(6) = str2num(RTs{8})
        
        RTs = [str2num(RTs{1}); str2num(RTs{2})]
        

        
    end
    
    
   
        
    PpA_B = (PpA+PpB)
    xls_filename = (sprintf('D:\\connectome\\Q2_results\\PpA_B_model_%0.1d_%s_session%d',model, contrast, session))
    save(xls_filename, 'PpA_B')
    
    xlswrite(xls_filename,PpA_B)
    
    xlswrite(xls_filename, areas, 'A1:AA30')
    
end