function [ totalRunTime ] = gridSimulation( )

    gridSize = [4,8];        
    %gridSize = [4,8,16,32,64,128,256];        
    rep = 10;

    totalRunTime = [];

    for N=gridSize
        
        % build grid network
        [G] = buildGridNetwork(N);
        
        % build request table from G
        [requestTable] = createEmptyRequestTable();
        [tempRequestTable] = buildRequestTable(G, requestTable);  
        requestTable = tempRequestTable;

        runTimeForN = [];
        for i = 1:rep
            % run LBSLS
            [ tempG, tempRequestTable, runTime ] = lbsls( G, requestTable );
            runTimeForN = [runTimeForN runTime];
        end
        
        totalRunTime = [totalRunTime ; runTimeForN];
       
    end
end
    
   
