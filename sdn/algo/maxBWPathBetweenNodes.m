function [ path, delta_p, sigma_p ] = maxBWPathBetweenNodes( G, source, destination )

    paths = allPathsBetweenNodes( G, source, destination );

    path = lsPathSelectionAlgorithm( G, paths );
    
    delta_p = pathLatency(G, path);
    
    sigma_p = pathJitter(G, path);
    
end

