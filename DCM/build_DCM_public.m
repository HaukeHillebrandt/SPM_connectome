clc
clear all

data_directory = 'D:\connectome\tfMRI_social';

[files,subject_dirs] = spm_select('ExtFPList',data_directory,'dummy.xxx');


q = 0;
region.name = [];
region.coordinate = [];

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

region.no = length(region.name);

%% Model 1
model = 3;

% dummy_DCM = sprintf('%s\\social_results\\smoothed\\DCM_dummy%0.1d.mat',subject_dirs(1,:), model)
dummy_DCM = sprintf('DCM_dummy%0.1d.mat', model);
load(dummy_DCM)

model = 1;

DCM.a = [];
DCM.b = [];
DCM.c = [];
DCM.d = [];

% DCM.a = ones(region.no); % complete intrinsic connectivity

DCM.a = [eye(region.no) + diag(ones(1,(region.no-1)),1) + diag(ones(1,(region.no-1)),-1)]; % only allow self-connections and connections to the next region in the hierarchy

DCM.b(:,:,1) = (zeros(region.no)); % All motion modulates nothing

DCM.b(:,:,2) = (DCM.a + (eye(region.no)*-1)); % random modulates everything, but self-connections

DCM.c = [[ones(1,1), zeros(1,1)]; zeros(region.no-1,2)]; %input into V1 and V3
% DCM.c(:,2) = [0 0 1]'

DCM.options.nonlinear = 0;
DCM.options.two_state = 1;
DCM.options.stochastic = 0;
DCM.options.centre = 1;
DCM.options.nograph = 1;
DCM.n = region.no;

if DCM.options.nonlinear == 1
    
    for i = 1:region.no
        DCM.d(:,:,i) = ((eye(region.no)*-1)+ones(region.no)); % nonlinearity of everything, but self-connections
        DCM.d(i,:,i) = zeros; %... and connections going to an area
        DCM.d(:,i,i) = zeros; %... and connections coming from an area
    end
    
else
    for i = 1:region.no
        DCM.d(:,:,i) = zeros(region.no);
    end
end

DCM.TE = 0.0331; % TE 33.10 ms
DCM.delays(1:region.no) = 0.36; % TR / 2 - as if corrected to middle slice - TR = 0.72 - DCM model can cope with up to 1s

master_DCM = sprintf('%s\\social_results\\smoothed_pmod\\DCM_master%0.1d.mat',subject_dirs(1,:), model);

save(master_DCM, 'DCM');

%% to make everything subject specific

for session = 1:2
    
    for subject = 1:68
        
        try
            DCM_filename = sprintf('%s\\social_results\\smoothed_pmod\\DCM_%0.1d_sess%d.mat',subject_dirs(subject,:), model, session);
            
            copyfile(master_DCM,DCM_filename)
            
            for i = 1:length(region.name)
                voi_filenames{i} = sprintf('%s\\social_results\\smoothed_pmod\\VOI_%s_%d.mat',subject_dirs(subject,:), region.name{i}, session);
            end
            
            SPM_filename = spm_select('FPListRec',sprintf('%s\\social_results\\smoothed_pmod', subject_dirs(subject,:)),'^SPM.mat$');
            
            input_nos = {[1 1]};
            
            spm_dcm_voi(DCM_filename,voi_filenames)
            
            spm_dcm_U(DCM_filename,SPM_filename,session,input_nos)
            tic
            spm_dcm_estimate(DCM_filename)
            toc
            done_mail(sprintf('s%0.2d_session_%0.2d estimated',subject,session))
            
        catch
            display 'DCM Failed'
            printoutname=sprintf('s%0.2d_session_%0.2d',subject,session);
            q=q+1;
            failed_DCM{q,1}=printoutname;
            mat_failed = 'failed_DCM_name.mat'
            failed_DCM_name = sprintf('%s\\%s', data_directory, mat_failed)
            save(failed_DCM_name, 'failed_DCM')
        end
    end
end


