function [ results ] = gridSimulation( )

    gridSize = [2:1:2];      
    rep = 1;

    results = cell2table(cell(0,5), 'VariableNames', {
        'gridSize', 
        'numOfRcv', 
        'rep', 
        'runTime',
        'LBSLdetails'});

    totalRunTime = [];
    for i=1:size(gridSize, 2)
        
        N = 2^gridSize(i);
        
        numOfRcvArray = [1, N/2, N].^2;
        rcvRunTime = [];
        for numOfRcv = numOfRcvArray                                    
            
            % build grid network
            %[G] = buildGridNetwork(N,numOfRcv);
            [G] = buildGridNetwork4x4();
            %plotNetworkGraph( G );

            % build request table from G
            [requestTable] = createEmptyRequestTable();
            [tempRequestTable] = buildRequestTable(G, requestTable);  
            requestTable = tempRequestTable;

            repRunTime = [];
            for k = 1:rep
                % run LBSLS
                %[ tempG, tempRequestTable, runTime, LBSLSresults ] = lbsls( G, requestTable );
                [ LBSLSresults ] = lbsls( G, requestTable );
                runTime=LBSLSresults.runTime(1);
                
                %disp(['routers = ' , num2str(N*N), ' users =  ',  num2str(numOfRcv) , ' rep = ' , num2str(k), ' runTime= ', num2str(runTime)]);
                
                repRunTime = [repRunTime runTime];                
                
                
                row = {N*N, numOfRcv, k, runTime, LBSLSresults};
                results = [results ; row];
                
            end

            msg = ['grid size = ', num2str(N*N), ' rcv# = ', num2str(numOfRcv)];
            disp(msg);
            
            rcvRunTime = [rcvRunTime ; repRunTime];            
        end
        
        totalRunTime = [totalRunTime ; rcvRunTime];
        
    end
end
    
   
