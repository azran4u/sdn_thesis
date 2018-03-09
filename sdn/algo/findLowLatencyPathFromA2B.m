% find minimum latency path between two nodes in G while path bandwidth > bw.
% the tree index is input so we can find end to end latencies and jitter.

% for each path return:
% full path, e2e latency, e2e jitter, e2e maximum available bandwidth, e2e hop count
% if no path found, isempty(path)=true
function [ pathProperties ] = findLowLatencyPathFromA2B( G, source, destination, bw, sckiTree )

    pathProperties = cell2table(cell(0,7), 'VariableNames', {
        'source', 
        'destination', 
        'path',
        'latency', 
        'jitter', 
        'maximumAvailableBW', 
        'hopCount'});

    path = [];
    latency = inf;
    jitter = inf;
    maximumAvailableBW = 0;
    hopCount = inf;
                
    % matlab uses only 'Weight' variable as cost so we set it 
    G.Edges.Weight = G.Edges.latency;
        
    % remove all edges that don't conform the bw requierment
    H = removeEdgesBelow( G, bw );

    % find shortest path (minimum latency) from  source/content to reciever       
    [path,latency] = shortestpath(H,source,destination);

    % if we found nothing, continue
    if( isempty(path) )                                
        pathProperties = {source, destination, path, latency, jitter, maximumAvailableBW, hopCount};               
        return;
    end

    % find path's latency from dk--->v + v--->ck
    latency = latency + G.Nodes.treeLatency(v,sckiTree);
            
            % find path's jitter
            sigma_p = 0;
            for i = 1:(size(path,2)-1)
                sigma_p = sigma_p + G.Edges.jitter(findedge(G,path(i),path(i+1)));
            end
                
            % find path's jitter from dk--->v + v--->ck
            sigma_p = sigma_p + G.Nodes.treeJitter(v,sckiTree);
            
            % check if the path meets the delay and jitter requirements
            if( latency > ck_maximumLatency ) 
                continue
            end
                
            if (sigma_p > ck_maximumJitter) 
                continue
            end
                    
            % check if the path's latency meets the decodable constraint
            if(lk>0)

                % build a query
                baseLayer = requestTable.content == ck & requestTable.reciever == dk & requestTable.layer==0;

                % perform the query and get the latnecy of the base layer
                baseLayerLatency = requestTable.selectedPathLatency(baseLayer);
                
                % check if the latency gap from base layer is too high
                if( abs(latency - baseLayerLatency)  > maxDecodableLatencyThreshold  )
                    continue
                end
                        
            end
        
            % we found a valid path - add it!

            % increase the counter of number of found paths
            numberOfPathsFound = numberOfPathsFound + 1;

            % add path to P and delta_P
            P{1,numberOfPathsFound} = path;
            delta_P(numberOfPathsFound) = latency;
            sigma_P(numberOfPathsFound) = sigma_p;             
        
        end
        
        % here, we finished to find the best path for each node in the
        % current tree scki.
        
        % if P is empty, we couldn't  find any paths we skip upper layers
        if isempty(P)        

            % if we couldn't find path for base layer, try removing EL's
            
            
            % set current layer and upper layers as invalid
            for lk_i = lk:getGlobal_numOfLayersPerContent()
                rowToInvalid = requestTable.reciever==dk & requestTable.content==ck & requestTable.layer==lk_i;
                requestTable.valid(rowToInvalid) = 0;
            end

        % if we did find one or more paths    
        else        
          
            % choose the path with minimum latency
            [minLatency , IndexOfMinLatencyPath] = min(delta_P);                                    
            minLatencyPathsIndices = delta_P==minLatency;
            
            % if we found more than one path with minimum latency pick the shortest
            % one (hop count)
            if( size(minLatencyPathsIndices, 2) > 1 )
                
                shortestPathIndex = 0;
                shortestPathLength = inf;
                currentIndex = 0;
                
                allIndexes = delta_P==minLatency;
                for i = allIndexes
                    currentIndex = currentIndex + 1;
                    if(i==1) % one of the shortest path we found
                        
                        % calc it's length
                        currentPathLength = size(P{1,currentIndex},2);
                        
                        % check if the length is shorter than we know
                        if(currentPathLength < shortestPathLength)
                            shortestPathIndex = currentIndex;
                            shortestPathLength = currentPathLength;
                        end
                    end
                end
                % pick the shortest length path
                p = P{1,shortestPathIndex};
            else
                % pick the only path found
                p = P{1,IndexOfMinLatencyPath};
            end
                        
            % add found paths to request table                        
            requestTable.allPathsFound(row) = {P};
            requestTable.allPathsFoundLatencies(row) = {delta_P};
            requestTable.allPathsFoundJitters(row) = {sigma_P};
            requestTable.selectedPath(row) = {p};
            requestTable.selectedPathLatency(row) = minLatency;
            requestTable.selectedPathJitter(row) = sigma_P(IndexOfMinLatencyPath);

            % update the relevant tree in G with p
            index = treeIndex(ck, lk);
            G = updateAvialableBW(G, index, p, ck_bw);

        end        
    
    end
end

