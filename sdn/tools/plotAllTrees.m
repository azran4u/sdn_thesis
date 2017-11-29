function plotAllTrees( G, requestTable )

    % read usedFor table of G
    usedFor = G.Nodes.usedFor;
    
    % find valid trees
    treeIndices = sum(usedFor,1);
    treeIndices = find((treeIndices>1));
    
    % plot each tree
    for treeIndex = treeIndices

        plotTree( G, requestTable, treeIndex );
        
    end
    
 

end

