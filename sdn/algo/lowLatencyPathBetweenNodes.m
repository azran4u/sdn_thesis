function [ path, latency, jitter ] = lowLatencyPathBetweenNodes( G, source, destination )

    % matlab uses only 'Weight' variable as cost so we set it 
    G.Edges.Weight = G.Edges.latency;
    
    % find shortest path (minimum latency) from  source/content to reciever       
    [path,latency] = shortestpath(G, source, destination);
    
    % calc path's jitter
    jitter = pathJitter(G, path);
    
end

