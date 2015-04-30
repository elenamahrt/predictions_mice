
% Goal: Make scatter plot of prediction errors for all syllables for each
% prediction model. The Linear model will be 'x' and the other models will
% be the 'y'. 
% clear all
% close all


Linear_miceError = [];
Dist4_miceError = [];
Dist10_miceError = [];
Dist20_miceError = [];

% Linear Results
% Linear_miceError = dlmread('C:\Users\emahrt\Documents\mice_predictions\results\linear\micePredictError.txt', '\t', 0, 2);
% Linear_miceError = Linear_miceError(:);

% % Dist4 Results
Dist4_miceError = dlmread('C:\Users\emahrt\Documents\mice_predictions\results\distorted4\micePredictError.txt', '\t', 0, 2);
Dist4_miceError = Dist4_miceError(:);

% Dist10 Results
Dist10_miceError = dlmread('C:\Users\emahrt\Documents\mice_predictions\results\distorted10\micePredictError.txt', '\t', 0, 2);
Dist10_miceError = Dist10_miceError(:);

% Dist20 Results
Dist20_miceError = dlmread('C:\Users\emahrt\Documents\mice_predictions\results\distorted20\micePredictError.txt', '\t', 0, 2);
Dist20_miceError = Dist20_miceError(:);

clf
% figure;
% subplot(2, 1, 1)

% hold on
% allSyls_scatter = scatter(Linear_miceError, Dist4_miceError, 20, 'k', 'filled');
% allSyls_scatter = scatter(Linear_miceError, Dist10_miceError, 20, 'b', 'filled');
% allSyls_scatter = scatter(Linear_miceError, Dist20_miceError, 20, 'r', 'filled');
% 
% title(['\fontsize{16}Linear vs Distorted Normalized Distance ', date]) 
% xlabel('\fontsize{12}Norm Distance of Linear Prediction')
% ylabel('\fontsize{12}Norm Distance of Distorted Prediction')
% legend('Dist4 MiceError', 'Dist10 MiceError', 'Dist20 MiceError', 'Location', 'SouthEast')
% legend('\fontsize{10}Dist4 MiceError', '\fontsize{10}Dist10 MiceError', '\fontsize{10}Dist20 MiceError', 'Location', 'SouthEast')

% figure;
subplot(2, 1, 2)
hold on
allSyls_scatter_Dist = scatter(Dist4_miceError, Dist10_miceError, 20, 'g', 'filled')
allSyls_scatter_Dist = scatter(Dist4_miceError, Dist20_miceError, 20, 'm', 'filled')
allSyls_scatter_Dist = scatter(Dist10_miceError, Dist20_miceError, 20, 'g', 'filled')
title('Dist4 vs Dist10 and 20')





