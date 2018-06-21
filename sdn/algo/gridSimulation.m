function [ totalRunTime ] = gridSimulation( )

    gridSize = [2:1:2];      
    numOfRcvArray = [4,5,6,7,8];
    rep = 5;

    totalRunTime = [];
    for i=1:size(gridSize, 2)
        
        N = 2^gridSize(i);
        
        rcvRunTime = [];
        for numOfRcv = numOfRcvArray                                    
            
            % build grid network
            [G] = buildGridNetwork(N,numOfRcv);
            %plotNetworkGraph( G );

            % build request table from G
            [requestTable] = createEmptyRequestTable();
            [tempRequestTable] = buildRequestTable(G, requestTable);  
            requestTable = tempRequestTable;

            repRunTime = [];
            for k = 1:rep
                % run LBSLS
                [ tempG, tempRequestTable, runTime ] = lbsls( G, requestTable );
                disp(['routers = ' , num2str(N*N), ' users =  ',  num2str(numOfRcv) , ' rep = ' , num2str(k), ' runTime= ', num2str(runTime)]);
                repRunTime = [repRunTime runTime];                
            end

            rcvRunTime = [rcvRunTime ; repRunTime];            
        end
        
        totalRunTime = [totalRunTime ; rcvRunTime];
        
    end
end
    
   
