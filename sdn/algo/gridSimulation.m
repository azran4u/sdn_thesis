function [ results ] = gridSimulation( )

    gridSize = [1:1:1];      
    rep = 3;

    results = cell2table(cell(0,5), 'VariableNames', {
        'gridSize', 
        'numOfRcv', 
        'rep', 
        'lbsResults',
        'llvsResults'});

    totalRunTime = [];
    for i=1:size(gridSize, 2)
        
        N = 4;
        numOfRcvArray = [8 10 12 14 16];
        
%          N = 14;                
%          numOfRcvArray = [16 98 196];

%          N = 6;                
%          numOfRcvArray = [9 18 36];

        rcvRunTime = [];
        for numOfRcv = numOfRcvArray                                    
            
            % build grid network
            %[G] = buildGridNetwork(N,numOfRcv);
            [G] = buildGridNetwork4x4(numOfRcv);
            
            %plotNetworkGraph( G );

            % build request table from G
            [requestTable] = createEmptyRequestTable();
            [tempRequestTable] = buildRequestTable(G, requestTable);  
            requestTable = tempRequestTable;

            repRunTime = [];
            for k = 1:rep
                % run LBSLS                
                [ lbsResults ] = lbs( G, requestTable );
         
                % run LLVS
                [ llvsResults ] = llvs( G, requestTable );
                                   
                row = {N*N, numOfRcv, k, lbsResults, llvsResults};
                results = [results ; row];
                
                msg = ['grid size = ', num2str(N*N), ' rcv# = ', num2str(numOfRcv), ' rep# = ', num2str(k)];
                disp(msg);                   
            end                            
        end                        
    end
end
    
   
