function [ table ] = pathsToTable( G, paths )
    
    allPaths = cell2table(cell(0,5), 'VariableNames', {
        'path',
        'latency', 
        'jitter', 
        'availableBW', 
        'hopCount'});
    
    for ii = 1:size(paths,1)
        
        path = paths{ii, 1}; 
        latency = pathLatency(G, path); 
        jitter = pathJitter(G, path);
        %latency = paths{ii, 2}; % delta_p
        %jitter = paths{ii, 3}; % sigma_p        
        availableBW = pathAvailableBW(G, path);
        hopCount = pathHopCount(G, path);
        
        path = mat2cell(path, [size(path,1)], [size(path,2)]);
        pathProperties = {path, latency, jitter, availableBW, hopCount};
        allPaths = [allPaths ; pathProperties];
          
    end
    
    table = allPaths;
end

