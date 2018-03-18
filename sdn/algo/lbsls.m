% implementation of LBSLS algorithm
function [ G, requestTable ] = lbsls( G, requestTableInput )

    % read request table
    requestTable = requestTableInput;
           
    % sort requests by layer
    requestTable = sortrows(requestTable,{'layer'},{'ascend'});
            
    % run over all requests, base layer first, EL1 second, and so on.
    for row = 1:height(requestTable)
        
        [dk,ck,lk,valid,ck_bw,ck_maximumLatency,ck_maximumJitter] = readRequestParameters(G, requestTable , row);                                       
        
        % if the request isn't vaild skip it (Eg. don't supply EL1 if BL is not)
        if( valid ~= 1 )
            continue;
        end
        
        % P holds all possible paths
        P = cell(0);
        %P = [];
        
        % remove edges that don't meet the bandwidth requiremnt
        H = removeEdgesBelow( G, ck_bw );
        
        % get all nodes that are part of (content,layer)
        scki = getTreeNodes(G, ck , lk);
        
        for v = scki'
            
            % find shortest latency path in H
            [ path, delta_p, sigma_p ] = lowLatencyPathBetweenNodes( H, v, dk );
        
            % add latency and jitter fron v to source
            delta_p = delta_p + nodeLatencyInTree(H, v, ck, lk);
            sigma_p = sigma_p + nodeJitterInTree(H, v, ck, lk);
            
            % check if the path meets the delay and jitter requirements
            if( (delta_p < ck_maximumLatency) &&  (sigma_p < ck_maximumJitter) )           
                P = [P; {path}];
            end
                
        end
        
        % we found more than one path
        if( ~isempty(P) )
            
            % select one path from P
            path = lbslsPathSelectionAlgorithm(H, P);
            
            % serve path
            [G, requestTable] = servePath(requestTable, row, G, P, path, ck, lk, ck_bw);
            
        % we couldnt find any path
        else

            % if BL could not be served
            if( lk == 0 )
                
                % find maximum bandwudth path in G
                for v = scki'
            
                    % find shortest latency path in H
                    [ path, delta_p, sigma_p ] = maxBWPathBetweenNodes( G, v, dk );

                    % add latency and jitter fron v to source
                    delta_p = delta_p + nodeLatencyInTree(G, v, ck, lk);
                    sigma_p = sigma_p + nodeJitterInTree(G, v, ck, lk);

                    % check if the path meets the delay and jitter requirements
                    if( (delta_p < ck_maximumLatency) &&  (sigma_p < ck_maximumJitter) )           
                        P = [P; {path}];
                    end

                end
                
                % we found more than one path
                if( ~isempty(P) )
            
                    % select one path from P
                    
                    
            
                % if we can remove EL for this BL - do it and remove upper
                % layers
                
                % if we couldnt find any EL that can help this BL -
                % invalidate upper layers                              
                
            % if we couldnt serve EL
            else
                % invalidate upper layers
                            
            end                        
            
        end
            
    end       
  
end

