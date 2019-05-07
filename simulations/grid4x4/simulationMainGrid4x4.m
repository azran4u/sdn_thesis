function [ results ] = simulationMainGrid4x4()
    
    relative_path = 'sdn_thesis\simulations\grid4x4\';
    N = 4; % network is NxN    
    numOfRcvArray = [8 10 12 14 16];
    numOfSources = 3;       
    rep = 3; % number of repititons to run the simulation

    % simulation network parameters
    networkParameters = containers.Map('KeyType','char','ValueType','double');
    networkParameters('minNumOfRouters') = N*N;    
    networkParameters('maxNumOfRouters') = N*N;
    networkParameters('minEdgeRoutersRatio') = 2;
    networkParameters('maxEdgeRoutersRatio') = 4;
    networkParameters('minBw') = 60;
    networkParameters('maxBw') = 120;
    networkParameters('minLatency') = 2;
    networkParameters('maxLatency') = 6;
    networkParameters('minJitter') = 0;
    networkParameters('maxJitter') = 0;
    networkParameters('contentMinAcceptedLatency') = 0;
    networkParameters('contentMaxAcceptedLatency') = 130;
    networkParameters('contentMinAcceptedJitter') = 0;
    networkParameters('contentMaxAcceptedJitter') = 30;
    networkParameters('baseLayerMaxBW') = 3;
    networkParameters('baseLayerMinBW') = 1;
    networkParameters('baseLayerIntervalBW') = 1;
    networkParameters('enhancementLayer1MaxBW') = 6;
    networkParameters('enhancementLayer1MinBW') = 4;
    networkParameters('enhancementLayer1IntervalBW') = 1;
    networkParameters('enhancementLayer2MaxBW') = 8;
    networkParameters('enhancementLayer2MinBW') = 6;
    networkParameters('enhancementLayer2IntervalBW') = 1;
    networkParameters('numOfTotalLayersPerContent') = getGlobal_numOfLayersPerContent(); % Base layer (=0), Enhancement layer 1 (=1), Enhanacement layer 2 (=2).
    networkParameters('numOfActiveLayersPerContent') = 2; % layers for rcv's
    
    % simulation results
    results = cell2table(cell(0,5), 'VariableNames', {
        'gridSize', 
        'numOfRcv', 
        'rep', 
        'lbsResults',
        'llvsResults'});        
    
    for numOfRcv = numOfRcvArray                                    

        % build grid network     
        [G] = buildGridNetworkRouters(N, networkParameters);
        graph = plotNetworkGraph( G );
        savefig(graph, strcat(relative_path, 'grid4x4Routers.fig'));    
        close(graph);

        networkParameters('minNumOfSources') = numOfSources;
        networkParameters('maxNumOfSources') = numOfSources;        
        networkParameters('contentSourceRatio') = 1;        
        [G] = buildNetworkAddSources(G, networkParameters);
        graph = plotNetworkGraph( G );
        savefig(graph, strcat(relative_path, 'grid4x4RoutersAndSources.fig'));    
        close(graph);

        networkParameters('minNumOfRcvs') = numOfRcv;
        networkParameters('maxNumOfRcvs') = numOfRcv;
        networkParameters('numOfActiveRcvs') = numOfRcv;   
        networkParameters('rcvContentRatio') = 2;
        [G] = buildNetworkAddSubscribers(G, networkParameters);
        graph = plotNetworkGraph( G );
        savefig(graph, strcat(relative_path, 'grid4x4RoutersAndSourcesAndSubscribers.fig'));    
        close(graph);

        % build request table from G
        [requestTable] = createEmptyRequestTable();
        [tempRequestTable] = buildRequestTable(G, requestTable);  
        requestTable = tempRequestTable;        
             
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
        
        firstContent = getGlobal_firstContent();
        filename = strcat(relative_path, 'grid4x4results Nodes=', num2str(N*N), ' RCV=' , num2str(numOfRcv)); 
        save(filename,'G', 'firstContent');
        
    end                        


    
    [runTimeHandler, revenueHandler] = gridNetworkResultsGraphs(results);
    
    savefig(runTimeHandler, strcat(relative_path, 'grid4x4RunTime.fig') );    
    close(runTimeHandler);
    
    savefig(revenueHandler, strcat(relative_path, 'grid4x4Revenue.fig') );
    close(revenueHandler);

end
    
   
