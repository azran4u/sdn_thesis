function [ results ] = LLVSgridSimulation( )

    gridSize = [2:1:8];      
    rep = 3;

    results = cell2table(cell(0,7), 'VariableNames', {
        'gridSize', 
        'numOfRcv', 
        'rep', 
        'LBSLSrunTime',
        'LBSLSdetails',
        'LLVSrunTime',
        'LLVSdetails'});
    
    for i=1:size(gridSize, 2)
        
        N = 2^gridSize(i);
        
        numOfRcvArray = [N].^2;
        %numOfRcvArray = [1, N/2, N].^2;

        for numOfRcv = numOfRcvArray                                                

            test = 0;

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
            
            for k = 1:rep
                
                [ LLVSresults ] = LLVS( G, requestTable );                                                
                [ LBSLSresults ] = lbsls( G, requestTable );                                
                
                row = {N*N, numOfRcv, k, LBSLSresults.runTime(1), LBSLSresults, LLVSresults.runTime(1), LLVSresults};
                results = [results ; row];
                                
                msg = ['grid size = ', num2str(N*N), ' rcv# = ', num2str(numOfRcv), ' rep =', num2str(k)];
                disp(msg);
                
            end
                       
        end        
        
    end
    
end
    
   
