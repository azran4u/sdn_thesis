function [ latency ] = nodeLatencyInTree( G, v, ck, lk )

    sckiTree=treeIndex(ck, lk);
    latency = G.Nodes.treeLatency(v,sckiTree);

end

