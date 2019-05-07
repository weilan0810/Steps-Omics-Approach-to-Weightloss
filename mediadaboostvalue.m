function yPred = mediadaboostvalue(tree, x)
% MEDIADABOOSTVALUE - Get the value of the decision tree given an input of  
% features. For more information see:
%
% VALDES Gilmer, LUNA José, EATON Eric, UNGAR Lyle, SIMONE Charles 
% and SOLDBERG Timothy. MediBoost: a Patient Stratification Tool for 
% Interpretable Decision Making in the Era of Precision Medicine. Under 
% Review. 2016.
%
%   yPred = MABVALUE(tree, x)
%
%  inputs:
%   tree    -   binary decision tree classifier built under 
%               the Mediboost paradigm
%   x       -   N x D matrix of N examples with D features
%
%  output:
%   yPred   -   Logical prediction of a binary classifier using the
%               Mediboost paradigm
% 
% SEE ALSO
%   mediadaboostchoosefeat, mediadaboostdrawtree, mediadaboostprunetree, mediadaboosttrain

number_samples = size(x,1);
yPred = ones(size(x,1),1);

for i=1:number_samples
    node = tree; % Start at root    
    x_i = x(i,:);
    while  ~isempty(node) && ~node.terminal 
       
          if ~isempty(node.cutPoint)  
                if   x_i(node.fIdx) < node.cutPoint && ~isempty(node.left)                   
                     node = node.left;                                                 
                elseif ~isempty(node.right) && ~isempty(node.right)   
                     node = node.right;
                else
                    break;
                end                            
          else
                if  ismember(x_i(node.fIdx),node.cutCategory{1,1}) && ~isempty(node.left) 
                    node = node.left;
                elseif ~isempty(node.right)
                    node = node.right;
                else
                    break;
                end
          end
                                      
    end    
    % Caculating the prediction
    yPred(i) = sign(node.value); 
end