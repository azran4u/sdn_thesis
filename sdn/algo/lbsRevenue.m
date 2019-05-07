function [ totalRevenue, requestTable ] = lbsRevenue( requestTable, w )
    
    totalRevenue = 0;

    % run over all requests that are serviced
    for row = 1:height(requestTable)
        
        % get request parameters
        gama_k_i = requestTable(row, :);
        
        % extract values from request        
        duration = gama_k_i.duration;
        layer = gama_k_i.layer;        
        
        % if request is served
        if( ~isempty(gama_k_i.selectedPath) )
            requestRevenue = lbsSingleRequestRevenue(duration, layer, w);
            requestTable.revenue(row) = requestRevenue;
            totalRevenue = totalRevenue + requestRevenue;
        end
        
    end

end

