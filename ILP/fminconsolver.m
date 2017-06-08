function x = fminconsolver(  G, allPathCell  )

    % calculate number of variabels (x1, x2, ... ,xn) = number of paths +
    % number of edges
    numberOfEdges = numedges(G);
    
    % calculate number of paths
    totalNumberOfPaths = 0;
    
    pathIndexes = [];
    
    [numOfSources, allPathCellColumn] = size(allPathCell);
    
    for i=1:numOfSources
        for j=2:allPathCellColumn
            
            currentCellOfPathsFromSourceToAllRecievers = allPathCell{i,j};
         
            if( not( isempty(currentCellOfPathsFromSourceToAllRecievers) ) )
                [currentNumberOfPathFromSourceToRecievers, temp] = size(currentCellOfPathsFromSourceToAllRecievers);
                totalNumberOfPaths = totalNumberOfPaths + currentNumberOfPathFromSourceToRecievers;
                
                for k = 1:currentNumberOfPathFromSourceToRecievers
                    currentPathValue = pathValue(G, currentCellOfPathsFromSourceToAllRecievers(k) );
                    pathIndexes = [pathIndexes ; [i,j,k]];
                end
            end
        end
    end

    numberOfVariabelsX = numberOfEdges + totalNumberOfPaths;
    
    % x1 is G.Edge(1)
    n = 3;
    
    % build target function to minimize
    testTargetFunction = 'fminconTF';
    if( createTargetFunction(testTargetFunction, n) == -1 ) 
    end

    targetFun = @fminconTF;
    
    % build non linear constraint function
    testConFunction = 'fminconCF';
    if( createConFunction(testConFunction, n) == -1 ) 
    end

    nonlcon = @fminconCF;
    
    % build linear constraints
    lb = zeros(1,n);
    ub = ones(1,n);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    
    % build start point x0
    x0 = double([0.1,0.1,0.1]);
 
    % run non linear solver
    [x] = fmincon(targetFun,x0,A,b,Aeq,beq,lb,ub,nonlcon);
end

