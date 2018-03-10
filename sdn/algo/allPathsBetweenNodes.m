function [ allPaths ] = allPathsBetweenNodes( G, source, destination )

    paths = pathbetweennodes(adjacency(G) ,source, destination);
    
    allPaths = pathsToTable( G, paths );
   
end

