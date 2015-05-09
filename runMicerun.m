% %% Run Linear Models
% 
% % NOTE: Must turn Low Pass filter  ***OFF*** in 'GenerateStimulus.m' before running!!! 

%Clean TC Data
clear all
run_predictions_mice('mice_clean', 'linear', 'mice_clean.txt', 'stimuli.txt')
% % 
% % All cells dataset
% clear all
% run_predictions_mice('mice_all', 'linear', 'mice_all.txt', 'stimuli.txt')
% % 
% % inhibitory cells dataset
% clear all
% run_predictions_mice('mice_inhib', 'linear', 'mice_inhib.txt', 'stimuli.txt')

%% Run Distorted Models
% 
% % NOTE: Must turn Low Pass filter  ***ON*** in 'GenerateStimulus.m' before running!!! 

% Clean TC Dataset
clear all
run_predictions_mice('mice_clean', 'distorted4', 'mice_clean.txt', 'stimuli.txt')
% 
% clear all
% run_predictions_mice('mice_clean', 'distorted10', 'mice_clean.txt', 'stimuli.txt')
% 
% clear all
% run_predictions_mice('mice_clean', 'distorted20', 'mice_clean.txt', 'stimuli.txt')
% 
% % All cells Dataset
% clear all
% run_predictions_mice('mice_all', 'distorted4', 'mice_all.txt', 'stimuli.txt')
% 
% clear all
% run_predictions_mice('mice_all', 'distorted10', 'mice_all.txt', 'stimuli.txt')
% 
% clear all
% run_predictions_mice('mice_all', 'distorted20', 'mice_all.txt', 'stimuli.txt')
% 
% % Inhibitory cells Dataset
% clear all
% run_predictions_mice('mice_inhib', 'distorted4', 'mice_inhib.txt', 'stimuli.txt')
% 
% clear all
% run_predictions_mice('mice_inhib', 'distorted10', 'mice_inhib.txt', 'stimuli.txt')
% 
% clear all
% run_predictions_mice('mice_inhib', 'distorted20', 'mice_inhib.txt', 'stimuli.txt')

% %% DeBug Models
% % 
% clear all
% run_predictions_mice('mice_debug', 'distorted4', 'mice_debug.txt', 'stimuli.txt')
% %%
% clear all
% run_predictions_mice('mice_debug', 'distorted10', 'mice_debug.txt', 'stimuli.txt')
% 
% clear all
% run_predictions_mice('mice_debug', 'distorted20', 'mice_debug.txt', 'stimuli.txt')
% %%
% clear all
% run_predictions_mice('mice_debug', 'linear', 'mice_debug.txt', 'stimuli.txt')
%%
makePlots('mice_clean', 'Clean TCs Data')