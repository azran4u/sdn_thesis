function [ G ] = buildWanNetwork( )

    s = [1 1 1 2 4];
    t = [2 4 3 4 2];
    bw = [6 6.5 7 11.5 17]';
    latency = [6 6.5 7 11.5 17]';
    jitter = [6 6.5 7 11.5 17]';
    
    EdgeTable = table([s' t'], bw, latency, jitter, 'VariableNames',{'EndNodes' 'bw' 'latency' 'jitter'});
    
    type = {'r' 'r' 's' 't'}';
    NodeTable = table(type,'VariableNames',{'type'});
    
    G = graph(EdgeTable,NodeTable);
    plot(G,'NodeLabel',G.Nodes.type,'EdgeLabel',G.Edges.bw);

end

