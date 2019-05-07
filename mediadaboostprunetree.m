function tree = mediadaboostprunetree(tree,prevDec)
% MEDIADABOOSTPRUNETREE - Returns a pruned version of the input tree based on
% the elimination of child nodes whose classification outputs are the same
% or that have impossible branches.
%
% Usage:
% 
%   tree = MEDIADABOOSTPRUNETREE(tree,prevDec)
%
%  input:
%   tree        -   binary decision tree classifier built under 
%                   the Mediboost paradigm
%   prevDec     -   cell structure that stores the information of all the
%                   previous decision nodes during the recursion process. 
%                   This value should be set to an empty cell, (i.e., {}) 
%                   value when the recursion is called
%
%  output:
%   tree        -   pruned version of the input binary decision tree
% 
% SEE ALSO
%   mediadaboostchoosefeat, mediadaboostdrawtree, mediadaboosttrain, mediadaboostvalue

    % Identifying nodes with the same condition variables. Nodes with 
    % impossible children are removed and the valid branch is pulled up 
    % one level. Nodes with possible branches are neglected. This proces is
    % carried out when the recursion goes from the top to the bottom in the
    % tree.
    if tree.right.terminal == false
        if ~isempty(tree.cutPoint)
            prevDecRight = [prevDec;{num2str(tree.fIdx),num2str(tree.cutPoint),'yes'}];
        else
            prevDecRight = [prevDec;{num2str(tree.fIdx),num2str(tree.cutCategory{2}),'yes'}];
        end
        if ismember(num2str(tree.right.fIdx),prevDecRight(:,1))
            [indix] = find(strcmp(num2str(tree.right.fIdx),prevDecRight(:,1)));
            for i = 1:numel(indix)
                if (strcmp(prevDecRight(indix(i),3),'yes'))
                    if ~isempty(tree.right.cutPoint)
                        if (tree.right.cutPoint <= str2double(prevDecRight{indix(i),2}))
                            tree.right = tree.right.right;
                        end
                    else
                        if (isequal(prevDecRight{indix(i),2},num2str(tree.right.cutCategory{2})))
                            tree.right = tree.right.right;
                        end
                    end
                else
                    if ~isempty(tree.right.cutPoint)
                        if (str2double(prevDecRight{indix(i),2}) <= tree.right.cutPoint)
                            tree.right = tree.right.left;
                        end
                    else
                        if (isequal(prevDecRight{indix(i),2},num2str(tree.right.cutCategory{2})))
                            tree.right = tree.right.left;
                        end
                    end
                end
                if tree.right.terminal == true
                    break
                end
            end
        end
        if tree.right.terminal == false
            tree.right = mediadaboostprunetree(tree.right,prevDecRight);
        end
    end
    if tree.left.terminal == false
        if ~isempty(tree.cutPoint)
            prevDecLeft = [prevDec;{num2str(tree.fIdx),num2str(tree.cutPoint),'no'}];
        else
            prevDecLeft = [prevDec;{num2str(tree.fIdx),num2str(tree.cutCategory{2}),'no'}];
        end
         if ismember(num2str(tree.left.fIdx),prevDecLeft(:,1))
            [indix] = find(strcmp(num2str(tree.left.fIdx),prevDecLeft(:,1)));
            for i = 1:numel(indix)
                if (strcmp(prevDecLeft(indix(i),3),'yes'))
                    if ~isempty(tree.left.cutPoint)
                        if (tree.left.cutPoint <= str2double(prevDecLeft{indix(i),2}))
                            tree.left = tree.left.right;
                        end
                    else
                        if (isequal(prevDecLeft{indix(i),2},num2str(tree.left.cutCategory{2})))
                            tree.left = tree.left.right;
                        end
                    end
                else
                    if ~isempty(tree.left.cutPoint)
                        if (str2double(prevDecLeft{indix(i),2}) <= tree.left.cutPoint)
                            tree.left = tree.left.left;
                        end
                    else
                        if (isequal(prevDecLeft{indix(i),2},num2str(tree.left.cutCategory{2})))
                            tree.left = tree.left.left;
                        end
                    end
                end
                if tree.left.terminal == true
                    break
                end
            end
        end
        if tree.left.terminal == false
            tree.left = mediadaboostprunetree(tree.left,prevDecLeft);
        end
    end
    
    % If both subbranches are endpoints, verify if they can be merged. This
    % process is carried out when the recursion goes from the bottom to the
    % top of the tree.
    if tree.right.terminal == true && tree.left.terminal == true
        if sign(tree.right.value) == sign(tree.left.value)
            % Merging the branches with same classification output
            tree.value = sign(tree.right.value);
            tree.right = []; 
            tree.left = [];
            tree.fIdx = [];
            tree.cutPoint = [];
            tree.cutCategory = [];
            tree.terminal = true;
        end     
    end