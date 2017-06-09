function [G, srcAndRecCell] = buildNetworkModel(type, numOfRouters, edgeVerticesRsatio, numOfSources, numOfRecievers, maxBw, maxLatency, maxJitter)

  
    G = digraph;
    
    if strcmp(type,'simple')
            [ G, srcAndRecCell ] = buildSimpleNetwork( G );
    end
    
    if strcmp(type,'wan')
    end

end

