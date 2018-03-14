function [ jitter ] = nodeJitterInTree( G, v, ck, lk )

    sckiTree=treeIndex(ck, lk);
    jitter = G.Nodes.treeJitter(v,sckiTree);
    
end
