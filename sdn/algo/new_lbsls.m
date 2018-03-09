% implementation of LBSLS algorithm
function [ G, requestTable ] = new_lbsls( G, requestTableInput )

    % read request table
    requestTable = requestTableInput;
           
    % sort requests by layer
    requestTable = sortrows(requestTable,{'layer'},{'ascend'});
       
    
       
    % run over all requests, base layer first, EL1 second, and so on.
    for row = 1:height(requestTable)
        
        request = readRequestParameters(G, requestTable , row);                       
        
        % if the request isn't vaild skip it (Eg. don't supply EL1 if BL is not)
        if( request.valid ~= 1 )
            continue;
        end
        
        % P holds all possible paths
        P = [];
        
        % remove edges that don't meet the bandwidth requiremnt
        H = removeEdgesBelow( G, ck_bw );
        
        % get all nodes that are part of (content,layer)
        scki = getTreeNodes(G, ck , lk);
        
        for v = scki'
            
            shortestLatencyPath = findLowLatencyPathFromA2B( G, request.ck, request.dk, request.ck_bw, sckiTree, request.ck_maximumLatency, request.ck_maximumJitter );
            
            % check if the path meets the delay and jitter requirements
            if( (delta_p > ck_maximumLatency) &&  (sigma_p > ck_maximumJitter) )
                P = [P shortestLatencyPath];
            end
                
        end
        
        % if we found nothing, continue
        if( isempty(P) )
            
            % if BL could not be served
            if( layer == 0 )
                
                % try removing EL's
                for v = scki'
            
                    % find shortestusing the original
                    shortestLatencyPath = findLowLatencyPathFromA2B( G, request.ck, request.dk, request.ck_bw, sckiTree, request.ck_maximumLatency, request.ck_maximumJitter );
            
            % check if the path meets the delay and jitter requirements
            if( (delta_p > ck_maximumLatency) &&  (sigma_p > ck_maximumJitter) )
                P = [P shortestLatencyPath];
            end
                
        end
                
                path = layerSwitchingStrategy();
                
                if( isempty(path) )
                    
                end
                
                
                
            else
                
            end
            
        end
        
            % find shortest path (minimum latency) from  source/content to reciever       
            % p : shortest path
            % delta_p : latency of p from dk--->v
            [p,delta_p] = shortestpath(H,v,dk);
            

            
            % find path's latency from dk--->v + v--->ck
              delta_p = delta_p + G.Nodes.treeLatency(v,sckiTree);
            
            % find path's jitter
            sigma_p = 0;
            for i = 1:(size(p,2)-1)
                sigma_p = sigma_p + G.Edges.jitter(findedge(G,p(i),p(i+1)));
            end
                
            % find path's jitter from dk--->v + v--->ck
            sigma_p = sigma_p + G.Nodes.treeJitter(v,sckiTree);
            
            
                    
            % check if the path's latency meets the decodable constraint
            if(lk>0)

                % build a query
                baseLayer = requestTable.content == ck & requestTable.reciever == dk & requestTable.layer==0;

                % perform the query and get the latnecy of the previous layer
                baseLayerLatency = requestTable.selectedPathLatency(baseLayer);
                
                % check if the latency gap from base layer is too high
                if( abs(delta_p - baseLayerLatency)  > maxDecodableLatencyThreshold  )
                    continue
                end
                        
            end
        
            % we found a valid path - add it!

            % increase the counter of number of found paths
            numberOfPathsFound = numberOfPathsFound + 1;

            % add path to P and delta_P
            P{1,numberOfPathsFound} = p;
            delta_P(numberOfPathsFound) = delta_p;
            sigma_P(numberOfPathsFound) = sigma_p;             
        
        end
        
        
        
        
            % if we found nothing
            if( isempty(pathProperties.path) )
                
                % if BL could not be served
                if( request.lk == 0 )
                    find EL we can get out
                end
                
                continue
            end
            
            % check if the path's latency meets the decodable constraint
            if( ~isDecodable(pathProperties) )
                continue
            end
            
                    
            % check if the path's latency meets the decodable constraint
            if(lk>0)

                % build a query
                baseLayer = requestTable.content == ck & requestTable.reciever == dk & requestTable.layer==0;

                % perform the query and get the latnecy of the base layer
                baseLayerLatency = requestTable.selectedPathLatency(baseLayer);
                
                % check if the latency gap from base layer is too high
                if( abs(delta_p - baseLayerLatency)  > maxDecodableLatencyThreshold  )
                    continue
                end
                        
            end
        
            % we found a valid path - add it!

            % increase the counter of number of found paths
            numberOfPathsFound = numberOfPathsFound + 1;

            % add path to P and delta_P
            P{1,numberOfPathsFound} = p;
            delta_P(numberOfPathsFound) = delta_p;
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

