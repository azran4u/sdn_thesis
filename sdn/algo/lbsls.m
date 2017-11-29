function [ G, requestTable ] = lbsls( G )

    % remove all served layers above BL from G
    
    
    % run LBS algorithm
    
    % 
    
    % global variables - number of layers per content
    setGlobal_numOfLayersPerContent(3);

    % build request table
    % columns - {reciever, content, layer, bw}
    % go over all recievers and populate table
    requestTable = buildRequestTable(G);
           
    % remove 
    requestTable = sortrows(requestTable,{'layer'},{'ascend'});
    
    % matlab uses only 'Weight' variable as cost so we set it 
    G.Edges.Weight = G.Edges.latency;
    
    % run over all requests, base layer first, EL1 second, and so on.
    for row = 1:height(requestTable)
        
        % get request parameters
        gama_k_i = requestTable(row, :);
        dk = gama_k_i.reciever;
        ck = gama_k_i.content;
        lk = gama_k_i.layer;
        valid = gama_k_i.valid;
        ck_bw = gama_k_i.bw;
                
        % if the request isn't vaild (Eg. don't supply EL1 if BL is not)
        if( valid ~= 1 )
            continue;
        end
        
        % remove all edges that don't conform the bw requierment
        H = removeEdgesBelow( G, ck_bw );
           
        % P holds all paths we find, delta_P holds the corresponding
        % latencies
        P = {};
        delta_P = [];
        minLatency = 0;
        IndexOfMinLatencyPath = 0;
            
        % get all nodes that are part of (content,layer)
        scki = getTreeNodes(G, ck , lk);
        
        % count the number of paths we found fo current ck,lk
        numberOfPathsFound = 0;
        
        % run over each node the content traverse thru and find the
        % distance (latency) from receiver
        for v = scki'
            
            % find shortest path (minimum latency) from  source/content to reciever       
            % p : shortest path
            % delta_p : latency of p
            [p,delta_p] = shortestpath(H,v,dk);
            
            % update P if path is not empty
            if ~isempty(p)
                
                % increase the counter of number of found paths
                numberOfPathsFound = numberOfPathsFound + 1;
                
                % add path to P and delta_P
                P{1,numberOfPathsFound} = p;
                delta_P(numberOfPathsFound) = delta_p;
                                
            end
  
        end
        
        % here, we finished to find all possible paths for current request

        % if we couldn't  find any paths we skip upper layers
        if isempty(P)        
            
            % set current layer and upper layers as in valid
            for lk_i = lk:getGlobal_numOfLayersPerContent()
                rowToInvalid = requestTable.reciever==dk & requestTable.content==ck & requestTable.layer==lk_i;
                requestTable.valid(rowToInvalid) = 0;
            end
            
    
        % if we did find one or more paths    
        else        
            
            % choose the path with minimum latency
            [minLatency IndexOfMinLatencyPath] = min(delta_P);
            p = P{1,IndexOfMinLatencyPath};
            
            % add found paths to request table                        
            requestTable.allPathsFound(row) = {P};
            requestTable.allPathsFoundLatencies(row) = {delta_P};
            requestTable.selectedPath(row) = {p};
            requestTable.selectedPathLatency(row) = minLatency;
            
            % update the relevant tree in G with p
            index = treeIndex(getGlobal_firstContent(),getGlobal_numOfLayersPerContent(), ck, lk);
            G = updateAvialableBW(G, index, p, ck_bw);
            
        end        

    end
    
end












