function [p] = plotNetworkGraph( G )

    figure;

    subplot(2,2,1);
    plot(G,'Layout','force', 'EdgeLabel',G.Edges.Latency);
    title('Latency');

    subplot(2,2,2);
    plot(G,'Layout','force', 'EdgeLabel',G.Edges.Jitter);
    title('Jitter');

    subplot(2,2,3);
    p = plot(G,'Layout','force', 'EdgeLabel',G.Edges.Bw);
    title('Bandwidth');

    subplot(2,2,4);
    plot(G,'Layout','force', 'EdgeLabel',G.Edges.probabilityOfLoss);
    title('Probability Of Loss');

end

