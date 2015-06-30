function makePlots(dataset,Title, color)
%
%function makePlots(dataset)
%
%   INPUT ARGUMENTS
%
%   dataset = options are mice_debug, mice_clean, mice_inhib, or mice_all
%
%   Will make scatter plot of Linear model on x axis and distorted models
%   on y axis
% savepath = ['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\linear\'];

% C:\Users\emahrt\Documents\mice_predictions\results\20150511_Results_NMSE

% Linear Results
Linear_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\linear\micePredictError.txt'], '\t', 0, 2); %remove the 2 if you want it to keep the mouse # and depth in it
Linear_miceError = Linear_miceError(:);
save([dataset '_Linear_Error.txt'], 'Linear_miceError','-ascii')
% if you get an error regarding saving this file, make sure your matlab current
% directory is set to "mice_predictions"

% % Dist4 Results
Dist4_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\distorted4\micePredictError.txt'], '\t', 0, 2);
Dist4_miceError = Dist4_miceError(:);
save([dataset '_Dist4_Error.txt'],'Dist4_miceError','-ascii')

% % Dist10 Results
% Dist10_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\distorted10\micePredictError.txt'], '\t', 0, 2);
% Dist10_miceError = Dist10_miceError(:);
% save('Dist10_miceError.txt','Dist10_miceError','-ascii')

% % Dist20 Results
% Dist20_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\distorted20\micePredictError.txt'], '\t', 0, 2);
% Dist20_miceError = Dist20_miceError(:);
% save('Dist20_miceError.txt','Dist20_miceError','-ascii')

% clf
figure;
hold on
% subplot(3, 1, 1)
dataset = scatter(Linear_miceError, Dist4_miceError, 20, color,'filled');
title([Title,' ', '\fontsize{14}Linear vs Distorted NormDist ', date]) 
xlabel('\fontsize{12}NMSE of Linear Prediction')
ylabel('\fontsize{12}NMSE of Distorted Prediction')
% legend(dataset)
lsline
% h = lsline;
% gcf(h,'color',k)
hold off




% legend('\fontsize{8}Dist4 MiceError', '\fontsize{8}Dist10 MiceError', '\fontsize{8}Dist20 MiceError', 'Location', 'SouthEast')
% saveTitle = [Title date];
% saveas(gcf,saveTitle,'jpg')
