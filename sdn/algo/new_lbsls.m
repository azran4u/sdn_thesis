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
            
            % find shortest latency path in H
            [ path, delta_p, sigma_p ] = lowLatencyPathBetweenNodes( H, v, request.dk );
           
            % check if the path meets the delay and jitter requirements
            if( (delta_p < ck_maximumLatency) &&  (sigma_p < ck_maximumJitter) )
                P = [P path];
            end
                
        end
        
        if( ~isempty(P) )
            
            % select one path from P with the following priorities:
            % 1. minimum latency. 
            % 2. maximum avialabe bw. 
            % 3. minimum hop count
            % 4. random
            path = lbslsMinLatencyMaxAvialableBW(G, P);
          
        
            % if BL could not be served
            if( layer == 0 )
                % try to remove EL's for this BL
                
                % if still empty, remove upper layers
            else
                % remove upper layers
            end
            
         % P isn't empty   
        else
            

            
        end
            
    end       
  
end

