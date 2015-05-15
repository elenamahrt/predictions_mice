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
% savepath = ['C:\Users\emahrt\Documents\mice_predictions\results\' dataset '\linear\'];

% C:\Users\emahrt\Documents\mice_predictions\results\20150511_Results_NMSE

% Linear Results
Linear_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\20150511_Results_NMSE\' dataset '\linear\micePredictError.txt'], '\t', 0, 2); %remove the 2 if you want it to keep the mouse # and depth in it
Linear_miceError = Linear_miceError(:);
save('Linear_miceError.txt','Linear_miceError','-ascii')


% % Dist4 Results
Dist4_miceError = dlmread(['C:\Users\emahrt\Documents\mice_predictions\results\20150511_Results_NMSE\' dataset '\distorted4\micePredictError.txt'], '\t', 0, 2);
Dist4_miceError = Dist4_miceError(:);
save('Dist4_miceError.txt','Dist4_miceError','-ascii')

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
allSyls_scatter = scatter(Linear_miceError, Dist4_miceError, 20, 'k', 'filled');
% allSyls_scatter = scatter(Linear_miceError, Dist10_miceError, 20, 'b', 'filled');
% allSyls_scatter = scatter(Linear_miceError, Dist20_miceError, 20, 'r', 'filled');
title([Title,' ', '\fontsize{14}Linear vs Distorted NMSE ', date]) 
xlabel('\fontsize{12}NMSE of Linear Prediction')
ylabel('\fontsize{12}NMSE of Distorted Prediction')
% legend('Dist4 MiceError', 'Dist10 MiceError', 'Dist20 MiceError', 'Location', 'SouthEast')
legend('Dist4 MiceError','Location', 'SouthEast')

% legend('\fontsize{8}Dist4 MiceError', '\fontsize{8}Dist10 MiceError', '\fontsize{8}Dist20 MiceError', 'Location', 'SouthEast')
% saveTitle = [Title date];
% saveas(gcf,saveTitle,'jpg')
