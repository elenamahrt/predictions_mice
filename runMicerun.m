%% Run Linear Models

% NOTE: Must turn Low Pass filter  ***OFF*** in 'GenerateStimulus.m' before running!!! 
clear all
run_predictions_mice('linear', 'mice_clean.txt', 'stimuli.txt')


%% Run Distorted Models

% NOTE: Must turn Low Pass filter  ***ON*** in 'GenerateStimulus.m' before running!!! 

clear all
run_predictions_mice('distorted4', 'mice_clean.txt', 'stimuli.txt')

clear all
run_predictions_mice('distorted10', 'mice_clean.txt', 'stimuli.txt')

clear all
run_predictions_mice('distorted20', 'mice_clean.txt', 'stimuli.txt')
%% DeBug Models

clear all
run_predictions_mice('distorted4', 'mice_debug.txt', 'stimuli.txt')

clear all
run_predictions_mice('distorted10', 'mice_debug.txt', 'stimuli.txt')

clear all
run_predictions_mice('distorted20', 'mice_debug.txt', 'stimuli.txt')

% clear all
% run_predictions_mice('linear', 'mice_debug.txt', 'stimuli.txt')
