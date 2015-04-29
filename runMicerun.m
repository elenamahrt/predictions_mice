%% Run Linear Models

% NOTE: Must turn Low Pass filter  ***OFF*** in 'GenerateStimulus.m' before running!!! 

run_predictions_mice('linear', 'mice_clean.txt', 'stimuli.txt')


%% Run Distorted Models

% NOTE: Must turn Low Pass filter  ***ON*** in 'GenerateStimulus.m' before running!!! 

run_predictions_mice('distorted4', 'mice_clean.txt', 'stimuliDist.txt')

run_predictions_mice('distorted10', 'mice_clean.txt', 'stimuliDist.txt')

run_predictions_mice('distorted20', 'mice_clean.txt', 'stimuliDist.txt')
%%