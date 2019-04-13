function [ path ] = lbslsPathSelectionAlgorithm( G, paths)
    % select one path from paths with the following priorities:
    % 1. minimum latency. 
    % 2. maximum avialabe bw. 
    % 4. minimum jitter
    % 3. minimum hop count
    % 4. random
            
    P=paths(:,1);
    delta_p=cell2mat(paths(:,2));
    sigma_p=cell2mat(paths(:,3));
    
    table = pathsToTable( G, P );

    % find minimum latency
    %rows = table.latency==min(table.latency);   
    rows = delta_p==min(delta_p);
    data = table(rows, :);
    table = data;
    
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
   

