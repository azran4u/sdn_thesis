function [ latency ] = pathLatency( G, path )
    
    if( isempty(path) )
        latency = inf;
        return;
    end
            
    latency = 0;
    pathLength = size(path,2);
    for i = 1:(pathLength-1)
        latency = latency + G.Edges.latency(findedge(G,path(i),path(i+1)));
    end
    
end

