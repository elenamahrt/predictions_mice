%%%%%%  SET UP NOTES   %%%%%%
% Check: Turn on/off LP filters in 'GenerateStimulus.m'
% Check: how many stimuli are you analyzing? in 'yourStim' variable
% Check: Which calculation of prediction error do you want to use? in
% 'VisualizeTracePredictions.m'. Also change the plot legend to say either 'NMSE' or 'NormDist' in this same
% script!
%If you want to change figure parameters (file format, resolution, etc),
%look in "VisualizeTestData.m" ~line 70 6/24/15 I changed the resolution to
%600

% If you want to change colors of histogram, do it in "VisualizeTraceData"
% ~line 346
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Changing recording Window
% In "ParsePST.m"
% changed "duration = trace_data(5);" to be    "duration = 100;"
% It works but the tuning curves and prediction plots look very strange.
% Does not seem to be plotting evoked responses in correct way.

% test Dist Model
% clear all
% run_predictions_mice('mice_debug', 'distorted4', 'mice_debug.txt', 'stimuli.txt')

clear all
run_predictions_mice('mice_messy', 'linear', 'mice_messy.txt', 'stimuli.txt')
%%
% %% Run Linear Models
% 
% % NOTE: Must turn Low Pass filter  ***OFF*** in 'GenerateStimulus.m' before running!!! 

% % Clean TC Dataset
% clear all
% run_predictions_mice('mice_clean', 'linear', 'mice_clean.txt', 'stimuli.txt')
% % 
% % % % All cells Dataset
% % clear all
% % run_predictions_mice('mice_all', 'linear', 'mice_all.txt', 'stimuli.txt')
% 
% % % Inhibitory cells Dataset
% clear all
% run_predictions_mice('mice_inhib', 'linear', 'mice_inhib.txt', 'stimuli.txt')
% 
% % % Messy Tuning Curves cells Dataset
% clear all
% run_predictions_mice('mice_messy', 'linear', 'mice_messy.txt', 'stimuli.txt')
% 
% % % 'O' Tuned cells Dataset
% clear all
% run_predictions_mice('mice_oTuned', 'linear', 'mice_oTuned.txt', 'stimuli.txt')
% 
% % % hiTuned Cells Dataset
% clear all
% run_predictions_mice('mice_hiTuned', 'linear', 'mice_hiTuned.txt', 'stimuli.txt')

% % Figures Dataset
clear all
run_predictions_mice('mice_figures', 'linear', 'mice_figures.txt', 'stimuli.txt')
%%
% %  LowPass Cells Dataset
clear all
run_predictions_mice('mice_LP', 'linear', 'mice_LP.txt', 'stimuli.txt')
%% Run Distorted Models
% 
% % NOTE: Must turn Low Pass filter  ***ON*** in 'GenerateStimulus.m' before running!!! 

% Clean TC Dataset
% clear all
% run_predictions_mice('mice_clean', 'distorted4', 'mice_clean.txt', 'stimuli.txt')
% % 
% % % % All cells Dataset
% % clear all
% % run_predictions_mice('mice_all', 'distorted4', 'mice_all.txt', 'stimuli.txt')
% 
% % % Inhibitory cells Dataset
% clear all
% run_predictions_mice('mice_inhib', 'distorted4', 'mice_inhib.txt', 'stimuli.txt')
% 
% % % Messy Tuning Curves cells Dataset
% clear all
% run_predictions_mice('mice_messy', 'distorted4', 'mice_messy.txt', 'stimuli.txt')
% 
% % % 'O' Tuned cells Dataset
% clear all
% run_predictions_mice('mice_oTuned', 'distorted4', 'mice_oTuned.txt', 'stimuli.txt')

% % hiTuned Cells Dataset
% clear all
% run_predictions_mice('mice_hiTuned', 'distorted4', 'mice_hiTuned.txt', 'stimuli.txt')

% % Figures Dataset
clear all
run_predictions_mice('mice_figures', 'distorted4', 'mice_figures.txt', 'stimuli.txt')

%%
% %  LowPass Cells Dataset
clear all
run_predictions_mice('mice_LP', 'distorted4', 'mice_LP.txt', 'stimuli.txt')
%%
% % mice_examples Data set:
% % % is an overlap selective cell and I would like to see
% what predictions look like for whole set of stimuli (including 7.5.12
% syllables)
% To run these I changed the number of stimuli to be 82 (#
% rows in stimuli.txt)
% 
% clear all
% run_predictions_mice('mice_examples', 'distorted4', 'mice_examples.txt', 'stimuli.txt')


clear all
run_predictions_mice('mice_examples', 'linear', 'mice_examples.txt', 'stimuli.txt')
%% DeBug Models
% % what/where is rise/fall for reading spectrograms? Is it added as part
% of the model process? no rise/fall could be adding a click

% clear all
% run_predictions_mice('mice_debug', 'distorted4', 'mice_debug.txt', 'stimuli.txt')

% %%
clear all
run_predictions_mice('mice_debug', 'linear', 'mice_debug.txt', 'stimuli.txt')
%%
makePlots('mice_clean', 'Clean TCs')
%%
makePlots('mice_all', 'All Cells')
%%
% figure
makePlots('mice_inhib', 'Inhibitory Cells','k')
makePlots('mice_hiTuned', 'Hi-Tuned Cells','b')
makePlots('mice_clean', 'Clean TCs','m')
makePlots('mice_messy', 'Messy TCs','g')
makePlots('mice_oTuned', 'oTuned Cells','r')
%%
makePlots('mice_LP', 'LP Cells','c')