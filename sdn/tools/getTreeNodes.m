% get all nodes in tree that are part of (content,layer) tree
function nodes = getTreeNodes(G, content , layer)

    index = treeIndex(getGlobal_firstContent(),getGlobal_numOfLayersPerContent(), content , layer);
    nodes = G.Nodes.usedFor(:,index);
    nodes = find(nodes ==1);
    
end