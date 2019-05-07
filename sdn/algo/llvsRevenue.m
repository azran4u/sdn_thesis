function [ totalRevenue, requestTable ] = llvsRevenue( requestTable )
    
    totalRevenue = 0;

    % run over all requests that are serviced
    for row = 1:height(requestTable)
        
        % get request parameters
        gama_k_i = requestTable(row, :);
        
        % extract values from request
        recieverPriority = gama_k_i.recieverPriority;
        %contentPriority = gama_k_i.contentPriority;
        duration = gama_k_i.duration;
        layer = gama_k_i.layer;
        latency = gama_k_i.selectedPathLatency;
        
        % if request is served
        if( latency > 0 )
            requestRevenue = llvsSingleRequestRevenue(duration, layer, recieverPriority);
            requestTable.revenue(row) = requestRevenue;
            totalRevenue = totalRevenue + requestRevenue;
        end
        
    end

end
