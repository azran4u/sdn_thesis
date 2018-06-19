function [ totalRunTime ] = gridSimulation( )

    gridSize = [3:1:3];        
    numOfRcvRatio = [1/64:3/64:1];
    %gridSize = [4,8,16,32,64,128,256];        
    rep = 1;

    totalRunTime = [];
    for i=1:size(gridSize, 2)
        
        N = 2^gridSize(i);
        
        rcvRunTime = [];
        for j = 1:size(numOfRcvRatio, 2)
                        
            numOfRcv = ceil(N*N*numOfRcvRatio(j));
            
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
                repRunTime = [repRunTime runTime];
                disp(['routers = ' , num2str(N*N), ' users =  ',  num2str(numOfRcv) , ' rep = ' , num2str(k)]);
            end

            rcvRunTime = [rcvRunTime ; repRunTime];            
        end
        
        totalRunTime = [totalRunTime ; rcvRunTime];
        
    end
end
    
   
