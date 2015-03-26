% predictions_mice
close all
clear variables

fid=fopen('mice.txt'); %where test nums are stored
mousedata = textscan(fid, '%s %s %s %s %s %s %s %s %s %s %s', 82); %change last number to analyze ALL cells/rows
fclose(fid);
numMice = length(mousedata{1,1});
micePrediction = zeros(numMice, 82); %change last number to analyze ALL cells/rows
miceError = zeros(numMice, 82);%change last number to analyze ALL cells/rows
sndType = '.call1'; %assuming is stimulus file type?
% sndType = '.wav'; 

% for mouse = 1:numMice  
%uncomment above when you want to run whole batch of mice
for mouse = 10:10 %comment whenwhen you want to run whole batch of mice
    responsePrediction = zeros(49,100); %what does this do?
    %Create a preferences structure for the desired experimental data
%     prefs = GeneratePreferences('Mouse', char(mousedata{1,1}(mouse)),... 
%                                          char(mousedata{1,11}(mouse)),...
%                                          char(mousedata{1,2}(mouse))); %uncomment this when you are ready to analyze whole batch
    prefs = GeneratePreferences('Mouse', '493', 'b', '424'); 
    %Use this as test file; comment out when you are ready to analyze batch
    %of mice
    
    %Set the threshold used for spike detection. 0.11 is the default.
    prefs.spike_time_peak_threshold = str2num(char(mousedata{1,10}(mouse))); %Did Pat have spike thresholds saved in 10th column?
    %Extract XML metadata and conver to to Matlab structure
    experiment_data = LoadExperimentData(prefs);
    experiment_data.pst_filename 
   
    %-------------------
    % Test Visualization
    %-------------------
    %Specify the test number to visualize, this is a one tone test
    freqtest_num = str2num(char(mousedata{1,8}(mouse)));
    %Generate contour plot of single frequency tuning curve
    if freqtest_num ~= 0
        figname = ['/Users/robertpa/Desktop/mouseDataFigs/' prefs.cell_id '_freq.pdf'];                    
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
    firstVocal = str2num(char(mousedata{1,6}(mouse)));
    lastVocal = str2num(char(mousedata{1,7}(mouse)));
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
    micePrediction(mouse, 1) = str2num(char(mousedata{1,1}(mouse)));
    micePrediction(mouse, 2) = str2num(char(mousedata{1,2}(mouse)));
    miceError(mouse, 1) = str2num(char(mousedata{1,1}(mouse)));
    miceError(mouse, 2) = str2num(char(mousedata{1,2}(mouse)));
    if freqtest_num ~= 0
        train_data = freqtest_num;
        %Create the model
    [constrModel model] = CreateModel(experiment_data,prefs,train_data);
%     model = CreateModel(experiment_data,prefs,train_data);
%     spontRate = model.spontaneous_rate;
        numStr = num2str(train_data);
        figname = ['/Users/robertpa/Desktop/mouseDataFigs/' prefs.cell_id '_model1_' numStr '.pdf'];                    
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
 %%%Keep this list of Pat's stimuli in case you want to run them for your
 %%%data. You have a few cells with these stimuli as well%%%
            if strcmp(vocalStr, 'A4-11-sylb10.call1') vocalNum=1; end
%             if strcmp(vocalStr, 'C5-09-sylb149.call1') vocalNum=2; end
%             if strcmp(vocalStr, 'C5-10-sylb79.call1') vocalNum=3; end
            if strcmp(vocalStr, 'C5-11-sylb87.call1') vocalNum=4; end
            if strcmp(vocalStr, 'D5-01-sylb94.call1') vocalNum=5; end
%             if strcmp(vocalStr, 'D5-06-sylb17.call1') vocalNum=6; end
            if strcmp(vocalStr, 'D5-06-sylb80.call1') vocalNum=7; end
            if strcmp(vocalStr, 'D5-07-sylb101.call1') vocalNum=8; end
%             if strcmp(vocalStr, 'D5-08-sylb79.call1') vocalNum=9; end
            if strcmp(vocalStr, 'E2-01-sylb1.call1') vocalNum=10; end
            if strcmp(vocalStr, 'E2-02-sylb68.call1') vocalNum=11; end
            if strcmp(vocalStr, 'E2-07-sylb48sm.call1') vocalNum=12; end
            if strcmp(vocalStr, 'G3-07-sylb26.call1') vocalNum=13; end
            if strcmp(vocalStr, 'G3-07-sylb49sm.call1') vocalNum=14; end
            if strcmp(vocalStr, 'G5-01-sylb85.call1') vocalNum=15; end
            if strcmp(vocalStr, 'G5-01-sylb331.call1') vocalNum=16; end
%             if strcmp(vocalStr, 'G5-02-sylb23.call1') vocalNum=17; end
            if strcmp(vocalStr, 'G5-02-sylb192.call1') vocalNum=18; end
%             if strcmp(vocalStr, 'G5-02-sylb291.call1') vocalNum=19; end
%             if strcmp(vocalStr, 'G5-02-sylb401.call1') vocalNum=20; end
            if strcmp(vocalStr, 'G5-02-sylb455.call1') vocalNum=21; end
            if strcmp(vocalStr, 'G5-06-sylb1sm.call1') vocalNum=22; end
            if strcmp(vocalStr, 'G5-06-sylb558v2sm.call1') vocalNum=23; end
%             if strcmp(vocalStr, 'G5-07-sylb178.call1') vocalNum=24; end
            if strcmp(vocalStr, 'G5-07-sylb193sm.call1') vocalNum=25; end
            if strcmp(vocalStr, 'G5-08-sylb133sm.call1') vocalNum=26; end
%             if strcmp(vocalStr, 'G5-09-sylb83.call1') vocalNum=27; end
            if strcmp(vocalStr, 'G5-11-sylb366.call1') vocalNum=28; end
            if strcmp(vocalStr, 'H3-06-sylb29sm.call1') vocalNum=29; end
            if strcmp(vocalStr, 'H3-08-sylb18.call1') vocalNum=30; end
            if strcmp(vocalStr, 'H3-09-sylb20sm.call1') vocalNum=31; end
            if strcmp(vocalStr, 'H3-10-sylb9sm.call1') vocalNum=32; end
            if strcmp(vocalStr, 'H3-11-sylb14sm.call1') vocalNum=33; end
            if strcmp(vocalStr, 'I2-01-sylb95ver2.call1') vocalNum=34; end
            if strcmp(vocalStr, 'I2-02-sylb219.call1') vocalNum=35; end
            if strcmp(vocalStr, 'I2-02-sylb342.call1') vocalNum=36; end
            if strcmp(vocalStr, 'I2-06-sylb188sm.call1') vocalNum=37; end
            if strcmp(vocalStr, 'I2-08-sylb349.call1') vocalNum=38; end
            if strcmp(vocalStr, 'I2-10-sylb156sm.call1') vocalNum=39; end
            if strcmp(vocalStr, 'J1-01-sylb278.call1') vocalNum=40; end
            if strcmp(vocalStr, 'J1-06-sylb183.call1') vocalNum=41; end
%             if strcmp(vocalStr, 'J1-08-sylb123.call1') vocalNum=42; end
            if strcmp(vocalStr, 'J1-09-sylb213sm.call1') vocalNum=43; end
%             if strcmp(vocalStr, 'J1-10-sylb105.call1') vocalNum=44; end
            if strcmp(vocalStr, 'J1-11-sylb195.call1') vocalNum=45; end
%             if strcmp(vocalStr, 'K10-01-sylb110.call1') vocalNum=46; end
%             if strcmp(vocalStr, 'K10-01-sylb240.call1') vocalNum=47; end
            if strcmp(vocalStr, 'K10-10-sylb32sm.call1') vocalNum=48; end
%             if strcmp(vocalStr, 'A4-09-sylb63.call1') vocalNum=49; end
            if vocalNum~=0 
                test_to_view = testNum; 
                trace_num = size(experiment_data.test(1,test_to_view).trace, 2);  
                trace_to_view = trace_num; % trace=1, arrn=40; trace=2, arrn=30; trace=3, arrn=20; 
     %===== Inserted in GenerateStimulus.m ===
            %% --- High-pass filter ---
%                 Hd = highpass40khz;
%                 vocalization = filter(Hd,vocalization);
            %% ------------------------
  
                [model_errorsL model_output] = VisualizeTracePredictions(experiment_data, ...
                                          prefs, ...
                                          model, ...
                                          test_to_view, ...
                                          trace_to_view,[]);
                numStr = num2str(test_to_view);
                figname = ['/Users/robertpa/Desktop/mouseDataFigs/' prefs.cell_id '_vocalL_' numStr '.pdf'];                    
                saveas(gcf,figname);
    %             close all
                close force all
                micePrediction( mouse, vocalNum+2 ) = sum( max(model_output,0));
                miceError( mouse, vocalNum+2 ) = model_errorsL;
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
                display(['prediction = ' num2str(micePrediction( mouse, vocalNum+2 )) ', model_errorsL = ' num2str(model_errorsL)]);
    %             display(['model_errorsL = ' num2str(model_errorsL) ', model_errorsLC = ' num2str(model_errorsLC)]);
            end
        end
     end
   end
     dlmwrite('responsePrediction.txt',responsePrediction, 'delimiter', '\t', 'precision', '%.4f', '-append') 
     dlmwrite('micePrediction.txt', micePrediction, 'delimiter', '\t', 'precision', '%.4f')
     dlmwrite('micePredictError.txt', miceError, 'delimiter', '\t', 'precision', '%.4f')
end
