function [ path ] = lsPathSelectionAlgorithm( G, paths )
    % select one path from paths with the following priorities:
    % 1. maximum avialabe bw. 
    % 2. minimum hop count
    % 2. random
            
    table = pathsToTable( G, paths );

    % find maximum avialable bw
    rows = table.availableBW==max(table.availableBW);      
    data = table(rows, :);
    table = data;
    
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
   

