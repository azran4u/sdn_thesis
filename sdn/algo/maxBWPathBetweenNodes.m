function [ path, delta_p, sigma_p ] = maxBWPathBetweenNodes( G, source, destination )

    % find all paths from source to destination
    paths = allPathsBetweenNodes( G, source, destination );
    
    % select best path
    path = lsPathSelectionAlgorithm( paths );
    
    % if no path found - return
    if ( isempty(path) )
        delta_p = inf;
        sigma_p = inf;
        return;
    end
    
    % calc delay and jitter
    delta_p = pathLatency(G, path);    
    sigma_p = pathJitter(G, path);
    
end

