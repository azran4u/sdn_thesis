function [ table ] = pathsToTable( G, paths )
    
    allPaths = cell2table(cell(0,5), 'VariableNames', {
        'path',
        'latency', 
        'jitter', 
        'availableBW', 
        'hopCount'});
    
    for ii = 1:length(paths)
        
        path = paths{ii};
        latency = pathLatency(G, path);
        jitter = pathJitter(G, path);
        availableBW = pathAvailableBW(G, path);
        hopCount = pathHopCount(G, path);
        
        path = mat2cell(path, [size(path,1)], [size(path,2)]);
        pathProperties = {path, latency, jitter, availableBW, hopCount};
        allPaths = [allPaths ; pathProperties];
          
    end
    
    table = allPaths;
end

