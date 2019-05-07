function mediadaboostdrawtree(tree)
% MEDIADABOOSTDRAWTREE(tree) Returns the diagram of a decision tree object 
% created under the MediAdaBoost paradigm. For more information see:
%
% VALDES Gilmer, LUNA Jos�, EATON Eric, UNGAR Lyle, SIMONE Charles 
% and SOLDBERG Timothy. MediBoost: a Patient Stratification Tool for 
% Interpretable Decision Making in the Era of Precision Medicine. Under 
% Review. 2016.
%
% This MATLAB script is based on "Modeling with Decision Trees" 
% chapter of:
%
% SEGARAN, Toby. Programming collective intelligence: building smart web 
% 2.0 applications. " O'Reilly Media, Inc.", 2007.
%
%
% SEE ALSO
%   mediadaboostchoosefeat, mediadaboostprunetree, mediadaboosttrain, mediadaboostvalue

    % Recursion to calculate the width and the depth of the tree in 
    % pixels based on its actual number of nodes and its actual depth
    width = mediadaboostgetwidth(tree)*100 + 120;
    depth = mediadaboostgetdepth(tree)*100 + 120;

    % Setting up axis to draw the decision tree
    figure1 = figure('Name','Decision Tree Example','Position',[0 40 1300 600]);
    axes('Parent',figure1);
    % Setting the limits to the calculated width and depth in pixels
    xlim([0 width]);
    ylim([0 depth]);
    hold('all');
    title('demo step data  ');

    % Recursion to draw each node at the appropriate scale
    mediadaboostdrawnode(tree,width/2,depth-80)

    % Printing the line conventions for the 'yes' and 'no' answers to the
    % condition values
    text(width-500,depth,sprintf('yes'));
    line([width-300 width],[depth depth],'Color',[0 0 1],'LineWidth',1)
    text(width-500,depth-30,sprintf('no'));
    line([width-300 width],[depth-20 depth-20],'Color',[1 0 0],'LineWidth',1)
    text(width-700,depth-80,sprintf('An = Attribute in n-th row of the table'));
    axis off
    % Defining the problem dependent features to publish them in a uitable
    cnames= {'Attribute','Value'};
    rnames = {'1','2','3','4','5'};
    data = {'Group','0/1';...
        'Age','1 - 100';...
        'Gender','0/1';...
        'BMI','1 - 100';...
        'Steps','3000 - 20000';...
         };
        %%%'hsa03040-mean','';...
        %%%'hsa03040-variance','';...
        %%%'hsa03050-mean','';...
        %%%'hsa03050-variance','';...
        %%%'hsa03060-mean','';...
        %%%'hsa03060-variance','';...
        %%%'hsa04130-mean','';...
        %%%'hsa04130-variance','';... 
        %%%'hsa04141-mean','';...
        %%%'hsa04141-variance','';...
        %%%'hsa04662-mean','';...
        %%%'hsa04662-variance','';... 
        %%%'hsa05220-mean','';...
        %%%'hsa05220-variance','';...

    
    % Showing the uitable
    t = uitable(figure1,'Data',data,'ColumnWidth',{127},'ColumnName',cnames,'RowName',rnames,'Position',[0,405,100,100]);
    t.Position(3) = t.Extent(3);
    t.Position(4) = t.Extent(4);

    % recursive function to draw the lines of the tree
    function mediadaboostdrawnode(tree,x,y)
        if tree.terminal==0
            % Get the width of each branch
            width1 = mediadaboostgetwidth(tree.left)*100;
            width2 = mediadaboostgetwidth(tree.right)*100;

            % Determine the total space required by this node
            left = x - (width1 + width2)/2;
            right = x + (width1 + width2)/2;

            % Draw the condition string
            if ~isempty(tree.cutPoint)
                text(x-100,y-10,['A' num2str(tree.fIdx) '>' num2str(tree.cutPoint) '?'],'FontSize',9);
            else
                cutCat=sprintf('%.0f,',tree.cutCategory{2});cutCat = cutCat(1:end-1);
                text(x-100,y-10,['A' num2str(tree.fIdx) '\in\{' cutCat '\}?'],'FontSize',9);
            end

            % Draw links to the branches
            line([x,left + width1/2],[y - 20,y - 120],'Color',[1 0 0],'LineWidth',1);
            line([x,right - width2/2],[y - 20,y - 120],'Color',[0 0 1],'LineWidth',1);

            % Draw the branch nodes
            mediadaboostdrawnode(tree.left,left + width1/2,y - 100);
            mediadaboostdrawnode(tree.right,right - width2/2,y - 100);
        else
            txt = sprintf('\n\n%d',sign(tree.value));
            text(x - 20,y,txt);
        end
    end

    % Recursive function that returns the width of the tree
    function width = mediadaboostgetwidth(tree)
        % The total width of a branch is the combined width of its child
        % branches, or 1 if it has none.
        if isempty(tree.right) && isempty(tree.left)
            width = 1;
        else
            width = mediadaboostgetwidth(tree.right) + mediadaboostgetwidth(tree.left);
        end
    end

    % Reccursive function that returns the depth of the tree
    function depth = mediadaboostgetdepth(tree)
        % The depth of a branch is 1 plus the total depth of its longest child
        % branch.
        if isempty(tree.right) && isempty(tree.left)
            depth = 0;
        else
            depth = max(mediadaboostgetdepth(tree.right),mediadaboostgetdepth(tree.left)) + 1;
        end
    end
end