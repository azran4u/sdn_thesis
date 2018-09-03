function [ results ] = LLVSgridSimulation( )

    gridSize = [2:1:2];      
    rep = 5;

    results = cell2table(cell(0,5), 'VariableNames', {
        'gridSize', 
        'numOfRcv', 
        'rep', 
        'runTime',
        'LBSLdetails'});

    totalRunTime = [];
    for i=1:size(gridSize, 2)
        
        N = 2^gridSize(i);
        
        numOfRcvArray = [N].^2;
        %numOfRcvArray = [1, N/2, N].^2;
        rcvRunTime = [];
        for numOfRcv = numOfRcvArray                                                

            test = 1;

            if(test == 0)
                % build grid network
                [G] = buildGridNetwork(N,numOfRcv);
                firstContent = getGlobal_firstContent();
                save('LLVSgrid','G', 'firstContent');
            end

            if(test == 1)
                load('LLVSgrid','G', 'firstContent');
                setGlobal_firstContent(firstContent);    
            end
                                    
            %plotNetworkGraph( G );
            
            % build request table from G
            [requestTable] = createEmptyRequestTable();
            [tempRequestTable] = buildRequestTable(G, requestTable);  
            requestTable = tempRequestTable;

            repRunTime = [];
            for k = 1:rep
                % run LBSLS
                %[ tempG, tempRequestTable, runTime, LBSLSresults ] = lbsls( G, requestTable );
                [ LBSLSresults ] = LLVS( G, requestTable );
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
    
   
