function [ availableBW ] = pathAvailableBW( G, path )
    if( isempty(path) )
        availableBW = 0;
        return;
    end
            
    availableBW = inf;
    pathLength = size(path,2);
    for i = 1:(pathLength-1)
        edgeBw = G.Edges.bw(findedge(G,path(i),path(i+1)));
        if( edgeBw < availableBW )
            availableBW = edgeBw;
        end
    end
end

