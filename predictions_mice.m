% predictions_mice
close all
clear variables
clear all

savepath = 'C:\Users\emahrt\Documents\ElectrophysiologyProjects\TestData'

fid=fopen('mice.txt'); %where test nums are stored
mousedata = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s', 1); %change last number to total number of cells in mice.txt to analyze ALL cells/rows
fclose(fid);

%%%Uncomment below when you want to add in the txt file of stimuli rather than having them inline below
% fileID=fopen('stimuli.txt'); 
% stimdata = textscan(fileID, '%s', 82); %Change the last number to reflect the total number of stimuli
% fclose(fileID);

numMice = length(mousedata{1,1});
micePrediction = zeros(numMice, 1); %This makes an array the same size as the number of files to be analyzed and fills it with zeros  
%change last number to analyze ALL cells/rows
miceError = zeros(numMice, 1);  %change last number to analyze ALL cells/rows
sndType = '.call1'; %assuming is stimulus file type?
% sndType = '.wav';

% for mouse = 1:numMice
%uncomment above when you want to run whole batch of mice

for mouse = 1:1 %comment when you want to run whole batch of mice
    responsePrediction = zeros(49,100); %assuming this creates an array filled with zeros that is same size as the number of files to be analyzed
    %Create a preferences structure for the desired experimental data
    %     prefs = GeneratePreferences_EM('Mouse', char(mousedata{1,1}(mouse)),...
    %                                          char(mousedata{1,11}(mouse)),...
    %                                          char(mousedata{1,2}(mouse))); %uncomment this when you are ready to analyze whole batch
    prefs = GeneratePreferences_EM('Mouse', '1327', 'b', '187');
%     prefs = GeneratePreferences_EM(mousepath, 1);
    %function prefs = GeneratePreferences_EM(animal_number, experiment_letter, cell_depth)
    %Use this as test file; comment out when you are ready to analyze batch
    %of mice
    
    %Set the threshold used for spike detection. 0.11 is the default.
    prefs.spike_time_peak_threshold = str2num(char(mousedata{1,10}(mouse))); %assuming spike thresholds should be saved in 10th column
%     prefs.spike_time_filter_cutoff = 1; %%%WHAT IS THIS AND WHAT ARE THE RIGHT VALUES FOR THIS?
    %Extract XML metadata and convert to to Matlab structure
    experiment_data = LoadExperimentData(prefs); %Is this where it actually loads the .raw file? Check what 'LoadExperimentData' does
    experiment_data.pst_filename
    
    %-------------------
    % Test Visualization 
    %-------------------
    %Specify the test number to visualize, this is a one tone test
    freqtest_num = str2num(char(mousedata{1,8}(mouse)));    %Generate contour plot of single frequency tuning curve
        %Tuning curves are in column 8
        
    if freqtest_num ~= 0
        %         figname = ['/Users/robertpa/Desktop/mouseDataFigs/' prefs.cell_id '_freq.pdf'];
        figname = [savepath prefs.cell_id '_freq.pdf'];
%         figname = [mousepath  prefs.cell_id '_freq.pdf'];
        
        [unique_frequencies, ...
            unique_attenuations, ...
            test_data, ...
            tune_classes] = VisualizeTestData(experiment_data,prefs,freqtest_num,[1 0 0 1 0]);
        %         VisualizeTestData(experiment_data,prefs,freqtest_num,[1 0 0 1 0],figname)
        saveas(gcf,figname);
        close all
    end
    %--------------------------------------
    % %Generate image map plots of time-frequency histograms
    % VisualizeTestData(experiment_data,prefs,test_num,[0 1 0 0 1])
    %--------------------------------------
    %Specify the test number to visualize, this is a two-tone test
    firstVocal = str2num(char(mousedata{1,6}(mouse)))
    lastVocal = str2num(char(mousedata{1,7}(mouse)))
    
    % %--------------------
    % % Trace Visualization %WHAT DOES THIS DO??
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
    micePrediction(mouse, 1) = str2num(char(mousedata{1,1}(mouse))); %WHAT DO THESE DO?
    micePrediction(mouse, 2) = str2num(char(mousedata{1,2}(mouse))); %WHAT DO THESE DO?
    miceError(mouse, 1) = str2num(char(mousedata{1,1}(mouse))); %WHAT DO THESE DO?
    miceError(mouse, 2) = str2num(char(mousedata{1,2}(mouse))); %WHAT DO THESE DO?
    if freqtest_num ~= 0
        train_data = freqtest_num;
        %Create the model
        [constrModel, model] = CreateModel(experiment_data,prefs,train_data);
        %     model = CreateModel(experiment_data,prefs,train_data);
        %     spontRate = model.spontaneous_rate;
        numStr = num2str(train_data);
        %         figname = ['/Users/robertpa/Desktop/mouseDataFigs/' prefs.cell_id '_model1_' numStr '.pdf'];
        figname = [savepath prefs.cell_id '_model1_' numStr '.pdf'];
        saveas(gcf,figname);
        close all
        
        %Visualize prediction made from the model on a specified trace
        %         firstVocal = CTR_First_vocal;
        %         lastVocal = CTR_Last_vocal;
        if (firstVocal ~= 0) && (lastVocal ~= 0)
            %       if (strcmp(experiment_data.test(1,firstVocal).trace(1,1).stimulus.vocal_call_file, 'A4-11-sylb10.call1'))
            %        else
            %            disp([ 'error: first vocal (mouse ' num2str(micePrediction(mouse, 1)) ', depth ' num2str(micePrediction(mouse, 2)) ') = ' experiment_data.test(1,firstVocal).trace(1,1).stimulus.vocal_call_file])
            %        end
            for testNum = firstVocal:lastVocal
                vocalStr = experiment_data.test(1,testNum).trace(1,1).stimulus.vocal_call_file;
                vocalNum=0;
                
                %%Uncomment 
                %Assign a number to each of the stimuli used
%                 for i = 1:length(stimdata)
%                     stim = stimdata{1}(i);
%                     if strcmp(vocalStr, stim{1}) vocalNum=i; end
%                 end

                %%%Example of what Pat had in his original script:
                if strcmp(vocalStr, '23A_15kHz_OLap2ms.call1') vocalNum=1; end
                if strcmp(vocalStr, '23B_21kHz_OLap1ms.call1') vocalNum=2; end
                if vocalNum~=0
                    test_to_view = testNum;
                    trace_num = size(experiment_data.test(1,test_to_view).trace, 2);
                    trace_to_view = trace_num; % trace=1, arrn=40; trace=2, arrn=30; trace=3, arrn=20;
                    
                    %===== Inserted in GenerateStimulus.m ===
                    %% --- High-pass filter ---
                    %                 Hd = highpass40khz;
                    %                 vocalization = filter(Hd,vocalization);
                    %% ------------------------
                    
                    [model_errorsL, model_output] = VisualizeTracePredictions(experiment_data, ...
                        prefs, ...
                        model, ...
                        test_to_view, ...
                        trace_to_view,[]);
                    numStr = num2str(test_to_view);
                    %                     figname = ['/Users/robertpa/Desktop/mouseDataFigs/' prefs.cell_id '_vocalL_' numStr '.pdf'];
                    figname = [savepath prefs.cell_id '_vocalL_' numStr '.pdf'];
                    saveas(gcf,figname);
                    %             close all
                    close force all
                    micePrediction(mouse, vocalNum+2) = sum(max(model_output,0));
                    miceError(mouse, vocalNum+2) = model_errorsL;
                    lmo = length(model_output);
                    if lmo<100 model_output = [model_output model_output(lmo)*ones(1,100-lmo)]; end
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
    dlmwrite((strcat(savepath,'\responsePrediction.txt')),responsePrediction, 'delimiter', '\t', 'precision', '%.4f', '-append')
    dlmwrite('C:\Users\emahrt\Documents\ElectrophysiologyProjects\TestData\micePrediction.txt', micePrediction, 'delimiter', '\t', 'precision', '%.4f')
    dlmwrite('C:\Users\emahrt\Documents\ElectrophysiologyProjects\TestData\micePredictError.txt', miceError, 'delimiter', '\t', 'precision', '%.4f')
end
