function [ jitter ] = pathJitter( G, path )
    
    if( isempty(path) )
        jitter = inf;
        return;
    end
            
    jitter = 0;
    pathLength = size(path,2);
    for i = 1:(pathLength-1)
        jitter = jitter + G.Edges.jitter(findedge(G,path(i),path(i+1)));
    end
end

