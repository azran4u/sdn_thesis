function [bins ] = centralityApp( G )

    deg_ranks = centrality(G,'betweenness','Cost',G.Edges.Bw);
    edges = linspace(min(deg_ranks),max(deg_ranks),7);
    bins = discretize(deg_ranks,edges);

%     wbc = centrality(G,'betweenness','Cost',G.Edges.Bw);
%     n = numnodes(G);
%     p.NodeCData = 2*wbc./((n-2)*(n-1));
%     figure;
%     colormap(flip(autumn,1));
%     title('Betweenness Centrality Scores - Weighted')

end

