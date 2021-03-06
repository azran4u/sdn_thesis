function [p] = plotNetworkGraph( G )

    numOfSources = size( find(strcmp('source',G.Nodes.types)) , 1);
    numOfRouters = size( find(strcmp('router',G.Nodes.types)) , 1);
    numOfContents = size( find(strcmp('content',G.Nodes.types)) , 1);
    numOfRcv = size( find(strcmp('reciever',G.Nodes.types)) , 1);
    
    table = find(strcmp('reciever',G.Nodes.types));
    if isempty(table)
        numOfActiveRecievers = 0;
    else
        numOfActiveRecievers = sum(G.Nodes.recieverPriority(table)>0);
    end    
    
    % plot the routers and sources
    p = figure;   
    h = plot(G,'EdgeLabel',G.Edges.bw, 'Layout','force');
    highlight(h,find(strcmp('source',G.Nodes.types)),'NodeColor','g');
    highlight(h,find(strcmp('router',G.Nodes.types)),'NodeColor','m');
    highlight(h,find(strcmp('content',G.Nodes.types)),'NodeColor','b');
    highlight(h,find(strcmp('reciever',G.Nodes.types)),'NodeColor','c');
    title(['#sources = ', num2str(numOfSources) ' #routers = ', num2str(numOfRouters) ' #content = ', num2str(numOfContents) ' #recievers = ', num2str(numOfActiveRecievers) ' / ', num2str(numOfRcv)]);    
    hold on;
        
    % just for legend that is not related to the graph
    h = zeros(3, 1);
    h(1) = plot(NaN,NaN,'g');
    h(2) = plot(NaN,NaN,'m');
    h(3) = plot(NaN,NaN,'b');
    h(4) = plot(NaN,NaN,'c');
    legend(h, 'source','router', 'content', 'reciever');

end

