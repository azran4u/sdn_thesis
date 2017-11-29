function v = pathValue( G, path )

    pathVector = path{1,1};
    
    pathLatency = 0;
    pathJitter = 0;
    pathProbabilityOfLoss = 1;
    
    [temp,numberOfNodesInPath]=size(pathVector);
    for i=1:(numberOfNodesInPath-1)
        edgeSideA = pathVector(i);
        edgeSideB = pathVector(i+1);
        currentEdgeIndex = findedge(G,edgeSideA,edgeSideB);
        if( currentEdgeIndex == 0 ) % edge not in graph
            error('edge not found. sideA = %d, sideB = %d', edgeSideA, edgeSideB);
        end
        
        currentEdgeLatency = G.Edges.Latency(currentEdgeIndex);
        currentEdgeJitter = G.Edges.Jitter(currentEdgeIndex);
        currentEdgeProbabilityOfLoss = G.Edges.probabilityOfLoss(currentEdgeIndex);
        
        pathLatency = pathLatency + currentEdgeLatency;
        pathJitter = pathJitter + currentEdgeJitter;
        pathProbabilityOfLoss = pathProbabilityOfLoss * (1-currentEdgeProbabilityOfLoss);
    end
    
    pathProbabilityOfLoss = 1 - pathProbabilityOfLoss;
    
    alpha = 1;
    beta = 1;
    sigma = 1;
    
    v = 1/(alpha*pathLatency + beta*pathJitter + sigma*pathProbabilityOfLoss);

end

