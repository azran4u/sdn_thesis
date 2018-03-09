function [solution] = kcentrality( G )

    recieverNodes = find(strcmp('reciever',G.Nodes.types));
    numOfRcv = size(recieverNodes, 1);
    
    % solution = {reciever, BLpath, EL1path, EL2path}
    solution =  cell(recieverNodes ,3);
    
    routers = find(strcmp('router',G.Nodes.types));
    routersSubGraph = subgraph(G, routers);
    figure;   
    h = plot(routersSubGraph,'EdgeLabel',routersSubGraph.Edges.bw);
    
    
    
%     deg_ranks = centrality(G,'betweenness','Cost',G.Edges.Bw);
%     edges = linspace(min(deg_ranks),max(deg_ranks),7);
%     bins = discretize(deg_ranks,edges);

%     wbc = centrality(G,'betweenness','Cost',G.Edges.Bw);
%     n = numnodes(G);
%     p.NodeCData = 2*wbc./((n-2)*(n-1));
%     figure;
%     colormap(flip(autumn,1));
%     title('Betweenness Centrality Scores - Weighted')

end

