function plotAllTrees( G, requestTable )

    % read usedFor table of G
    treeLatency = G.Nodes.treeLatency;
    
    % find valid trees
    treeIndices = 1:size(treeLatency,2);
    %treeIndices = find((treeIndices<inf));
    
    % plot each tree
    for treeIndex = treeIndices

        plotTree( G, requestTable, treeIndex );
        
    end
   
end

