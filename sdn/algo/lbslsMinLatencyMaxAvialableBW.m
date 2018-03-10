function [ path ] = lbslsMinLatencyMaxAvialableBW( G, paths )
    % select one path from paths with the following priorities:
    % 1. minimum latency. 
    % 2. maximum avialabe bw. 
    % 3. minimum hop count
    % 4. random
            
    table = pathsToTable( G, paths );
    
    rows = table.latency==min(table.latency);
    
    table = table(rows);
    
end

