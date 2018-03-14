function [ path ] = lbslsPathSelectionAlgorithm( G, paths )
    % select one path from paths with the following priorities:
    % 1. minimum latency. 
    % 2. maximum avialabe bw. 
    % 4. minimum jitter
    % 3. minimum hop count
    % 4. random
            
    table = pathsToTable( G, paths );

    % find minimum latency
    rows = table.latency==min(table.latency);      
    data = table(rows, :);
    table = data;
    
    % find maximum avialable bw
    
    % find minimum hop count
    rows = table.hopCount==min(table.hopCount);
    data = table(rows, :);
    table = data;
        
    % choose randomlly    
    rows = randi(size(table,1));
    data = table(rows, :);
    table = data;
    
    res = table.path;
    path = res{1};               
    
end            
   

