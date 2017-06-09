function [G, srcAndRecCell] = buildNetworkModel(type, numOfRouters, edgeVerticesRsatio, numOfSources, numOfRecievers, maxBw, maxLatency, maxJitter)

    % s1 --> r1,r2
    % s2 --> r3
    G = digraph;
    
    if strcmp(type,'simple')
        
        G = addnode(G,{'s1'});
        G = addnode(G,{'s2'});
        G = addnode(G,{'r1'});
        G = addnode(G,{'r2'});
        G = addnode(G,{'r3'});
        G = addnode(G,{'v1'});
        G = addnode(G,{'v2'});
        G = addnode(G,{'v3'});
        G = addnode(G,{'v4'});

        G = addedge(G, {'s1'}, {'v1'});
        G = addedge(G, {'s2'}, {'v2'});
        G = addedge(G, {'v4'}, {'r1'});
        G = addedge(G, {'v3'}, {'r2'});
        G = addedge(G, {'v4'}, {'r3'});
        G = addedge(G, {'v1'}, {'v2'});
        G = addedge(G, {'v2'}, {'v1'});
        G = addedge(G, {'v1'}, {'v3'});
        G = addedge(G, {'v3'}, {'v1'});
        G = addedge(G, {'v4'}, {'v2'});
        G = addedge(G, {'v2'}, {'v4'});
        G = addedge(G, {'v4'}, {'v3'});
        G = addedge(G, {'v3'}, {'v4'});
        G = addedge(G, {'v2'}, {'v3'});
        G = addedge(G, {'v3'}, {'v2'});

        % Edge Latency [ms]
        G.Edges.Latency( findedge(G,'s1','v1') ) = 1;
        G.Edges.Latency( findedge(G,'s2','v2') ) = 2;
        G.Edges.Latency( findedge(G,'v4','r1') ) = 3;
        G.Edges.Latency( findedge(G,'v3','r2') ) = 3;
        G.Edges.Latency( findedge(G,'v4','r3') ) = 3;
        G.Edges.Latency( findedge(G,'v1','v2') ) = 10;
        G.Edges.Latency( findedge(G,'v2','v1') ) = 7;
        G.Edges.Latency( findedge(G,'v1','v3') ) = 3;
        G.Edges.Latency( findedge(G,'v3','v1') ) = 1;
        G.Edges.Latency( findedge(G,'v4','v2') ) = 5;
        G.Edges.Latency( findedge(G,'v2','v4') ) = 8;
        G.Edges.Latency( findedge(G,'v4','v3') ) = 2;
        G.Edges.Latency( findedge(G,'v3','v4') ) = 4;
        G.Edges.Latency( findedge(G,'v2','v3') ) = 7;
        G.Edges.Latency( findedge(G,'v3','v2') ) = 9;


        % Edge Jitter [ms]
        G.Edges.Jitter( findedge(G,'s1','v1') ) = 1;
        G.Edges.Jitter( findedge(G,'s2','v2') ) = 1;
        G.Edges.Jitter( findedge(G,'v4','r1') ) = 2;
        G.Edges.Jitter( findedge(G,'v3','r2') ) = 2;
        G.Edges.Jitter( findedge(G,'v4','r3') ) = 2;
        G.Edges.Jitter( findedge(G,'v1','v2') ) = 2;
        G.Edges.Jitter( findedge(G,'v2','v1') ) = 1;
        G.Edges.Jitter( findedge(G,'v1','v3') ) = 0;
        G.Edges.Jitter( findedge(G,'v3','v1') ) = 1;
        G.Edges.Jitter( findedge(G,'v4','v2') ) = 1;
        G.Edges.Jitter( findedge(G,'v2','v4') ) = 2;
        G.Edges.Jitter( findedge(G,'v4','v3') ) = 3;
        G.Edges.Jitter( findedge(G,'v3','v4') ) = 2;
        G.Edges.Jitter( findedge(G,'v2','v3') ) = 1;
        G.Edges.Jitter( findedge(G,'v3','v2') ) = 0;


        % Edge Bandwidth [Mbps]
        G.Edges.Bw( findedge(G,'s1','v1') ) = 10;
        G.Edges.Bw( findedge(G,'s2','v2') ) = 10;
        G.Edges.Bw( findedge(G,'v4','r1') ) = 100;
        G.Edges.Bw( findedge(G,'v3','r2') ) = 100;
        G.Edges.Bw( findedge(G,'v4','r3') ) = 100;
        G.Edges.Bw( findedge(G,'v1','v2') ) = 10;
        G.Edges.Bw( findedge(G,'v2','v1') ) = 10;
        G.Edges.Bw( findedge(G,'v1','v3') ) = 100;
        G.Edges.Bw( findedge(G,'v3','v1') ) = 10;
        G.Edges.Bw( findedge(G,'v4','v2') ) = 10;
        G.Edges.Bw( findedge(G,'v2','v4') ) = 10;
        G.Edges.Bw( findedge(G,'v4','v3') ) = 10;
        G.Edges.Bw( findedge(G,'v3','v4') ) = 10;
        G.Edges.Bw( findedge(G,'v2','v3') ) = 10;
        G.Edges.Bw( findedge(G,'v3','v2') ) = 10;


        % Edge Loss Probability [0..1]
        G.Edges.probabilityOfLoss( findedge(G,'s1','v1') ) = 0.1;
        G.Edges.probabilityOfLoss( findedge(G,'s2','v2') ) = 0.1;
        G.Edges.probabilityOfLoss( findedge(G,'v4','r1') ) = 0.3;
        G.Edges.probabilityOfLoss( findedge(G,'v3','r2') ) = 0.3;
        G.Edges.probabilityOfLoss( findedge(G,'v4','r3') ) = 0.3;
        G.Edges.probabilityOfLoss( findedge(G,'v1','v2') ) = 0.2;
        G.Edges.probabilityOfLoss( findedge(G,'v2','v1') ) = 0.01;
        G.Edges.probabilityOfLoss( findedge(G,'v1','v3') ) = 0.3;
        G.Edges.probabilityOfLoss( findedge(G,'v3','v1') ) = 0.02;
        G.Edges.probabilityOfLoss( findedge(G,'v4','v2') ) = 0.01;
        G.Edges.probabilityOfLoss( findedge(G,'v2','v4') ) = 0.4;
        G.Edges.probabilityOfLoss( findedge(G,'v4','v3') ) = 0.2;
        G.Edges.probabilityOfLoss( findedge(G,'v3','v4') ) = 0.3;
        G.Edges.probabilityOfLoss( findedge(G,'v2','v3') ) = 0.2;
        G.Edges.probabilityOfLoss( findedge(G,'v3','v2') ) = 0.1;

        srcAndRecCell = cell(2,1);

        srcAndRecCell{1,1} = cellstr(['s1';'r1';'r2']);
        srcAndRecCell{2,1} = cellstr(['s2';'r3']);

    end
    

end

