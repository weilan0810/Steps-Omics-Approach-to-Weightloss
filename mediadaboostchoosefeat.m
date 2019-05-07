function [fIdx,cutPoint,cutCategory] = mediadaboostchoosefeat(x,y,catPredictors,weight,colIdx)
% MEDIADABOOSTCHOOSEFEAT - Selects a feature with maximum information
% gain and provides the decision values and column index for the chosen 
% feature
%
% Usage:
% 
% [fIdx,cutPoint,cutCategory] = MEDIADABOOSTCHOOSEFEAT(x, y, catPredictors, funcValue, weight, colIdx)
%
%  inputs:
%   x               -   N x D matrix of N examples with D features
%   y               -   N x 1 vector of labels with values in {-1,1}
%   catPredictors   -   Logical vector with the same length as the feature
%                       vector, where a true entry means that the corresponding column of x is
%                       a categorical variable
%   weight          -   distributions of observatios
%   colIdx          -   the indices of features (columns) under consideration
%
%  outputs:
%   fIdx            -   index of the feature with maximum information gain
%   cutPoint        -   decision value of feature with maximum information gain
%   cutCategory     -   decision value of category with maximum information gain
% 
% SEE ALSO
%   mediadaboostdrawtree, mediadaboostprunetree, mediadaboosttrain, mediadaboostvalue

%initializing the variables
cutPoint = []; 
cutCategory = {};

% Choosing the split by first creating a tree using the Matlab function
% fitrtree and checking if the split was on a categorical or 
% continuos variable
tree = fitrtree(x(:,colIdx),y,'CategoricalPredictors',catPredictors(:,colIdx),'Weights',weight);

% Getting the feature where the split was made
fIdx = colIdx(strcmp(tree.PredictorNames,tree.CutVar{1}));

% Classifying the split as categorical or continous
if strcmp(tree.CutType{1},'continuous')
    cutPoint = tree.CutPoint(1);
else
   cutCategory = tree.CutCategories(1,:);
end