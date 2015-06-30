function [Model, mice, stim] = run_predictions_mice(dataset, Model, mice, stim)

%INPUT ARGUMENTS
% dataset = where you save results. options are: mice_inhib,
% mice_all, mice_clean, mice_debug

% Model = options are: linear, distorted4, distorted10, distorted20

% mice = name of the .txt file that has your cell test numbers

% stim = name of the .txt file that has your stimulus names

% LPfilter = (is still in 'GenerateStimulus.m')

% errorType = (is still in 'VisualizeTracePredictions.m')

close all
% clear all

%%%%%%  SET UP NOTES   %%%%%%
% Check: Turn on/off LP filters in 'GenerateStimulus.m'
% Check: how many stimuli are you analyzing? in 'yourStim' variable
% Check: Which calculation of prediction error do you want to use? in
% 'VisualizeTracePredictions.m'. Also change the plot legend to say either 'NMSE' or 'NormDist' in this same
% script!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

startpath = ['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\'];
savepath = [startpath, Model, '\']

%Load your test information
mousedata = dlmread(mice,'\t');


%Load your stimuli information
yourStim = 33; %How many stimuli do you have? (i.e. how many rows in 'stimuli.txt' or 'stimuliDist.txt' do you have?) Default should be 33, but there are 72 for LP_mice (as of 6/11/2015), and 82 if you run the regular 33 jump syllables and Pat's 49 7.5.12 vocs

fileID=fopen(stim); %input from function 'stim'
stimdata = textscan(fileID, '%s', yourStim);
fclose(fileID);

%Define some parameter and variable sizes
numMice = size(mousedata,1); %number of rows in your text file
numColumns = (yourStim+2); %Is the number of stimuli plus two extra columns for the mouse # and cell depth (cell identifiers used in output text files)

% Create empty arrays to put model information into
micePrediction = zeros(numMice, numColumns); %This makes an array the same size as the number of files to be analyzed and fills it with zeros
miceError = zeros(numMice, numColumns);  %This makes an array the same size as the number of files to be analyzed and fills it with zeros
% sndType = '.call1'; %what is your stimulus file type?
% sndType = '.wav';

if exist('C:\Users\emahrt\Documents\mice_predictions\Output\Mouse');
    rmdir('C:\Users\emahrt\Documents\mice_predictions\Output\Mouse', 's');
else
end

%Delete cached files and variables
responsePrediction = [ ];
dlmwrite(strcat(savepath, '\responsePrediction.txt'), responsePrediction, 'delimiter', '\t', 'precision', '%.4f', '-append')

for mouse = 1:numMice
    
    responsePrediction = zeros(yourStim,100);  %100 has to do with Lars' code. Don't change it!
    %Create a preferences structure for the desired experimental data that
    %includes test information. First column is mouse number, second column is depth, ninth column is mouse letter
    
    prefs = GeneratePreferences_EM('Mouse',...
        mousedata(mouse,1),... %Mouse #
        mousedata(mouse,9),... %Mouse letter
        mousedata(mouse,2),... % Cell depth
        Model,... %what model is it and thus where should it save results (linear vs distorted)
        mousedata(mouse,5),... %response time start
        mousedata(mouse,6)); %response time stop
    
    %Set the threshold used for spike detection. 0.11 is the default.
    prefs.spike_time_peak_threshold = mousedata(mouse,8); % spike thresholds are in 8th column
    
    %     prefs.spike_time_filter_cutoff = 1; % not sure what this is for
    
    %Extract XML metadata and convert to to Matlab structure
    experiment_data = LoadExperimentData(prefs); %Load data file. Did you put it in the right place?
    disp '-----Extracting File-----'
    experiment_data.pst_filename
    
    %-------------------
    % Test Visualization
    %-------------------
    %Specify the test number to visualize, this is a one tone test
    freqtest_num =mousedata(mouse,7);    %Generate contour plot of single frequency tuning curve (column 7)
    
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
        for column =1:yourStim % loop through all the vocalization test numbers.
            
            testNum = mousedata(mouse,9+column); %grab the test number; mouse is the row and the vocalization test numbers start in the 10th column (thus 9+ column)
            if (testNum ~= 0) %if there is a test number, then do the next step
                
                %Assign a number to each of the stimuli used
                vocalStr = experiment_data.test(1,testNum).trace(1,1).stimulus.vocal_call_file; %grabs the name of the stimulus file from the Batlab file in testNum
                vocalNum=0;
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
%                     disp('Figure Name')
                    figname = [savepath prefs.cell_id '_vocalL_' numStr '.pdf'];
                    saveas(gcf,figname);
                    %                                 close all
                    close force all
                    
                    micePrediction(mouse, (vocalNum+2)) = sum(max(model_output,0)); % put the value into the mouse' row. The column is the same as the index of the vocalStr. +2 to skip mouse# and depth columns
                    miceError(mouse, (vocalNum+2)) = model_errorsL;
                    lmo = length(model_output);
                    if lmo<100 model_output = [model_output model_output(lmo)*ones(1,100-lmo)]; end %zero padding; 100 has to do with the length of the model; because the model only predicts for the length of the stimulus, not after.
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
    
    dlmwrite(strcat(savepath, '\responsePrediction.txt'), responsePrediction, 'delimiter', '\t', 'precision', '%.4f') % add '-append' if you want to append onto previous run throughs of the files
    dlmwrite(strcat(savepath, '\micePrediction.txt'), micePrediction, 'delimiter', '\t', 'precision', '%.4f')
    dlmwrite(strcat(savepath, '\micePredictError.txt'), miceError, 'delimiter', '\t', 'precision', '%.4f')
    
end

disp '------- All Done! -------'
