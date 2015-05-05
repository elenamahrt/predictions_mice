function [Model, mice, stim] = run_predictions_mice(Model, mice, stim)
% function run_predictions_mice(model, mice, stim, HPfilter, LPfilter, errorType)

%INPUT ARGUMENTS
% model = options are: linear, distorted4, distorted10, distorted20

% mice = name of the .txt file that has your cell test numbers

% stim = name of the .txt file that has your stimulus names

% LPfilter = (is still in 'GenerateStimulus.m')

% errorType = (is still in 'VisualizeTracePredictions.m')

close all
% clear all

%%%%%%  SET YOUR VARIABLES AND PATHS   %%%%%%
% startpath = 'C:\Users\emahrt\Documents\mice_predictions\results\';
% savepath = [startpath, Model, '\']
% 
% yourMice = 13; %How many cells do you have? (i.e. how many rows)

% yourStim = 33; %How many stimuli do you have? (i.e. how many rows in 'stimuli.txt' or 'stimuliDist.txt' do you have?)
% % % Linear = 'stimuli.txt' 1-33 are Jump syllables; 34-82 are 7.5.12 CBA vox;
% % % Distorted  = 'stimuliDist.txt'; 1-33 are Jump syllables with same
% name as linear; 34-132 are jump syllables with "Dist" type specified in
% file name

% numColumns=33+9; %9 cells have cell and TC information, the 33 cells are for the vocalization test numbers (i.e. how many columns are there)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%  Read txt files that have stimulus and cell information in them

% fid=fopen(mice); %where test information is stored; 'mice' is function input of file name for cell #'s
% % mousedata = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s %s', yourMice); %Need to increase number of '%s' if you have more than 33 stimuli
% mousedata = textscan(fid,'%s %s %s %s %s %s %s %s %s',numColumns,'Delimiter','\t');
% fclose(fid);

startpath = 'C:\Users\emahrt\Documents\mice_predictions\results\';
savepath = [startpath, Model, '\']

%Load your test information
mousedata = dlmread(mice,'\t');

%Define some parameter and variable sizes 
numColumns = length(mousedata);
numMice = size(mousedata);
numMice = mousedata(1,1);

%Load your stimuli information
yourStim = 33; %How many stimuli do you have? (i.e. how many rows in 'stimuli.txt' or 'stimuliDist.txt' do you have?)
fileID=fopen(stim); %input from function 'stim'
stimdata = textscan(fileID, '%s', yourStim); %Change the last number to reflect the total number of stimuli
fclose(fileID);

% Create empty arrays to put model information into
micePrediction = zeros(numMice, numColumns); %This makes an array the same size as the number of files to be analyzed and fills it with zeros
miceError = zeros(numMice, numColumns);  %This makes an array the same size as the number of files to be analyzed and fills it with zeros
sndType = '.call1'; %what is your stimulus file type?
% sndType = '.wav';


if exist('C:\Users\emahrt\Documents\mice_predictions\Output\Mouse')
    rmdir('C:\Users\emahrt\Documents\mice_predictions\Output\Mouse', 's');
else
end


%===== Insert into GenerateStimulus.m ===
%                     When you want to run model on distorted stimuli, Low
%                     Pass filter them; uncomment the stuff below in
%                     'GenerateStimulus.m' file
% --- Low-pass filter ---
%                                     Hd = lowpass40khz;
%                 vocalization = filter(Hd,vocalization);
% ------------------------

%Delete cached files and variables
responsePrediction = [ ];
dlmwrite(strcat(savepath, '\responsePrediction.txt'), responsePrediction, 'delimiter', '\t', 'precision', '%.4f', '-append')

for mouse = 1:numMice
        
    responsePrediction = zeros(yourStim,100);  %100 has to do with Lars' code. Don't change it!
    %Create a preferences structure for the desired experimental data
%     prefs = GeneratePreferences_EM('Mouse',char(mousedata{1,1}(mouse)),char(mousedata{1,9}(mouse)),char(mousedata{1,2}(mouse)),Model); 
%         prefs = GeneratePreferences_EM('Mouse',char(mousedata{mouse,1}{1,1}),char(mousedata{mouse,1}{1,9}),char(mousedata{mouse,1}{1,2}),Model); 
   
%first column is mouse number, second column is depth, ninth column is mouse letter
       prefs = GeneratePreferences_EM('Mouse',mousedata(mouse,1),mousedata(mouse,9),mousedata(mouse,2),Model); 
    
    %Set the threshold used for spike detection. 0.11 is the default.
%     prefs.spike_time_peak_threshold = str2num(char(mousedata{mouse,1}{1,8})); % spike thresholds are in 8th column
        prefs.spike_time_peak_threshold = mousedata(mouse,8); % spike thresholds are in 8th column

    %     prefs.spike_time_filter_cutoff = 1; %%%WHAT IS THIS AND WHAT ARE THE RIGHT VALUES FOR THIS?
    %Extract XML metadata and convert to to Matlab structure
    experiment_data = LoadExperimentData(prefs); %Load data file. Did you put it in the right place?
    experiment_data.pst_filename
    
    %-------------------
    % Test Visualization
    %-------------------
    %Specify the test number to visualize, this is a one tone test
%     freqtest_num = str2num(char(mousedata{mouse,1}{1,6}));    %Generate contour plot of single frequency tuning curve (column 6)
        freqtest_num =mousedata(mouse,6);    %Generate contour plot of single frequency tuning curve (column 6)

    if freqtest_num ~= 0
        figname = [savepath prefs.cell_id '_freq.pdf'];
        
        [unique_frequencies, ...
            unique_attenuations, ...
            test_data, ...
            tune_classes] = VisualizeTestData(experiment_data,prefs,freqtest_num,[1 0 0 1 0]);
        %                 VisualizeTestData(experiment_data,prefs,freqtest_num,[1 0 0 1 0],figname)
        saveas(gcf,figname);
        close all
    end
    %--------------------------------------
    % %Generate image map plots of time-frequency histograms
    % VisualizeTestData(experiment_data,prefs,test_num,[0 1 0 0 1])
    %--------------------------------------
    
    % %--------------------
    % % Trace Visualization
    % %--------------------
    % %Specify the test and trace number to visualize
    %
    % % for test_num = 18:33;
    % test_num = 18;
    % trace_num = 1;
    % %Visualize the traces
    %  VisualizeTraceData(experiment_data,prefs,test_num,trace_num);
    % % VisualizeTraceData(experiment_data,prefs,test_num,trace_num,[0 1 1 0 0 0 0 0 0 0]);
    % % VisualizeTraceData(experiment_data,prefs,test_num,trace_num,[0 0 0 1 1 1 1 0 0 0]);
    % %  VisualizeTraceData(experiment_data,prefs,test_num,trace_num,[0 0 0 0 0 0 0 1 1 0]);
    % % end
    
    
    % --------------------------------
    % Model Generation and Prediction
    % --------------------------------
    %Specify the tests to use as training data
%     micePrediction(mouse, 1) = str2num(char(mousedata{mouse,1}{1,1})); %%puts the mouse # in the first column of output .txt files
%     micePrediction(mouse, 2) = str2num(char(mousedata{mouse,1}{1,2})); %puts the cell depth in the first column of output .txt files
%     miceError(mouse, 1) = str2num(char(mousedata{mouse,1}{1,1})); %puts the mouse # in the first column of output .txt files
%     miceError(mouse, 2) = str2num(char(mousedata{mouse,1}{1,2})); %puts the cell depth in the first column of output .txt files

    micePrediction(mouse, 1) = mousedata(mouse,1); %%puts the mouse # in the first column of output .txt files
    micePrediction(mouse, 2) = mousedata(mouse,2); %puts the cell depth in the first column of output .txt files
    miceError(mouse, 1) = mousedata(mouse,1); %puts the mouse # in the first column of output .txt files
    miceError(mouse, 2) = mousedata(mouse,2); %puts the cell depth in the first column of output .txt files
    
    if freqtest_num ~= 0
        train_data = freqtest_num;
        %Create the model
        [constrModel, model] = CreateModel(experiment_data,prefs,train_data);
        %     model = CreateModel(experiment_data,prefs,train_data);
        %     spontRate = model.spontaneous_rate;
        numStr = num2str(train_data);
        figname = [savepath prefs.cell_id '_model1_' numStr '.pdf'];
        saveas(gcf,figname);
        close all
        
        %Visualize prediction made from the model on a specified trace
        
        for column =1:(numColumns-9) %vocalization test #s start in the 10th column and extend to a maximum of 33 columns beyond that.
            Vocal = mousedata(mouse,9+column);
            if (Vocal ~= 0)
                for testNum = Vocal
                    vocalStr = experiment_data.test(1,testNum).trace(1,1).stimulus.vocal_call_file;
                    vocalNum=0;
                    
                    %Assign a number to each of the stimuli used
                    stim = stimdata{1,1};
                    vocalNum = find(strcmp(stim,vocalStr)); %find the index of the location where the matching vocalfile name is in stimdata
                    
                    if vocalNum~=0
                        test_to_view = testNum;
                        trace_num = size(experiment_data.test(1,test_to_view).trace, 2);
                        trace_to_view = trace_num; % trace=1, arrn=40; trace=2, arrn=30; trace=3, arrn=20;
                        
                        [model_errorsL, model_output] = VisualizeTracePredictions(experiment_data, ...
                            prefs, ...
                            model, ...
                            test_to_view, ...
                            trace_to_view,[]);
                        numStr = num2str(test_to_view);
                        figname = [savepath prefs.cell_id '_vocalL_' numStr '.pdf'];
                        saveas(gcf,figname);
                        %                                 close all
                        close force all
                        micePrediction(mouse, vocalNum+2) = sum(max(model_output,0));
                        miceError(mouse, vocalNum+2) = model_errorsL;
                        lmo = length(model_output);
                        if lmo<100 model_output = [model_output model_output(lmo)*ones(1,100-lmo)]; end %100 has to do with the length of the model; because the model only predicts for the length of the stimulus, not after.
                        if lmo>100 model_output = model_output(1:100); end
                        responsePrediction(vocalNum, :) = model_output;
                        %             prediction( mouse, testNum ) = sum( max(model_output,0))/(size(model_output, 2));
                        %             [model_errorsLC model_output] = VisualizeTracePredictions(experiment_data, ...
                        %                                       prefs, ...
                        %                                       constrModel, ...
                        %                                       test_to_view, ...
                        %                                       trace_to_view);
                        %             numStr = num2str(test_to_view);
                        % %             figname = ['/Users/robertpa/Desktop/mouseDataFigs/' prefs.cell_id '_vocalLC_' numStr '.pdf'];
                        % %             saveas(gcf,figname);
                        close all
                        display(['prediction = ' num2str(micePrediction(mouse, vocalNum+2 )) ', model_errorsL = ' num2str(model_errorsL)]);
                        %             display(['model_errorsL = ' num2str(model_errorsL) ', model_errorsLC = ' num2str(model_errorsLC)]);
                    end
                end
            end
        end
    end
    
    dlmwrite(strcat(savepath, '\responsePrediction.txt'), responsePrediction, 'delimiter', '\t', 'precision', '%.4f', '-append')
    dlmwrite(strcat(savepath, '\micePrediction.txt'), micePrediction, 'delimiter', '\t', 'precision', '%.4f', '-append')
    dlmwrite(strcat(savepath, '\micePredictError.txt'), miceError, 'delimiter', '\t', 'precision', '%.4f', '-append')
    
end

disp '------- All Done! -------'
