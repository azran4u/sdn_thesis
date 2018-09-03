% for each node in tree (ck,lk) update the avialable bw so we don't count
% it twice if we serve a request on the same links (edges)
function [H] = LLVSsetBwOfSckiEdges(G, content, layer)
    
    H = G;
    
    % find all edges of (ck,lk)
    index = treeIndex(content , layer);
    edges = H.Edges.treeUsed(:,index);
    edges = find(edges <inf);
    
    % find ck_bw
    if(layer == 0)    
        ck_bw = H.Nodes.baseLayerBW(content);
    elseif (layer==1)
        ck_bw = H.Nodes.enhancementLayer1BW(content);
    elseif (layer==2)
        ck_bw = H.Nodes.enhancementLayer2BW(content);
    end

    % update bw of edges
    H.Edges.bw(edges) = H.Edges.bw(edges) + ck_bw;
    
end