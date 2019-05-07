function node = mediadaboosttrain(x,y,catPredictors,depthLimit,A)
% MEDIADABOOSTTRAIN - Trains a binary decision tree classifier under the
% MediAdaBoost paradigm. For more information see:
%
% VALDES Gilmer, LUNA Jos�, EATON Eric, UNGAR Lyle, SIMONE Charles 
% and SOLDBERG Timothy. MediBoost: a Patient Stratification Tool for 
% Interpretable Decision Making in the Era of Precision Medicine. Under 
% Review. 2016.
%
%   node = MEDIADABOOSTTRAIN(x, y, depthLimit, learningRate, A)
%
%  inputs:
%   x               -   N x D matrix of N examples with D features
%   y               -   N x 1 vector of labels with values in {-1,1}
%   catPredictors   -   Logical vector with the same length as the feature
%                       vector, where a true entry means that the corresponding column of x is
%                       a categorical variable
%   depthLimit      -   maximum depth of the tree
%   A               -   acceleration factor
%
% Returns a linked hierarchy of structs with the following fields:
%
%   node.terminal               -   Logical variable that indicates whether or not this 
%                                   node is a terminal (leaf) node
%   node.fIdx, node.cutPoint    -   variables used to carry out the feature 
%   node.cutCategory                based tests associated with this node.
%                                   If the features are continuous then the
%                                   test is (is x(fIdx) > cutPoint?) if
%                                   the features are categorical the test is
%                                   (is x(fIdx) in cutCategory{2}?) 
%   node.weights                -   Double variable that stores the weight of each 
%                                   observation for each node
%   node.beta                   -   Double variable that stores the coefficients 
%                                   of the assembled base learners
%   node.value                  -   Double variable that stores the summation of all 
%                                   weights of the parent nodes and the current node
%   node.left                   -   Struct of the child node on left branch (f <= value)
%   node.right                  -   Struct of the child node on right branch (f > value)
% 
% SEE ALSO
%   mediadaboostchoosefeat, mediadaboostdrawtree, mediadaboostprunetree, mediadaboostvalue

    % Initial distribution values
    weights = ones(numel(y),1);

    % Initial node values
    nodeValue = 0;

    % Normalization of weights
    weights = exp(log(weights) - log(sum(weights)));

    % Recursive function to build tree.
    node = mediadaboostsplitnode(x,y,weights,catPredictors,nodeValue,1:size(x,2),0,depthLimit,A);
end

    
    
 function [node] = mediadaboostsplitnode(x,y,weights,catPredictors,nodeValue,colIdx,depth,depthLimit,A)
% MEDIADABOOSTSPLITNODE - Recursive function that returns a node structure under
% the MediAdaBoost paradigm. For more information see:
%
% VALDES Gilmer, LUNA Jos�, EATON Eric, UNGAR Lyle, SIMONE Charles 
% and SOLDBERG Timothy. MediBoost: a Patient Stratification Tool for 
% Interpretable Decision Making in the Era of Precision Medicine. Under 
% Review. 2016.
%    
% node = MEDIADABOOSTSPLITNODE(x, y, weights, catPredictors, nodeValue, colIdx, depth, depthLimit, A)
%  
%  inputs: 
%   x               -   N x D matrix of N examples with D features
%   y               -   N x 1 vector of labels with values in {-1,1}
%   weights         -   Double variable that stores the weight of each 
%                       observation for each node
%   catPredictors   -   Logical vector with the same length as the feature
%                       vector, where a true entry means that the corresponding column of x is
%                       a categorical variable
%   nodeValue       -   the default value of the node if y is empty
%   colIdx          -   the indices of features (columns) under consideration
%   depth           -   current depth of the tree
%   depthLimit      -   maximum depth of the tree
%   A               -   acceleration factor
%
% Returns a linked hierarchy of structs with the following fields:
%
%   node.terminal               -   Logical variable that indicates whether or not this 
%                                   node is a terminal (leaf) node
%   node.fIdx, node.cutPoint    -   variables used to carry out the feature 
%   node.cutCategory                based tests associated with this node.
%                                   If the features are continuous then the
%                                   test is (is x(fIdx) > cutPoint?) if
%                                   the features are categorical the test is
%                                   (is x(fIdx) in cutCategory{2}?) 
%   node.weights                -   Double variable that stores the weight of each 
%                                   observation for each node
%   node.beta                   -   Double variable that stores the coefficients 
%                                   of the assembled base learners
%   node.value                  -   Double variable that stores the summation of all 
%                                   weights of the parent nodes and the current node
%   node.left                   -   Struct of the child node on left branch (f <= value)
%   node.right                  -   Struct of the child node on right branch (f > value)


    % Indexes of the observations with weights different than zero
    idWeightsN0 = (weights ~= 0);

    % Normalizing weights
    weights = exp(log(weights) - log(sum(weights)));

    % Evaluating if the depth limit has been reached
    if depth == depthLimit ||  numel(colIdx) == 0  ||  all(y(idWeightsN0) == -1) || all(y(idWeightsN0) == 1)

        node.terminal = true;
        node.fIdx = [];
        node.cutPoint = [];
        node.cutCategories = [];
        node.weights = weights;
        node.beta = [];
        node.value = nodeValue;              
        node.left = []; 
        node.right = [];          

    else  

        % Choosing a feature to split on using regression of the first derivative of the loss function.
        [node.fIdx,node.cutPoint,node.cutCategories] = mediadaboostchoosefeat(x,y,catPredictors,weights,colIdx);    

        if ~isempty(node.cutPoint) || ~isempty(node.cutCategories)

            % Declaring the node no terminal  
            node.terminal = false;
            node.weights = weights;  
            node.value = nodeValue;      

            % Splitting the data based on this feature.
            if ~isempty(node.cutPoint)                         
                leftIdx = x(:,node.fIdx) < node.cutPoint;
                rightIdx = x(:,node.fIdx) >= node.cutPoint;
            else            
                leftIdx = ismember(x(:,node.fIdx),node.cutCategories{1,1});
                rightIdx = ismember(x(:,node.fIdx),node.cutCategories{1,2});
            end

            % Calculate the observation weights and the node coefficients
            % Calculate left and right predictions
            leftY = y(leftIdx);
            leftWeights = node.weights(leftIdx);
            rightY = y(rightIdx);
            rightWeights = node.weights(rightIdx);
            leftClassification = sign(leftWeights'*leftY);
            rightClassification = sign(rightWeights'*rightY);

            %initialize the classification
            yClassification = y;
            yClassification(leftIdx) = leftClassification;
            yClassification(rightIdx) = rightClassification;

            %calculating the default beta
            error = node.weights'*(y ~= yClassification);
            node.beta = 0.5 * log((1 - error)./error);

            %Assigning 1 to the ones that are in the left and -1 to the others
            leftRule = y;
            leftRule(leftIdx) = 1; 
            leftRule(rightIdx) = -1;

            %Assigning 1 to the ones that are in the right and -1 to the others
            rightRule = y;
            rightRule(leftIdx) = -1;
            rightRule(rightIdx) = 1;

            %Updating the node values
            nodeValueLeft = node.value  + node.beta .* leftClassification;
            nodeValueRight = node.value + node.beta .* rightClassification;

            %Calculate the Left weights
            leftWeights = node.weights .* ( exp( - node.beta.*y.*yClassification + (leftRule-1).*A./2 ));           
            %processing the wights for numerical instability
            leftWeights = exp( log(leftWeights)-log(sum(leftWeights)));

            %Calculate the Right weights
            rightWeights = node.weights .* ( exp(-node.beta.*y.*yClassification + (rightRule-1).*A./2 ));           
            %processing the wights for numerical instability
            rightWeights = exp( log(rightWeights)-log(sum(rightWeights)));

            %Creating the right and left terminal nodes           
            node.right = mediadaboostsplitnode(x,y,rightWeights,catPredictors,nodeValueRight,1:size(x, 2),depth+1,depthLimit,A);
            node.left =  mediadaboostsplitnode(x,y,leftWeights,catPredictors,nodeValueLeft,1:size(x, 2),depth+1,depthLimit,A);        

        else  

            %If no split was found declare the node a terminal and exit 
            node.terminal = true;
            node.fIdx = [];
            node.cutPoint = [];
            node.cutCategories = [];
            node.weight = weight;
            node.beta = [];
            node.value = nodeValue;            
            node.left = []; 
            node.right = []; 
            return;
        end
    end
end