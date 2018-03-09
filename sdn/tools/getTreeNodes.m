% get all nodes in tree that are part of (content,layer) tree
function nodes = getTreeNodes(G, content , layer)

    index = treeIndex(content , layer);
    nodes = G.Nodes.treeLatency(:,index);
    nodes = find(nodes <inf);
    
end