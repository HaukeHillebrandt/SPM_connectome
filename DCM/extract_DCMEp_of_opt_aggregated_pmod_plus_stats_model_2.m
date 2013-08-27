clc
clear all

data_directory = 'D:\connectome\tfMRI_social';

EpA=zeros(133, 76);
EpB=zeros(133, 76);
PpA=zeros(133, 76);
PpB=zeros(133, 76);


areas = {};

for model = 1:2
    
    for session = 1:2
        
        if model == 1
            model_number = 6;
        else
            model_number = 7;
        end
        
        model_filename = sprintf('^DCM_opt_%d_sess%d.mat$', model_number, session);
        
        [files{1},subject_dirs] = spm_select('FPListRec',data_directory,model_filename);
        [files{2},subject_dirs] = spm_select('FPListRec',data_directory,model_filename);
        
        [files{3},subject_dirs] = spm_select('FPListRec',data_directory,'^Stats.txt$');
        
        files{3} = sortrows(files{3},-69);
        
        files{4} = files{3}((length(files{3})/2+1):end,:);
        files{3} = files{3}(1:(length(files{3})/2),:);
        
        files{3} = files{3}([1:length(files{3})], :);
        files{4} = files{4}([1:length(files{4})], :);
        
        region.name = [];
        
        load(files{1}(1,:))
        
        region.name{end+1} = DCM.xY(1,1).name;
        
        region.name{end+1} = DCM.xY(1,2).name;
        
        contrast = 'Ment_rnd';
        
        
        
        for i = 1:length(files{session}(:,1))
            
            load(files{session}(i,:))
            [Acc, RTs] = importfile_RT(files{session+2}(i,:));
            Acc([1:2 8]) = [];
            Acc(6) = str2num(RTs{8});
            
            RTs = [str2num(RTs{1}); str2num(RTs{2})];
            
            Behavior = [RTs; Acc; log(RTs(1))/Acc(1); log(RTs(2))/Acc(2); log(RTs(1)); log(RTs(2))];
            
            DCM.Ep.A = full(DCM.Ep.A);
            
            sess_vars  = 19;
            model_vars = 2*sess_vars;
            
            start_val = ((sess_vars*(session-1)+model_vars*(model-1)));
            
            EpA(i+1,1+start_val) = DCM.Ep.A(1,2,1);
            EpA(i+1,2+start_val) = DCM.Ep.A(2,1,1);
            EpA(i+1,3+start_val) = DCM.Ep.A(1,1,1);
            EpA(i+1,4+start_val) = DCM.Ep.A(2,2,1);
            EpA(i+1,5+start_val) = DCM.Ep.C(1,1);
            EpA(i+1,6+start_val) = DCM.Ep.C(1,2);
            EpA(i+1,7+start_val) = (DCM.Ep.A(1,2,1) - DCM.Ep.A(2,1,1));
            EpA(i+1,8+start_val:start_val+7+length(Behavior)) = Behavior;
            
            
            EpB(i+1,1+start_val) = DCM.Ep.B(1,2,2);
            EpB(i+1,2+start_val) = DCM.Ep.B(2,1,2);
            EpB(i+1,3+start_val) = DCM.Ep.B(1,1,2);
            EpB(i+1,4+start_val) = DCM.Ep.B(2,2,2);
            EpB(i+1,5+start_val) = DCM.Ep.C(1,1);
            EpB(i+1,6+start_val) = DCM.Ep.C(1,2);
            EpB(i+1,7+start_val) = (DCM.Ep.B(1,2,2) - DCM.Ep.B(2,1,2));
            EpB(i+1,8+start_val:start_val+7+length(Behavior)) = Behavior;
            
            DCM.Pp.A = full(DCM.Pp.A);
            PpA(i+1,1+start_val) = DCM.Pp.A(1,2,1);
            PpA(i+1,2+start_val) = DCM.Pp.A(2,1,1);
            PpA(i+1,3+start_val) = DCM.Pp.A(1,1,1);
            PpA(i+1,4+start_val) = DCM.Pp.A(2,2,1);
            PpA(i+1,5+start_val) = DCM.Pp.C(1,1);
            PpA(i+1,6+start_val) = DCM.Pp.C(1,2);
            PpA(i+1,7+start_val) = (DCM.Pp.A(1,2,1) - DCM.Pp.A(2,1,1));
            PpA(i+1,8+start_val:start_val+7+length(Behavior)) = Behavior;
            
            PpB(i+1,1+start_val) = DCM.Pp.B(1,2,2);
            PpB(i+1,2+start_val) = DCM.Pp.B(2,1,2);
            PpB(i+1,3+start_val) = DCM.Pp.B(1,1,2);
            PpB(i+1,4+start_val) = DCM.Pp.B(2,2,2);
            PpB(i+1,5+start_val) = DCM.Pp.C(1,1);
            PpB(i+1,6+start_val) = DCM.Pp.C(1,2);
            PpB(i+1,7+start_val) = (DCM.Pp.B(1,2,2) - DCM.Pp.B(2,1,2));
            PpB(i+1,8+start_val:start_val+7+length(Behavior)) = Behavior;
            
        end
        
        areas((end+1):(end+19)) = {sprintf('m_%d_s_%d_%s_mod_%sto%s',model, session, contrast,region.name{2}, region.name{1}),...
            sprintf('m_%d_s_%d_%s_mod_%sto%s', model, session, contrast, region.name{1}, region.name{2}),...
            sprintf('m_%d_s_%d_%s_mod_%sto%s', model, session, contrast, region.name{1}, region.name{1}),...
            sprintf('m_%d_s_%d_%s_mod_%sto%s', model, session, contrast, region.name{2}, region.name{2}),...
            sprintf('m_%d_s_%d_%s_C', model, session, region.name{1}),...
            sprintf('m_%d_s_%d_%s_C', model, session, region.name{2}),...
            'Con1FwdBwd',...
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
            };
    end
end

xls_filename = (sprintf('D:\\connectome\\Q2_results\\EpA_model_%0.1d_%s_session%d',model, contrast, session));
save(xls_filename, 'EpA')
xlswrite(xls_filename,EpA)
xlswrite(xls_filename, areas, 'A1:GR1')

xls_filename =(sprintf('D:\\connectome\\Q2_results\\EpB_model_%0.1d_%s_session%d',model, contrast, session));
save(xls_filename,'EpB');
xlswrite(xls_filename,EpB)
xlswrite(xls_filename, areas, 'A1:GR1')

xls_filename = (sprintf('D:\\connectome\\Q2_results\\PpA_model_%0.1d_%s_session%d',model, contrast, session));
save(xls_filename, 'PpA')
xlswrite(xls_filename,PpA)
xlswrite(xls_filename, areas, 'A1:GR1')

xls_filename = (sprintf('D:\\connectome\\Q2_results\\PpB_model_%0.1d_%s_session%d',model, contrast, session));
save(xls_filename, 'PpB')
xlswrite(xls_filename,PpB)
xlswrite(xls_filename, areas, 'A1:GR1')