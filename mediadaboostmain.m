% Matlab script that demonstrates how to build a tree under the MediAdaboost 
% paradigm. For more information please see:
%
% VALDES Gilmer, LUNA Jos�, EATON Eric, UNGAR Lyle, SIMONE Charles 
% and SOLDBERG Timothy. MediBoost: a Patient Stratification Tool for 
% Interpretable Decision Making in the Era of Precision Medicine. Under 
% Review. 2016.
%
% Usage:
%   Open the script mediadaboostmain and provide the dataset file DATA.MAT, the 
%   depth of the tree DEPTH_LIMIT, the value of the accelerator factor A, and
%   the categorical predictor vector CATPREDICTORS. Then, in the Command Window type:
% 		mediadaboostmain
% 	to run the demonstration script.
%
% SEE ALSO
%   mediadaboostchoosefeat, mediadaboostdrawtree, mediadaboostprunetree, mediadaboosttrain,
%   mediadaboostvalue

%% Cleaning up the workspace and closing figures
%close all
%clear all
%clc

%% Setting parameters and loading training data
% Loading Breast Cancer Wisconsin data set from uci (http://archive.ics.uci.edu/ml/)
%load data.mat

% Defining parameters for building the Mediboost tree

% Depth of the tree
depthLimit = 7;
% Accelerator factor
A = 2;

% The catPredictors vector should be true in the entries corresponding to a
% cateorical feature
catPredictors = logical(false(1,size(x,2)));
% No learning rate parameter!

% Randomly selecting a portion of the samples to be used as training data.
% We use 50% of the samples by default indicated by variable porTrain
porTrain = 0.5;

n = size(x,1);
sel = randperm(size(x,1));
xTrain = x(sel(1:round(n*porTrain)),:);
yTrain = y(sel(1:round(n*porTrain)),:);

%% Training the tree using the Mediboost paradigm

tree = mediadaboosttrain(xTrain,yTrain,catPredictors,depthLimit,A);

% Script for pruning the tree based on the elimination of child nodes 
% whose classification outputs are the same, as well as impossible paths
tree = mediadaboostprunetree(tree,{});

% Script for drawing the obtained Mediboost tree in a matlab figure
%mediadaboostdrawtree(tree)

%% Testing the tree

% Defining the testing data
xTest = x(sel(round(n/2)+1:end),:);
yTest = y(sel(round(n/2)+1:end));

%Calculating the Predicted Y for the testing set
yPredTrain = mediadaboostvalue(tree, xTrain);
yPredTest = mediadaboostvalue(tree, xTest);

% Calculating the classification error
errorTrain = sum(yPredTrain ~= yTrain)./numel(yTrain);
errorTest = sum(yPredTest ~= yTest)./numel(yTest);

display(['Classification error for training: ' num2str(errorTrain*100) ' %']);
display(['Classification error for testing: ' num2str(errorTest*100) ' %']);