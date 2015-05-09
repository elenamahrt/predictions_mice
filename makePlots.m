function makePlots(dataset,Title)
%
%function makePlots(dataset)
%
%   INPUT ARGUMENTS
%
%   dataset = options are mice_debug, mice_clean, mice_inhib, or mice_all
%
%   Will make scatter plot of Linear model on x axis and distorted models
%   on y axis


% Linear Results
Linear_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\linear\micePredictError.txt'], '\t', 0, 2); %remove the 2 if you want it to keep the mouse # and depth in it
Linear_miceError = Linear_miceError(:);

% % Dist4 Results
Dist4_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\distorted4\micePredictError.txt'], '\t', 0, 2);
Dist4_miceError = Dist4_miceError(:);
%%

% Dist10 Results
% Dist10_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\distorted10\micePredictError.txt'], '\t', 0, 2);
% Dist10_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\mice_clean\distorted10\micePredictError.txt'], '\t', 0, 2);
% Dist10_miceError = Dist10_miceError(:);
% Dist10_miceError = Dist10_miceError(1:19720,1);

% Dist20 Results
% Dist20_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\distorted20\micePredictError.txt'], '\t', 0, 2);
%                                                       C:\Users\emahrt\Documents\mice_predictions\results\mice_clean\distorted20
% Dist20_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\mice_clean\distorted20\micePredictError.txt'], '\t', 0, 2);
% Dist20_miceError = Dist20_miceError(:);
% Dist20_miceError = Dist20_miceError(1:19720,1);

% clf
figure;
% subplot(2, 1, 1)

hold on
allSyls_scatter = scatter(Linear_miceError, Dist4_miceError, 20, 'k', 'filled');
% allSyls_scatter = scatter(Linear_miceError, Dist10_miceError, 20, 'b', 'filled');
% allSyls_scatter = scatter(Linear_miceError, Dist20_miceError, 20, 'r', 'filled');

title([Title,' ', '\fontsize{14}Linear vs Distorted Normalized Distance ', date]) 
xlabel('\fontsize{12}Norm Distance of Linear Prediction')
ylabel('\fontsize{12}Norm Distance of Distorted Prediction')
% legend('Dist4 MiceError', 'Dist10 MiceError', 'Dist20 MiceError', 'Location', 'SouthEast')
% legend('\fontsize{8}Dist4 MiceError', '\fontsize{8}Dist10 MiceError', '\fontsize{8}Dist20 MiceError', 'Location', 'SouthEast')
%%
% figure;
% % subplot(2, 1, 2)
% hold on
% allSyls_scatter_Dist = scatter(Dist4_miceError, Dist10_miceError, 20, 'g', 'filled')
% allSyls_scatter_Dist = scatter(Dist4_miceError, Dist20_miceError, 20, 'm', 'filled')
% allSyls_scatter_Dist = scatter(Dist10_miceError, Dist20_miceError, 20, 'g', 'filled')
% title('Dist4 vs Dist10 and 20')

%% make plots

